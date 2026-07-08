import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klangor/services/audio/massiv_audio_handler.dart';

void main() {
  group('shouldSkipLocalEngineBroadcast', () {
    // Pins the invariant that prevents the local just_audio engine's idle
    // state from stomping on provider-pushed remote/local-mode notification
    // state (see the doc comment on the function itself for the history of
    // why this exists and must not be casually "simplified").
    test('skips when in remote mode, even with no current media item', () {
      expect(
        shouldSkipLocalEngineBroadcast(isRemoteMode: true, currentMediaItem: null),
        isTrue,
      );
    });

    test('skips when a current media item is set, even outside remote mode', () {
      const item = MediaItem(id: 'track-1', title: 'Test Track');
      expect(
        shouldSkipLocalEngineBroadcast(isRemoteMode: false, currentMediaItem: item),
        isTrue,
      );
    });

    test('skips when both remote mode and a current media item are set', () {
      const item = MediaItem(id: 'track-1', title: 'Test Track');
      expect(
        shouldSkipLocalEngineBroadcast(isRemoteMode: true, currentMediaItem: item),
        isTrue,
      );
    });

    test('does not skip for genuinely local, idle just_audio playback', () {
      expect(
        shouldSkipLocalEngineBroadcast(isRemoteMode: false, currentMediaItem: null),
        isFalse,
      );
    });
  });
}
