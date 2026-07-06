import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'debug_logger.dart';

/// Single on-disk artwork cache shared between the Flutter UI and Android
/// Auto's native `ArtworkContentProvider`.
///
/// Both sides store/read files under the platform's cache directory (which
/// `path_provider`'s [getTemporaryDirectory] and Android's `context.cacheDir`
/// both resolve to the same path for), in a `shared_artwork/` subdirectory,
/// keyed by `md5(url)`. Whichever side fetches a given URL first writes it
/// here for the other to reuse - there is no IPC between them, just an
/// agreed directory + hashing convention (MD5 is deterministic and
/// implemented identically on both sides).
///
/// This exists because the two sides previously ran two entirely separate
/// image caches (`flutter_cache_manager` for the UI, an independent HTTP
/// fetch in the Kotlin content provider for Android Auto) with no
/// relationship to each other, so the same artwork could be fetched and
/// stored twice - once for each surface, even on unmetered Wi-Fi.
class ImageService {
  static ImageService? _instance;
  static ImageService get instance => _instance ??= ImageService._();
  ImageService._();

  static const String cacheDirName = 'shared_artwork';
  static const Duration _fetchTimeout = Duration(seconds: 10);

  final DebugLogger _logger = DebugLogger();
  Directory? _cacheDir;

  Future<Directory> _getCacheDir() async {
    final existing = _cacheDir;
    if (existing != null) return existing;
    final base = await getTemporaryDirectory();
    final dir = Directory('${base.path}/$cacheDirName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _cacheDir = dir;
    return dir;
  }

  static String hashUrl(String url) => md5.convert(utf8.encode(url)).toString();

  /// Returns the local file for [url] if it's already cached, else null.
  /// Does not perform any network access.
  Future<File?> getCachedFile(String url) async {
    final dir = await _getCacheDir();
    final file = File('${dir.path}/${hashUrl(url)}');
    return await file.exists() ? file : null;
  }

  /// Returns the local file for [url], downloading and storing it first if
  /// it isn't already cached. Returns null on any failure (caller should
  /// fall back to its own network-loading path).
  Future<File?> fetchAndCache(String url) async {
    final dir = await _getCacheDir();
    final file = File('${dir.path}/${hashUrl(url)}');
    if (await file.exists()) return file;

    try {
      final response = await http.get(Uri.parse(url)).timeout(_fetchTimeout);
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
      _logger.debug('ImageService fetch got HTTP ${response.statusCode} for $url', context: 'ImageService');
    } catch (e) {
      _logger.debug('ImageService fetch failed for $url: $e', context: 'ImageService');
    }
    return null;
  }
}
