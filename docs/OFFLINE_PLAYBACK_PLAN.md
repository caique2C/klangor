# Offline Playback & Download Architecture — Requirements & Feasibility

Status: **CLOSED, 2026-07-08 — both topics below skipped, not building this.**
Kept as a record of the investigation and the reasoning behind dropping it, in
case it comes up again later. Origin: continues an architecture investigation
from a prior chat session (lost to a VS Code restart, recovered from
`~/.claude/plans/cached-wishing-fairy.md` and the raw session transcript).

## Conclusion (2026-07-08)

Two separate questions were investigated here. Both are being skipped.

**1. Offline playback / download support, in general: skipped — too heavy for
what it buys.** Technically resolvable (a working virtual-player + PCM-capture
mechanism was validated live against the user's own MA server), but everything
around the technical core is expensive:
- No first-class MA API for this; the mechanism rests on undocumented server
  behavior that already broke once *during this same investigation*
  (`builtin_player/register` no longer exists on current MA versions).
- MA's own maintainers have explicitly rejected offline-caching as a feature
  on ToS grounds ([discussion #3912](https://github.com/orgs/music-assistant/discussions/3912)),
  forcing a hard scope restriction to self-hosted providers only.
- Capture is real-time-paced (no faster-than-realtime download shortcut is
  reachable without emulating a full separate device protocol like DLNA).
- It requires its own player-registration lifecycle with real cleanup
  obligations (a throwaway player left three "ghost" entries in the user's
  live MA config during testing before being cleaned up).
- It needs its own seek/partial-file semantics, distinct from ordinary
  playback.
This adds up to a standalone subsystem, not a small feature addition — not
worth building right now.

**2. A shared live/download code layer: skipped — not beneficial beyond thin
protocol plumbing.** Investigated as a way to make trigger 1 (favorited-and-
currently-playing) cheaper by piggybacking capture on the live session. Only
the low-level protocol code (session handshake, PCM frame parsing) is
genuinely reusable. Sharing anything above that — specifically, attaching a
disk-capture sink to the same session object the user is actively
skip/seek/switch-driving — makes the *live listening* path more fragile, not
less: routine user actions (next/previous, seeking, switching players,
reconnecting after a network blip) would leave capture with partial, gapped,
or duplicated files, and pile that bookkeeping onto exactly the part of the
app already flagged as most fragile and least tested
(`docs/APP_QUALITY_CHECKLIST.md` §3). If offline support is ever revisited,
capture should run as its own fully independent session under its own
throwaway player identity, never attached to the interactive one.

Full investigation, live experiment results, and reasoning trail preserved
below for reference.

## Goals (from user, 2026-07-08)

1. Foundation for a real offline mode.
2. Playback is always served from local cache when the content is cached; falls back to
   streaming otherwise.
3. Fast-forward / seek-to-position must work sensibly against a partially-cached file.
4. A download mechanism for content marked for offline use — user's suggestion: start with
   favorites.
5. The same foundation (cached-content browsing + playback) must work identically from
   Android Auto.
6. Explicitly **out of scope**: real-time multi-room sync. This architecture is for the
   local/builtin player only — remote players (Chromecasts, other MA players) stay
   server-polled/live, by design (see "Why this doesn't become a VLC-style single source
   of truth" below).

## Relationship between live playback and the download mechanism (clarified 2026-07-08, corrected twice on 2026-07-08)

**Decision, final form: shared low-level code, but capture always runs as its
own decoupled session — never attached to the interactive playback session.**

This went through two iterations before landing here, worth recording because
the reasoning is the point, not just the conclusion:

1. First framing: live playback and downloading as two unrelated mechanisms.
   Wrong — there's genuinely one piece of reusable code underneath both
   (open a Sendspin session, parse PCM frames), no reason to implement that
   twice.
2. Second framing: share that code by literally attaching a disk-capture sink
   to the *same session object* the user is actively listening through — so a
   favorited track gets captured as a side effect of playing it live, no
   second session. **Also wrong**, for a concrete reason: that session is
   subject to everything a real, interactive listening session is subject to
   — skip/next/previous, seeking, switching players, backgrounding, AA
   connect/disconnect, and a plain network reconnect whose resume-vs-restart
   behavior isn't even confirmed yet. Every one of those is routine user
   behavior, not an edge case, and every one of them would leave the
   disk-capture sink with a partial, gapped, or duplicated file — while also
   piling new state and error handling onto exactly the playback code that
   `docs/APP_QUALITY_CHECKLIST.md` §3 already flags as the app's most fragile,
   least-tested area. Bolting a correctness-sensitive background job onto that
   path makes the fragile part *more* fragile, not less.

**Final design**: the reusable piece is the low-level protocol module (session
handshake, PCM frame parsing) — genuinely one implementation, used by both
paths. But **actually running a capture always happens in its own
independent session, under its own throwaway player identity, regardless of
what triggered it**:

- **Live listening** (user presses play): the real, already-registered
  player's session, feeding only the audio-output sink (`PcmAudioPlayer` as
  it exists today, essentially unchanged). Nothing about disk capture ever
  touches this session. If the track is favorited, that's a signal to kick
  off trigger 2 as an independent job — not to attach anything here.
- **Capture/download** (whether triggered by "favorited and currently
  playing" or "proactive download for the trip"): its own session, its own
  throwaway player identity (the probe mechanism validated in this doc),
  feeding only a disk-capture sink. Skip/seek/pause/player-switch on the
  user's real listening session cannot affect it, because it isn't the same
  session. If the capture session itself hits a network blip, it can just
  fail and retry from scratch on its own — nobody is listening to it, so
  there's no audible consequence to get wrong.

**Cost of this, stated plainly**: if a favorited track is captured while the
user happens to be listening to it live, the same audio is fetched from the
server twice concurrently (once for the ear, once for the file) — real but
cheap bandwidth/CPU duplication, and a much better trade than entangling
disk-write correctness with a session the user can disrupt at any moment.

**Buffering/stability implication, corrected again**: sharing the low-level
protocol code means reconnect/backoff hardening (the fixed-5s-no-backoff gap
in `docs/APP_QUALITY_CHECKLIST.md` §3) only needs to be written once and both
paths benefit — that part of the earlier reasoning still holds. What doesn't
hold is any claim that this makes live-listening *itself* more stable by
adding capture to it. It doesn't; the two remain operationally independent,
which is exactly why live listening's stability is unaffected by whatever the
capture session is doing.

**Where local-file playback fits**: once a track has a completed local
capture (from either trigger), the pre-session decision point (Gap 4) prefers
opening the file over opening any Sendspin session at all — no session, no
player identity, no network, just file I/O.

**Open wrinkle (requirement 3, revisited)**: seeking sensibly against a
*partially*-captured file only matters if playback is ever served from an
in-progress capture, which this design avoids by construction — live
listening never reads from the capture session, and the capture session is
never used for interactive playback. If in-progress-download playback is
wanted later anyway (e.g. "start listening to what's downloaded so far"),
that would mean deliberately pointing the audio-output sink at a capture
session's file-in-progress as a third, explicit mode — not something that
falls out of the current design, and not planned unless requested.

## What's already built and confirmed working (prior session + verified live today)

- **`LibraryRepository`** (relational Drift schema v8) — metadata (artists/albums/tracks/
  playlists) is already offline-durable, read from local DB regardless of MA connectivity.
  Confirmed live: offline in-app browsing works, including Android Auto's browse tree.
  This is real progress toward goal 1 and 5 for *metadata*, not yet for *audio content*.
- **`ImageService`** — unified artwork cache, shared between Flutter UI and the native
  Android Auto artwork provider.

## Critical feasibility findings — verified against the live MA server (2026-07-05/06)

These come from direct experimentation against `music-assistant/server` in the prior
session and are load-bearing constraints, not guesses.

### Blocker 1 — MA has no per-track download endpoint (RESOLVED 2026-07-07, see below — answer differs from what was originally assumed)

- `/preview` is docstringed "serve short preview sample" — not usable for real downloads.
- Full-quality audio is only served from `/flow/{session_id}/...` or
  `/single/{session_id}/...`, both requiring an active `session_id`/`queue_item_id`.
- `session_id`/`queue_item_id` only exist once a track is enqueued into a **real player's
  queue** (`queue_id == player_id`, 1:1, created when a player connects). There is no
  headless/virtual queue concept in the server today.
- **Confirmed live**: `streamdetails` (needed to resolve the actual audio URL) stays `null`
  even after a track is appended to the queue, and even after moving it to "next up." It
  only populates once the track becomes the queue's **actual current/buffering item** —
  confirmed via `player_queues/get`'s `current_item` field.
- **Consequence**: fetching a track's bytes for download/cache purposes requires making it
  the actively-playing item on some real player's queue. There is currently no known way
  to do this without touching a queue that could be the user's actual listening session.
- **Unresolved, never investigated**: does registering a second/virtual player (one with
  no real audio output) let us enqueue+advance a queue purely to resolve `streamdetails`
  and fetch bytes, without disturbing the user's real playback? This is the single
  highest-priority open question — nothing else in this plan is buildable until it's
  answered.

### Blocker 2 — queue watermark is monotonic and irreversible

- `player_queues/delete_item` and `move_item_end` refuse to touch any item at index
  `<= index_in_buffer`. This watermark only increases, never resets, for the life of a
  queue session.
- Advancing the current position to "free up" an item for deletion instead **permanently
  traps it** — everything at or before the new watermark becomes unremovable.
- **Design constraint**: a download/probe operation must never advance a queue's playback
  position. (A stray test track is permanently stuck in the dev queue from the prior
  session's experiments as a live example of this trap — harmless, but unremovable.)

### Blocker 3 — `next`/`previous` are not safe pointer-only moves

- Confirmed live: both schedule an actual `play_index` call ~1s later server-side, **even
  while paused**. Hardware/media-key next/previous will audibly start playback.
- Any tooling that needs to change the current index without triggering audible playback
  must not use `next`/`previous`.

### Gap 4 — the old plan targeted the wrong playback pipeline (found today, 2026-07-08)

This is new since the plan was written and changes the implementation design:

- The prior plan's playback integration was: *"a URL-selection rule in the existing
  `playUrl` path: prefer the local `file://` path when a track is cached... else stream —
  no new playback pipeline."*
- `playUrl` (`LocalPlayerService` → `MassivAudioHandler.playUrl` → `just_audio`) is the
  **legacy fallback path**, only used when the server predates Sendspin support (see
  `music_assistant_provider.dart:2343-2345`: *"Server uses Sendspin (MA 2.7.0b20+),
  skipping builtin_player"*).
- The app's README already states MA 2.7.0b20+ is the recommended minimum — meaning for
  effectively every real-world setup (including this dev server, MA 2.8.3), local playback
  actually runs through **`SendspinService` + `PcmAudioPlayer`**: a live WebSocket PCM feed
  decoded and fed to `flutter_pcm_sound` in real time. This is architecturally unrelated
  to `playUrl`/`just_audio`.
- **Consequence**: "prefer local file over streaming" cannot be a `playUrl`-level URL
  swap as originally designed. It needs a new decision point inside (or ahead of) the
  Sendspin/PCM pipeline — e.g. `PcmAudioPlayer` (or a layer in front of it) checking for a
  complete local file for the requested track before a Sendspin session is even opened,
  and feeding decoded PCM from that file instead of the live socket. This is genuinely new
  design work, not a small tweak to what was planned.

## Requirement-by-requirement feasibility assessment

| # | Requirement | Status |
|---|---|---|
| 1 | Offline mode foundation | Metadata: done. Audio: Blocker 1 resolved (bytes are obtainable) but requires the "capture a live PCM playthrough" approach below, not a simple fetch — Gap 4 design still needed. |
| 2 | Always play from local cache | Metadata/browsing: yes. Audio: mechanism confirmed feasible, needs Gap 4 redesign to implement. |
| 3 | Seek/fast-forward impact | Old plan's principle carries over ("never silently switch strategies mid-seek" — block/wait instead) but needs restating for a live PCM feed, which has no native concept of "seek within a partially downloaded file" the way `just_audio` does. New design needed once Gap 4 is resolved. |
| 4 | Download mechanism (favorites first) | Blocker 1 resolved: can register a virtual player and enqueue a track without touching the real queue. "Download" means capturing a live Sendspin PCM playthrough (stream/start→binary frames→stream/end), not fetching a static file. **Scoped to self-hosted providers only** (filesystem_local/opensubsonic) — MA's maintainers have explicitly rejected caching streaming-provider content on ToS grounds (see below), so this must never apply to Spotify/Tidal/etc. tracks. |
| 5 | Same foundation for Android Auto | Metadata: already works (DB-backed, connectivity-independent). Audio: inherits whatever solves Blocker 1/Gap 4 — no AA-specific blocker beyond that, since AA plays through the same local pipeline. |
| 6 | No real-time multi-room sync needed | Confirmed compatible — this was already the prior session's own conclusion (Phase 4b finding): `MusicAssistantProvider`'s server-polling must stay authoritative for remote players; this whole cache-first architecture is scoped to the local/builtin player only. |

## Upstream MA position on this feature (checked 2026-07-08)

Checked music-assistant/server's GitHub issues and the org's Discussions for any
planned first-class "download"/"offline"/URL-based streaming support. Findings:

- **No issue or PR in `music-assistant/server` proposes a client-facing
  download/export API.** Searched titles and bodies for "offline", "download",
  "cache" — nothing relevant; the "download" hits are all CI dependency bumps
  (`actions/download-artifact`).
- **There is exactly one relevant discussion:
  [Support for Offline Track Caching (#3912)](https://github.com/orgs/music-assistant/discussions/3912).**
  A user proposed saving a local copy of a track after it finishes playing. A
  maintainer (@OzGav) **explicitly rejected it**, including the "just capture
  raw bytes mid-stream" framing this plan was heading toward:
  > "Again this would violate the streaming providers terms of service and
  > therefore won't be happening."
  The user accepted this and the discussion closed. This is a **deliberate
  policy stance from the MA maintainers, not a technical gap** — they will not
  ship or endorse tooling that captures streamed audio from paid provider
  backends (Spotify, Tidal, etc.), regardless of implementation method.
- **Important nuance the rejection doesn't cover**: the objection is specifically
  about *streaming provider* content (ToS-bound). It says nothing about content
  from the user's own self-hosted providers — `filesystem_local` (their own
  files) or `opensubsonic`/Audiobookshelf (their own server). Caching a copy of
  a file the user already owns and hosts is a different legal situation
  entirely. **This plan should scope any download/cache feature to
  self-hosted/local-provider content only**, and explicitly exclude tracks whose
  `provider_mappings` resolve to a paid streaming backend — both to stay clean
  of the ToS concern MA's own maintainers flagged, and because it avoids ever
  needing to reason about DRM/licensing on content Klangor doesn't own.
- Also confirms: **Spotify/YouTube/Tidal are not fetched "by URL" by MA either.**
  MA's `StreamsAudio` pipeline (`controllers/streams/audio.py` in the server
  source) always decodes every source — local file or paid streaming provider
  alike — through FFmpeg into raw PCM server-side before it reaches any player.
  The `/flow/{session_id}/...` and `/single/{session_id}/...` HTTP endpoints
  exist (`controllers/streams/controller.py`) and serve a fully re-encoded file
  (`fmt` per the player's configured output codec, e.g. FLAC) — genuinely
  faster than realtime for a plain HTTP GET, unlike the Sendspin PCM path below.
  But `resolve_stream_url()`, which builds these URLs, is **only ever called
  in-process by specific player-protocol implementations** (DLNA, Chromecast,
  Sonos, Squeezelite, etc.) — it is not exposed through the public `/ws` command
  API used by this app or any external client. Getting one of these URLs would
  require emulating one of those device protocols (DLNA/UPnP being the most
  standardized and stable option) well enough for MA's server to treat us as a
  real renderer — a materially bigger, separate project, not a small addition
  to the current WebSocket-based integration.

## Blocker 1 resolved — live experiment against the real server (2026-07-07)

Ran a scripted experiment directly against the user's production MA server
(`music.familie-reinhard.de`, schema_version 29) using a throwaway Python client
(`/tmp/.../scratchpad/ma_sendspin_probe.py` — not checked in, one-off tooling).
Full transcript/methodology available on request; summary of findings:

**`builtin_player/register` no longer exists on current MA versions.** The server
returns `error_code 12, "Invalid command: builtin_player/register"`. This command
is fully gone server-side, not just deprecated — any plan relying on it is dead.
The only registration path left is the **Sendspin protocol's own handshake**
(`client/hello` → `server/hello`) against a *separate* websocket at `/sendspin`
(proxy-authenticated with the same bearer token as the main `/ws` connection).

**A throwaway Sendspin client can register as a real player and this works for the
virtual-player goal:**
- MA does **not** use the raw `client_id` we send as the player_id — it registers
  under a provider-prefixed id, `"up" + client_id`, under `provider: universal_player`.
  Match on substring, not equality, when looking it up via `players/all`.
- Registration is **not instant** — took ~14-15s to appear in `players/all` in
  testing (polled every 1s). Any implementation needs to poll/wait for this, not
  assume immediate availability.
- Once registered and available, `player_queues/play_media` with `option: replace`
  onto that player's queue (`queue_id == player_id`) resolves
  `current_item.streamdetails` **immediately** (present on the very first
  `player_queues/get` poll) — this contradicts the prior session's finding that
  streamdetails stays null until buffering. Likely explanation: `option: replace`
  makes the item the current one instantly (single-item queue), whereas the prior
  session's tests used `add`/reorder into "next up," which never became current.
- The server begins driving playback (queue state → `playing`, `current_media`
  populated) as soon as `play_media` is called — **it does not wait for the
  fake client to actually start pulling/consuming audio.** We closed the Sendspin
  socket before any audio flowed and the server still showed the queue as
  actively playing afterward, until we explicitly called `player_queues/stop`.

**Blocker 1 is resolved, but the answer changes the architecture (supersedes the
original "fetch bytes via a resolved stream URL" framing):**
- The `streamdetails` object resolved above contains **no `stream_id`, no
  `session_id`, and no fetchable URL of any kind** — just descriptive metadata
  (`provider`, `item_id`, `audio_format`, `duration`, `size`, `loudness`,
  `stream_type: "local_file"`, `dsp`). There is nothing here to hand to an HTTP
  client.
- Immediately after `play_media`, the Sendspin socket received a `stream/start`
  event carrying **PCM format parameters** (`codec: pcm, sample_rate: 48000,
  channels: 2, bit_depth: 16`) — not a URL. The source file here was 44.1kHz MP3;
  MA transcodes/resamples server-side before ever putting a byte on the wire.
- **Conclusion: for Sendspin-based players (i.e. every real-world setup this app
  targets, per Gap 4), there is no separate downloadable stream endpoint at all.**
  The *only* way to obtain audio bytes is to actually run a live streaming
  session and capture the raw PCM frames MA pushes over the Sendspin websocket
  in real time (`stream/start` → binary frames → `stream/end`), then re-encode
  them locally if a compressed on-disk format is wanted. Downloading a track for
  offline use is therefore architecturally "record a live playthrough," not
  "fetch a file" — this is a materially bigger lift than the original plan
  assumed, and directly reinforces Gap 4 (the integration point has to live in/
  around `PcmAudioPlayer` + `SendspinService`, since that's the only place these
  bytes ever exist in decoded form).
- Uncompressed PCM at 48kHz/16-bit/stereo is ~10.1 MB/min. A download feature
  needs to plan for either storing that raw (simple, large) or transcoding
  on-device after capture (smaller, needs a codec/muxer dependency) — an open
  design question, not yet decided.

**Side effect confirmed and cleaned up:** registering a Sendspin player creates a
persistent player config entry server-side (visible in `players/all`, lingering
as `available: false` after disconnect) — three such "ghost" entries accumulated
during testing. Contrary to this app's own code comments (which call
`config/players/remove` unreliable and avoid it for real device players),
`config/players/remove` worked cleanly here for all three throwaway
`universal_player`/Sendspin entries — confirmed removed via a follow-up
`players/all` check. Any future automated probing/registration code must call
this on cleanup; it is not optional, and per Blocker 2, must never advance the
queue position first (call `stop`/`clear`, not `next`/`play_index`).

## Recommended next step

**Scope decision**: restrict any download/cache feature to tracks whose
`provider_mappings` resolve to a self-hosted provider (`filesystem_local`,
`opensubsonic`, Audiobookshelf) — never to a paid streaming backend. This
follows directly from the maintainers' stated ToS position above, not just as
legal caution but as a hard product boundary.

**Mechanism decision**: use the Sendspin PCM-capture path validated above
(register a throwaway player → `play_media` → capture `stream/start` → binary
PCM frames → `stream/end`), not the DLNA/HTTP-URL route — the latter is
faster and gets a smaller pre-encoded file, but requires emulating a whole
separate device protocol just to unlock a URL, which is a disproportionate
amount of new surface area for what it buys. Store the captured PCM re-encoded
locally (e.g. Opus/AAC via an on-device encoder) rather than raw — quality is
already fixed by MA's server-side transcode, so there's no lossless benefit to
keeping it uncompressed, and re-encoding trades a few seconds of one-time CPU
work for a large, permanent storage-size win.

The open design work that remains: the Gap 4 integration point in
`PcmAudioPlayer`/`SendspinService` (checking for a completed local capture
before opening a live session), the capture pipeline itself (registering a
background probe player, writing frames to disk, re-encoding, cleaning up the
player registration afterward — same lifecycle proven above but productionized
and running for the track's full real-time duration, not a quick probe), and
seek/fast-forward behavior against a file that can only be captured
sequentially (no random access during capture) — a different model from the
old `just_audio`-style "seek within a partially downloaded file."
