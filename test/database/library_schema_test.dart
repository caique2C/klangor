import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klangor/database/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Artists/Albums/Tracks/Playlists', () {
    test('insert and read back an artist keyed by (provider, itemId)', () async {
      await db.into(db.artists).insert(ArtistsCompanion.insert(
            provider: 'library',
            itemId: '1',
            name: 'Test Artist',
            lastSynced: DateTime.now(),
          ));

      final rows = await db.select(db.artists).get();
      expect(rows, hasLength(1));
      expect(rows.single.name, 'Test Artist');
      expect(rows.single.favorite, isFalse);
    });

    test('two different providers can reuse the same itemId without colliding', () async {
      final now = DateTime.now();
      await db.into(db.artists).insert(ArtistsCompanion.insert(
            provider: 'library', itemId: '1', name: 'Library Artist', lastSynced: now,
          ));
      await db.into(db.artists).insert(ArtistsCompanion.insert(
            provider: 'spotify--abc', itemId: '1', name: 'Spotify Artist', lastSynced: now,
          ));

      final rows = await db.select(db.artists).get();
      expect(rows, hasLength(2));
      expect(rows.map((r) => r.name), containsAll(['Library Artist', 'Spotify Artist']));
    });

    test('album stores year/albumType and a denormalized artist list', () async {
      await db.into(db.albums).insert(AlbumsCompanion.insert(
            provider: 'library',
            itemId: '10',
            name: 'Test Album',
            year: const Value(1999),
            albumType: const Value('album'),
            artistsJson: const Value('[{"item_id":"1","provider":"library","name":"Test Artist"}]'),
            lastSynced: DateTime.now(),
          ));

      final album = await db.select(db.albums).getSingle();
      expect(album.year, 1999);
      expect(album.artistsJson, contains('Test Artist'));
    });

    test('tracks for an album are queryable by (albumProvider, albumItemId), ordered by position', () async {
      final now = DateTime.now();
      await db.batch((b) {
        b.insertAll(db.tracks, [
          TracksCompanion.insert(
            provider: 'library', itemId: '102', name: 'Track 2',
            albumProvider: const Value('library'), albumItemId: const Value('10'),
            position: const Value(2), lastSynced: now,
          ),
          TracksCompanion.insert(
            provider: 'library', itemId: '101', name: 'Track 1',
            albumProvider: const Value('library'), albumItemId: const Value('10'),
            position: const Value(1), lastSynced: now,
          ),
          TracksCompanion.insert(
            provider: 'library', itemId: '201', name: 'Other album track',
            albumProvider: const Value('library'), albumItemId: const Value('99'),
            position: const Value(1), lastSynced: now,
          ),
        ]);
      });

      final query = db.select(db.tracks)
        ..where((t) => t.albumProvider.equals('library'))
        ..where((t) => t.albumItemId.equals('10'))
        ..orderBy([(t) => OrderingTerm.asc(t.position)]);
      final trackRows = await query.get();

      expect(trackRows.map((t) => t.name), ['Track 1', 'Track 2']);
    });

    test('playlist tracks are ordered via the join table, independent of track insert order', () async {
      final now = DateTime.now();
      await db.into(db.playlists).insert(PlaylistsCompanion.insert(
            provider: 'library', itemId: '50', name: 'My Playlist', lastSynced: now,
          ));
      await db.batch((b) {
        b.insertAll(db.tracks, [
          TracksCompanion.insert(provider: 'library', itemId: '1', name: 'A', lastSynced: now),
          TracksCompanion.insert(provider: 'library', itemId: '2', name: 'B', lastSynced: now),
        ]);
        b.insertAll(db.playlistTracks, [
          PlaylistTracksCompanion.insert(
            playlistProvider: 'library', playlistItemId: '50',
            trackProvider: 'library', trackItemId: '2', position: 0,
          ),
          PlaylistTracksCompanion.insert(
            playlistProvider: 'library', playlistItemId: '50',
            trackProvider: 'library', trackItemId: '1', position: 1,
          ),
        ]);
      });

      final query = db.select(db.playlistTracks)
        ..where((pt) => pt.playlistProvider.equals('library'))
        ..where((pt) => pt.playlistItemId.equals('50'))
        ..orderBy([(pt) => OrderingTerm.asc(pt.position)]);
      final rows = await query.get();

      expect(rows.map((r) => r.trackItemId), ['2', '1']);
    });

    test('a track can have multiple provider mappings', () async {
      final now = DateTime.now();
      await db.into(db.tracks).insert(TracksCompanion.insert(
            provider: 'library', itemId: '1', name: 'Track', lastSynced: now,
          ));
      await db.batch((b) {
        b.insertAll(db.providerMappings, [
          ProviderMappingsCompanion.insert(
            ownerType: 'track', ownerProvider: 'library', ownerItemId: '1',
            mappingItemId: '1', providerDomain: 'filesystem_local', providerInstance: 'filesystem_local--abc',
          ),
          ProviderMappingsCompanion.insert(
            ownerType: 'track', ownerProvider: 'library', ownerItemId: '1',
            mappingItemId: 'xyz', providerDomain: 'spotify', providerInstance: 'spotify--def',
            available: const Value(false),
          ),
        ]);
      });

      final query = db.select(db.providerMappings)
        ..where((m) => m.ownerType.equals('track'))
        ..where((m) => m.ownerProvider.equals('library'))
        ..where((m) => m.ownerItemId.equals('1'));
      final mappings = await query.get();

      expect(mappings, hasLength(2));
      expect(mappings.map((m) => m.providerDomain), containsAll(['filesystem_local', 'spotify']));
      expect(mappings.firstWhere((m) => m.providerDomain == 'spotify').available, isFalse);
    });
  });
}
