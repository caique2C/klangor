import 'package:flutter_test/flutter_test.dart';
import 'package:klangor/services/image_service.dart';

void main() {
  group('ImageService.hashUrl', () {
    test('matches the well-known MD5 test vector for "abc"', () {
      // Pinned against a standard MD5 test vector (not just self-consistency)
      // because this hash must match ArtworkContentProvider.kt's Kotlin MD5
      // implementation byte-for-byte - both sides read/write the same file
      // path with no verification between them, so a format drift (e.g.
      // uppercase hex, a different encoding) would silently break sharing.
      expect(ImageService.hashUrl('abc'), '900150983cd24fb0d6963f7d28e17f72');
    });

    test('is deterministic for the same URL', () {
      const url = 'https://example.com/artwork.jpg';
      expect(ImageService.hashUrl(url), ImageService.hashUrl(url));
    });

    test('differs for different URLs', () {
      expect(
        ImageService.hashUrl('https://example.com/a.jpg'),
        isNot(ImageService.hashUrl('https://example.com/b.jpg')),
      );
    });

    test('produces lowercase hex with no separators', () {
      final hash = ImageService.hashUrl('https://example.com/artwork.jpg');
      expect(hash, matches(RegExp(r'^[0-9a-f]{32}$')));
    });
  });

  group('ImageService.cacheDirName', () {
    test('matches the directory name ArtworkContentProvider.kt expects', () {
      // Kept as a named constant specifically so this assertion (and the
      // doc comments on both sides) catch a rename before it silently
      // breaks the shared cache.
      expect(ImageService.cacheDirName, 'shared_artwork');
    });
  });
}
