import 'dart:convert';
import 'package:http/http.dart' as http;
import 'debug_logger.dart';
import 'settings_service.dart';
import '../utils/lru_cache.dart';

class MetadataService {
  static final _logger = DebugLogger();

  /// Cache for artist/album descriptions (100 entries)
  static final LruCache<String, String> _descriptionCache = LruCache(maxSize: 100);

  /// Fetches artist biography/description with fallback chain:
  /// 1. Music Assistant metadata (passed in)
  /// 2. Last.fm API (if key configured)
  /// 3. TheAudioDB API (if key configured)
  static Future<String?> getArtistDescription(
    String artistName,
    Map<String, dynamic>? musicAssistantMetadata,
  ) async {
    // Try Music Assistant metadata first
    if (musicAssistantMetadata != null) {
      final maDescription = musicAssistantMetadata['description'] ??
          musicAssistantMetadata['biography'] ??
          musicAssistantMetadata['wiki'] ??
          musicAssistantMetadata['bio'] ??
          musicAssistantMetadata['summary'];

      if (maDescription != null && (maDescription as String).trim().isNotEmpty) {
        return maDescription;
      }
    }

    // Check cache
    final cacheKey = 'artist:$artistName';
    if (_descriptionCache.containsKey(cacheKey)) {
      return _descriptionCache[cacheKey];
    }

    // Try Last.fm API
    final lastFmKey = await SettingsService.getLastFmApiKey();
    if (lastFmKey != null && lastFmKey.isNotEmpty) {
      final lastFmDesc = await _fetchFromLastFm(artistName, null, lastFmKey);
      if (lastFmDesc != null) {
        _descriptionCache[cacheKey] = lastFmDesc;
        return lastFmDesc;
      }
    }

    // Try TheAudioDB API
    final audioDbKey = await SettingsService.getTheAudioDbApiKey();
    if (audioDbKey != null && audioDbKey.isNotEmpty) {
      final audioDbDesc = await _fetchFromTheAudioDb(artistName, audioDbKey);
      if (audioDbDesc != null) {
        _descriptionCache[cacheKey] = audioDbDesc;
        return audioDbDesc;
      }
    }

    return null;
  }

  /// Fetches album description with fallback chain:
  /// 1. Music Assistant metadata (passed in)
  /// 2. Last.fm API (if key configured)
  static Future<String?> getAlbumDescription(
    String artistName,
    String albumName,
    Map<String, dynamic>? musicAssistantMetadata,
  ) async {
    // Try Music Assistant metadata first
    if (musicAssistantMetadata != null) {
      final maDescription = musicAssistantMetadata['description'] ??
          musicAssistantMetadata['wiki'] ??
          musicAssistantMetadata['biography'] ??
          musicAssistantMetadata['summary'];

      if (maDescription != null && (maDescription as String).trim().isNotEmpty) {
        return maDescription;
      }
    }

    // Check cache
    final cacheKey = 'album:$artistName:$albumName';
    if (_descriptionCache.containsKey(cacheKey)) {
      return _descriptionCache[cacheKey];
    }

    // Try Last.fm API (TheAudioDB doesn't have good album info)
    final lastFmKey = await SettingsService.getLastFmApiKey();
    if (lastFmKey != null && lastFmKey.isNotEmpty) {
      final lastFmDesc = await _fetchFromLastFm(artistName, albumName, lastFmKey);
      if (lastFmDesc != null) {
        _descriptionCache[cacheKey] = lastFmDesc;
        return lastFmDesc;
      }
    }

    return null;
  }

  static Future<String?> _fetchFromLastFm(
    String artistName,
    String? albumName,
    String apiKey,
  ) async {
    try {
      final String method;
      final Map<String, String> params = {
        'api_key': apiKey,
        'format': 'json',
      };

      if (albumName != null) {
        // Album info
        method = 'album.getinfo';
        params['artist'] = artistName;
        params['album'] = albumName;
      } else {
        // Artist info
        method = 'artist.getinfo';
        params['artist'] = artistName;
      }

      params['method'] = method;

      final uri = Uri.https('ws.audioscrobbler.com', '/2.0/', params);
      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (albumName != null) {
          // Parse album response
          final album = data['album'];
          if (album != null) {
            final wiki = album['wiki'];
            if (wiki != null) {
              // Prefer summary, fall back to content
              return _cleanLastFmText(wiki['summary'] ?? wiki['content']);
            }
          }
        } else {
          // Parse artist response
          final artist = data['artist'];
          if (artist != null) {
            final bio = artist['bio'];
            if (bio != null) {
              // Prefer summary, fall back to content
              return _cleanLastFmText(bio['summary'] ?? bio['content']);
            }
          }
        }
      }
    } catch (e) {
      _logger.warning('Last.fm API error: $e', context: 'Metadata');
    }
    return null;
  }

  static Future<String?> _fetchFromTheAudioDb(
    String artistName,
    String apiKey,
  ) async {
    try {
      final uri = Uri.https(
        'theaudiodb.com',
        '/api/v1/json/$apiKey/search.php',
        {'s': artistName},
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final artists = data['artists'];

        if (artists != null && artists.isNotEmpty) {
          final artist = artists[0];
          // Try multiple language fields
          return artist['strBiographyEN'] ??
              artist['strBiographyDE'] ??
              artist['strBiographyFR'] ??
              artist['strBiographyIT'] ??
              artist['strBiographyES'];
        }
      }
    } catch (e) {
      _logger.warning('TheAudioDB API error: $e', context: 'Metadata');
    }
    return null;
  }

  /// Removes Last.fm HTML tags and links
  static String? _cleanLastFmText(String? text) {
    if (text == null) return null;

    // Remove <a href...> tags
    text = text.replaceAll(RegExp(r'<a[^>]*>'), '');
    text = text.replaceAll('</a>', '');

    // Remove "Read more on Last.fm" footer
    text = text.replaceAll(RegExp(r'\s*<a[^>]*>.*?</a>.*$'), '');

    // Clean up any remaining HTML
    text = text.replaceAll(RegExp(r'<[^>]*>'), '');

    return text.trim();
  }

  /// Cache for lyrics - uses bounded Map with manual size limiting (500 entries max)
  /// Stores (plainLyrics, syncedLyrics) tuples or null for failed lookups
  static final Map<String, (String?, String?)?> _lyricsCache = {};
  static const int _lyricsCacheMaxSize = 500;

  /// Fetches lyrics from LRCLIB (free, no API key required)
  /// Returns a tuple of (plainLyrics, syncedLyrics) or null if not found
  /// LRCLIB provides both synced (LRC format) and plain lyrics
  static Future<(String?, String?)?> getTrackLyrics({
    required String trackName,
    required String artistName,
    String? albumName,
    int? durationSeconds,
  }) async {
    // Build cache key
    final cacheKey = 'lyrics:$artistName:$trackName';
    if (_lyricsCache.containsKey(cacheKey)) {
      return _lyricsCache[cacheKey];
    }

    // Try LRCLIB API
    try {
      final params = <String, String>{
        'track_name': trackName,
        'artist_name': artistName,
      };
      if (albumName != null && albumName.isNotEmpty) {
        params['album_name'] = albumName;
      }
      if (durationSeconds != null && durationSeconds > 0) {
        params['duration'] = durationSeconds.toString();
      }

      final uri = Uri.https('lrclib.net', '/api/get', params);
      _logger.log('🎤 Fetching lyrics from LRCLIB: $trackName by $artistName');

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'Ensemble Music Player (https://github.com/ensemble-app)',
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final plainLyrics = data['plainLyrics'] as String?;
        final syncedLyrics = data['syncedLyrics'] as String?;

        if ((plainLyrics != null && plainLyrics.isNotEmpty) ||
            (syncedLyrics != null && syncedLyrics.isNotEmpty)) {
          _logger.log('🎤 LRCLIB found lyrics: plain=${plainLyrics?.length ?? 0} chars, synced=${syncedLyrics?.length ?? 0} chars');
          final result = (plainLyrics, syncedLyrics);
          _evictLyricsCacheIfNeeded();
          _lyricsCache[cacheKey] = result;
          return result;
        }
      } else if (response.statusCode == 404) {
        _logger.log('🎤 LRCLIB: No lyrics found for $trackName');
      } else {
        _logger.log('🎤 LRCLIB error: ${response.statusCode}');
      }
    } catch (e) {
      _logger.warning('LRCLIB API error: $e', context: 'Metadata');
    }

    // Cache the null result to avoid repeated failed lookups
    _evictLyricsCacheIfNeeded();
    _lyricsCache[cacheKey] = null;
    return null;
  }

  /// Evict oldest entries from lyrics cache if over max size
  static void _evictLyricsCacheIfNeeded() {
    while (_lyricsCache.length >= _lyricsCacheMaxSize) {
      _lyricsCache.remove(_lyricsCache.keys.first);
    }
  }

  /// Clears all metadata caches
  static void clearCache() {
    _descriptionCache.clear();
    _lyricsCache.clear();
  }
}
