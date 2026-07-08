import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klangor/database/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    // In-memory sqlite via drift's native executor - no device/host file needed.
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Profiles', () {
    test('setActiveProfile creates a profile and marks it active', () async {
      final profile = await db.setActiveProfile(username: 'alice', source: 'manual');

      expect(profile.username, 'alice');
      expect(profile.isActive, isTrue);

      final active = await db.getActiveProfile();
      expect(active?.username, 'alice');
    });

    test('setActiveProfile deactivates the previously active profile', () async {
      await db.setActiveProfile(username: 'alice', source: 'manual');
      await db.setActiveProfile(username: 'bob', source: 'manual');

      final all = await db.getAllProfiles();
      final alice = all.firstWhere((p) => p.username == 'alice');
      final bob = all.firstWhere((p) => p.username == 'bob');

      expect(alice.isActive, isFalse);
      expect(bob.isActive, isTrue);
    });
  });

  group('LibraryCache', () {
    test('cacheItem then getCachedItem round-trips the same data', () async {
      await db.cacheItem(itemType: 'album', itemId: 'a1', data: '{"name":"Test Album"}');

      final item = await db.getCachedItem('album', 'a1');
      expect(item, isNotNull);
      expect(item!.data, '{"name":"Test Album"}');
      expect(item.isDeleted, isFalse);
    });

    test('markItemsDeleted soft-deletes without removing the row', () async {
      await db.cacheItem(itemType: 'album', itemId: 'a1', data: '{}');
      await db.markItemsDeleted('album', ['a1']);

      final item = await db.getCachedItem('album', 'a1');
      expect(item, isNotNull);
      expect(item!.isDeleted, isTrue);

      final active = await db.getCachedItems('album');
      expect(active, isEmpty);
    });

    test('batchCacheItems inserts all items and is queryable by type', () async {
      await db.batchCacheItems([
        const BatchCacheItem(itemType: 'track', itemId: 't1', data: '{"name":"One"}'),
        const BatchCacheItem(itemType: 'track', itemId: 't2', data: '{"name":"Two"}'),
      ]);

      final tracks = await db.getCachedItems('track');
      expect(tracks, hasLength(2));
    });
  });

  group('SyncMetadata', () {
    test('needsSync is true before any sync has been recorded', () async {
      expect(await db.needsSync('albums', const Duration(minutes: 5)), isTrue);
    });

    test('needsSync is false immediately after a sync is recorded', () async {
      await db.updateSyncMetadata('albums', 10);
      expect(await db.needsSync('albums', const Duration(minutes: 5)), isFalse);
    });
  });

  group('PlaybackState', () {
    test('savePlaybackState then getPlaybackState round-trips', () async {
      await db.savePlaybackState(
        playerId: 'player-1',
        playerName: 'Kitchen',
        currentTrackJson: '{"name":"Song"}',
        positionSeconds: 12.5,
        isPlaying: true,
      );

      final state = await db.getPlaybackState();
      expect(state?.playerId, 'player-1');
      expect(state?.positionSeconds, 12.5);
      expect(state?.isPlaying, isTrue);
    });
  });
}
