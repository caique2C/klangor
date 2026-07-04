import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'debug_logger.dart';

/// Custom cache manager for album (and audiobook) images with extended retention
class AlbumImageCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'albumImageCache';

  static final AlbumImageCacheManager _instance = AlbumImageCacheManager._();
  factory AlbumImageCacheManager() => _instance;

  AlbumImageCacheManager._()
      : super(Config(
          key,
          stalePeriod: const Duration(days: 30),
          maxNrOfCacheObjects: 2000,
        ));
}

/// Custom cache manager for artist images with extended retention.
/// Kept separate from [AlbumImageCacheManager] so artists and albums each
/// get their own eviction budget instead of competing for the same slots.
class ArtistImageCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'artistImageCache';

  static final ArtistImageCacheManager _instance = ArtistImageCacheManager._();
  factory ArtistImageCacheManager() => _instance;

  ArtistImageCacheManager._()
      : super(Config(
          key,
          stalePeriod: const Duration(days: 30),
          maxNrOfCacheObjects: 2000,
        ));
}

/// Service to prefetch album/artist images in the background after sync
class ImagePrefetchService {
  static final _logger = DebugLogger();
  bool _cancelled = false;

  /// Cancel any in-progress prefetch
  void cancel() {
    _cancelled = true;
  }

  /// Prefetch images in batches, skipping already-cached URLs
  Future<void> prefetchImages(List<String> urls, {CacheManager? cacheManager}) async {
    _cancelled = false;
    if (urls.isEmpty) return;

    final manager = cacheManager ?? AlbumImageCacheManager();
    int cached = 0;
    int skipped = 0;
    int failed = 0;

    const batchSize = 10;
    for (var i = 0; i < urls.length; i += batchSize) {
      if (_cancelled) {
        _logger.log('🖼️ Image prefetch cancelled after $cached cached, $skipped skipped');
        return;
      }

      final batch = urls.skip(i).take(batchSize);
      await Future.wait(batch.map((url) async {
        try {
          final fileInfo = await manager.getFileFromCache(url);
          if (fileInfo != null) {
            skipped++;
            return;
          }
          await manager.downloadFile(url);
          cached++;
        } catch (_) {
          failed++;
        }
      }));
    }

    _logger.log('🖼️ Image prefetch complete: $cached cached, $skipped already cached, $failed failed (${urls.length} total)');
  }
}
