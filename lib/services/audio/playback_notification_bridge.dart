import 'package:audio_service/audio_service.dart';
import 'massiv_audio_handler.dart';

/// Thin seam between `MusicAssistantProvider` and the global `MassivAudioHandler`
/// singleton for "tell the OS/Android Auto what's currently playing."
///
/// Before this existed, the provider called ~19 scattered
/// `audioHandler.updateLocalModeNotification(...)`/`setRemotePlaybackState(...)`/
/// `clearRemotePlaybackState()`/`setLocalMode()`/`updateQueueIndex(...)`/
/// `stopService()` call sites directly against the global `audioHandler`
/// singleton, spread across a ~6900-line file. Centralizing them here doesn't
/// change behavior today - every method here is a direct pass-through to the
/// same handler method - it exists so that changing *how* playback state gets
/// reported (e.g. as part of a future single-owner refactor) only needs to
/// touch this one file instead of ~19 sites.
class PlaybackNotificationBridge {
  final MassivAudioHandler _handler;
  const PlaybackNotificationBridge(this._handler);

  /// Switch the handler to local (builtin player) mode without touching
  /// notification content.
  void setLocalMode() => _handler.setLocalMode();

  /// Update the notification for local (builtin player) playback without
  /// switching into remote mode.
  void updateLocalModeNotification({
    required MediaItem item,
    required bool playing,
    Duration? duration,
    Duration? position,
  }) {
    _handler.updateLocalModeNotification(
      item: item,
      playing: playing,
      duration: duration,
      position: position,
    );
  }

  /// Show notification/media-session state for a remote (non-builtin) MA
  /// player, without any local audio playback.
  void setRemotePlaybackState({
    required MediaItem item,
    required bool playing,
    Duration position = Duration.zero,
    Duration? duration,
  }) {
    _handler.setRemotePlaybackState(
      item: item,
      playing: playing,
      position: position,
      duration: duration,
    );
  }

  /// Clear remote playback state (e.g. player deselected/disconnected).
  void clearRemotePlaybackState() => _handler.clearRemotePlaybackState();

  /// Update the reported queue index (e.g. after skip/previous) without a
  /// full notification rebuild.
  void updateQueueIndex(int index) => _handler.updateQueueIndex(index);

  /// Stop the foreground service (idle timeout).
  Future<void> stopForegroundService() => _handler.stopService();
}
