import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klangor/database/database.dart';
import 'package:klangor/models/media_item.dart';
import 'package:klangor/repositories/library_repository.dart';

void main() {
  late AppDatabase db;
  late LibraryRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = LibraryRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Artist artist(String itemId, String name) => Artist(itemId: itemId, provider: 'library', name: name);

  group('artist round-trip', () {
    test('upsertArtist then read back preserves fields and provider mappings', () async {
      final a = Artist(
        itemId: '1',
        provider: 'library',
        name: 'Test Artist',
        favorite: true,
        providerMappings: [
          ProviderMapping(
            itemId: '1',
            providerDomain: 'filesystem_local',
            providerInstance: 'filesystem_local--abc',
            available: true,
          ),
        ],
      );
      await repo.upsertArtist(a);

      final artists = await repo.getAllArtists();
      expect(artists, hasLength(1));
      expect(artists.single.name, 'Test Artist');
      expect(artists.single.favorite, isTrue);
      expect(artists.single.providerMappings, hasLength(1));
      expect(artists.single.providerMappings!.single.providerDomain, 'filesystem_local');
    });

    test('upserting the same (provider, itemId) again updates rather than duplicates', () async {
      await repo.upsertArtist(artist('1', 'Name A'));
      await repo.upsertArtist(artist('1', 'Name B'));

      final artists = await repo.getAllArtists();
      expect(artists, hasLength(1));
      expect(artists.single.name, 'Name B');
    });
  });

  group('getArtistAlbums', () {
    test('matches by artist name, case-insensitively', () async {
      await repo.upsertAlbum(Album(
        itemId: '10',
        provider: 'library',
        name: 'Album One',
        artists: [artist('1', 'Kalden Bess')],
      ));
      await repo.upsertAlbum(Album(
        itemId: '11',
        provider: 'library',
        name: 'Album Two',
        artists: [artist('2', 'Someone Else')],
      ));

      final albums = await repo.getArtistAlbums('kalden bess');
      expect(albums.map((a) => a.name), ['Album One']);
    });
  });

  group('getAlbumTracks', () {
    test('returns tracks for the album in position order', () async {
      await repo.upsertTrack(
        Track(itemId: '102', provider: 'library', name: 'Track 2'),
        albumProvider: 'library', albumItemId: '10', position: 2,
      );
      await repo.upsertTrack(
        Track(itemId: '101', provider: 'library', name: 'Track 1'),
        albumProvider: 'library', albumItemId: '10', position: 1,
      );
      await repo.upsertTrack(
        Track(itemId: '201', provider: 'library', name: 'Other album track'),
        albumProvider: 'library', albumItemId: '99', position: 1,
      );

      final tracks = await repo.getAlbumTracks('library', '10');
      expect(tracks.map((t) => t.name), ['Track 1', 'Track 2']);
    });
  });

  group('setPlaylistTracks / getPlaylistTracks', () {
    test('stores order and is idempotent on re-sync with a different order', () async {
      final t1 = Track(itemId: '1', provider: 'library', name: 'A');
      final t2 = Track(itemId: '2', provider: 'library', name: 'B');

      await repo.setPlaylistTracks('library', '50', [t1, t2]);
      expect((await repo.getPlaylistTracks('library', '50')).map((t) => t.name), ['A', 'B']);

      // Re-sync with reversed order - should replace, not append.
      await repo.setPlaylistTracks('library', '50', [t2, t1]);
      final tracks = await repo.getPlaylistTracks('library', '50');
      expect(tracks.map((t) => t.name), ['B', 'A']);
    });
  });

  group('provider mappings replacement', () {
    test('re-upserting with fewer mappings drops the removed ones', () async {
      final withTwo = Track(
        itemId: '1',
        provider: 'library',
        name: 'Track',
        providerMappings: [
          ProviderMapping(itemId: '1', providerDomain: 'filesystem_local', providerInstance: 'fs--a', available: true),
          ProviderMapping(itemId: 'x', providerDomain: 'spotify', providerInstance: 'sp--b', available: true),
        ],
      );
      await repo.upsertTrack(withTwo);

      final withOne = Track(
        itemId: '1',
        provider: 'library',
        name: 'Track',
        providerMappings: [
          ProviderMapping(itemId: '1', providerDomain: 'filesystem_local', providerInstance: 'fs--a', available: true),
        ],
      );
      await repo.upsertTrack(withOne);

      final mappings = await db.select(db.providerMappings).get();
      expect(mappings, hasLength(1));
      expect(mappings.single.providerDomain, 'filesystem_local');
    });
  });
}
