# Local patches

This is a vendored copy of [`flutter_pcm_sound`](https://pub.dev/packages/flutter_pcm_sound)
3.3.3 (public domain / Unlicense), kept in-tree because it needs a fix that
doesn't exist upstream (checked against the latest commit on
[chipweinberger/flutter_pcm_sound](https://github.com/chipweinberger/flutter_pcm_sound)
as of 2026-07-14 — not fixed there either).

## `MAX_FRAMES_PER_BUFFER`: 200 → 4800 (android)

`android/src/main/java/com/lib/flutter_pcm_sound/FlutterPcmSoundPlugin.java`

Upstream hardcodes the native playback thread's internal buffer granularity
at 200 frames (~4.2ms at 48kHz) — every `feed()` call gets re-split into
200-frame `ByteBuffer`s before being queued, regardless of how large a
buffer Dart hands it. The playback loop processes one such sub-buffer per
iteration and does a full `synchronized` scan of the *entire* remaining
queue every iteration to compute remaining-frame stats, running at
`Thread.MAX_PRIORITY`. At 48kHz that's ~240 loop iterations/second minimum,
each with locking + an O(n) scan.

Confirmed via `adb shell top -H` on a real device: this pins the native
`PCMPlaybackThread` at ~100% CPU continuously during completely healthy
playback (zero buffer underruns/overflows) — not a backlog/catch-up
artifact. A maxed-out core at real-time thread priority is enough to
visibly degrade UI scroll responsiveness system-wide, since it can preempt
normal-priority rendering work.

Raised to 4800 frames (~100ms at 48kHz), matching this app's own
feed-threshold scale (`_feedThreshold` in `lib/services/pcm_audio_player.dart`),
cutting native loop iterations roughly 24x. This has no effect on pause
latency: `pause()` discards whatever's queued natively via `release()`
regardless of how finely it was internally split, so the buffer's internal
chunk granularity was never actually load-bearing for that.

## Keeping this in sync

If bumping to a newer upstream `flutter_pcm_sound` release, re-apply this
patch (or check if upstream has fixed it by then, in which case this
vendored copy - and the `path:` override in the app's `pubspec.yaml` - can
be dropped in favor of the normal hosted dependency).
