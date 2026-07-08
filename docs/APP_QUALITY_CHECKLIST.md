# Klangor Quality & Stability Checklist

Status: **snapshot audit, 2026-07-08.** Answers the question "does this add up
to a sensible, stable app, or a pile of workarounds?" Organized by area; each
item is marked Solid / Workable-but-thin / Gap, with the concrete evidence
behind the call (file:line) so this can be re-checked as the code changes. Not
exhaustive — focused on the parts most likely to cause visible, real-world
mobile misbehavior (disconnects, interrupts, backgrounding), plus data/app
architecture as the foundation everything else sits on.

## How to read this

- **Solid** — implemented deliberately, has a clear failure mode that's
  handled, or is covered by tests.
- **Workable-but-thin** — works in the common case, has a known/documented
  edge case that isn't handled, or has zero test coverage protecting it.
- **Gap** — either not implemented, silently broken in a plausible scenario,
  or resting on dead/unused code.

---

## 1. Data architecture

| Area | Verdict | Evidence |
|---|---|---|
| Relational schema (Drift v8) | **Solid** | 18 tables incl. `Artists`/`Albums`/`Tracks`/`Playlists`/`Audiobooks`/`ProviderMappings`, keyed by `(provider, itemId)` — a real normalized schema, not a blob store. `lib/database/database.dart:410` (`schemaVersion => 8`), tables at `:7-401`. |
| Read-through cache pattern | **Solid** | `SyncService` loads from DB first (`loadFromCache`), then refreshes from live MA in the background — UI is never blocked on the network for data it already has. |
| JSON-blob cache vs. relational schema coexistence | **Workable-but-thin** | `LibraryCache` (legacy JSON blob) and the newer relational tables both exist and are both written. `sync_service.dart:441`: *"Best-effort dual-write into the relational schema"* — "best-effort" means the two can drift out of sync under partial failures, with no reconciliation path described. This is expected mid-migration but is a real source of "why does the UI show stale/inconsistent data" bugs if the migration stalls here long-term. |
| Playback-state persistence | **Gap** | `PlaybackState` table's doc comment claims it "survives app restarts and disconnects" (`database.dart:104-129`), but `positionSeconds` is **never written** by any caller (always defaults to `0.0`, `:730,738`) and **never read back** (`_loadPlaybackStateFromDatabase`, `:989-1016`, only restores `currentTrackJson` for display). The persistence exists in schema but the position-resume half of it is dead code — see §3. |

## 2. App architecture

| Area | Verdict | Evidence |
|---|---|---|
| Provider/repository layering | **Solid** | `LibraryRepository`/`PlayerRepository` sit between `SyncService`/`MusicAssistantAPI` and the UI — a real separation, recently added deliberately (per git history: "refactor: PlayerRepository/LibraryRepository integration, notification bridge"). |
| Notification bridge | **Solid** | Centralizing notification/AA state updates into one bridge (recent refactor) removes what was previously likely scattered ad-hoc notification code — a real architectural improvement, not just a rename. |
| Dead/abandoned refactor code | **Gap (hygiene)** | `lib/providers/connection_provider.dart` exists as a from-scratch `ConnectionProvider` with its own reconnect logic, but is **never instantiated anywhere in `lib/`** — its own doc comment admits it's "partial extraction... requires updating all consumers" (`:20-22`). This is a half-finished extraction sitting in the tree; either finish wiring it in or delete it — as-is it's confusing dead weight that could mislead a future reader into thinking connection logic lives there. |
| Sync/repository test coverage | **Solid** | `library_repository_test.dart`, `player_repository_test.dart`, `database_test.dart`, `library_schema_test.dart` — the data layer is the best-tested part of the app. |

## 3. Runtime behavior — mobile lifecycle

This is where "typical mobile app" expectations get tested: interruptions,
disconnects, backgrounding, process death. This is also where most of the
app's genuinely hard problems concentrate — and where test coverage is zero.

| Area | Verdict | Evidence |
|---|---|---|
| Audio focus (phone calls, other apps) | **Workable-but-thin** | Real handling exists: `AudioSession` interruption stream drives duck/pause/resume (`massiv_audio_handler.dart:114-168`), `becomingNoisy` (headphone unplug) pauses (`:164-168`). But there's a documented, currently-unfixed-in-a-release desync: if a builtin-player pause path skips `markLocalPaused()`, `playbackState.value.playing` gets stuck `true`, silently skipping the focus-reclaim-on-resume path — audio position advances with no actual sound (`:485-508`). *(Note: the fix for this is in the currently uncommitted working tree, not yet released — see below.)* |
| Network reconnection (WS drop) | **Gap** | Reconnect on socket error/close is a **fixed 3s delay, not exponential backoff** (`Timings.reconnectDelay`, `timings.dart:23`; used at `music_assistant_api.dart:219-233,3690-3691`). A real exponential-backoff helper (`RetryHelper`) exists and is used for individual API calls, but **not for the socket-reconnect path itself** — so a server that's down for a while gets hammered every 3s indefinitely rather than backing off. |
| Network-change detection | **Gap** | No `connectivity_plus`-style network-change listener found. Reconnection is only triggered by `AppLifecycleState.resumed` (`main.dart:297-305`) or incidentally by an Android Auto browse call. **Concrete failure case**: phone briefly drops wifi while the app is foregrounded and idle (not actively backgrounding/foregrounding) — the app can sit in an error state until the user backgrounds/foregrounds it or an AA action happens to fire, rather than reconnecting on its own once the network returns. |
| Android Auto connect/disconnect | **Workable-but-thin** | Genuinely hardened by real bug fixes — explicit race-condition suppression exists (`aaDisconnectedAt` within a 2s window suppresses a stale `stream/start`, `music_assistant_provider.dart:2676-2679`, comment explicitly calls this out as a race fix) and disconnect correctly avoids clobbering a remote/Chromecast player's state (`markLocalPaused()`'s `!_isRemoteMode` guard). But AA connection is also detected **implicitly** via any `getChildren()` call as a fallback signal (comment: "AA may cache the root and only request subcategories," `:744-748`) — this is exactly the kind of inference-based heuristic that tends to break when Android Auto changes its own caching behavior in a future version, since it's not a documented AA contract. |
| Process death / relaunch mid-playback | **Gap** | See §1 — `positionSeconds` is written as always-`0` and never read back. Practical effect: if Android kills the app process during playback (memory pressure, or user swipes it away) the user reopens to see the *track metadata* they were on, but not the actual playback position — a plain restart, not a resume. `SettingsService` persists `last_selected_player_id` only (`:94,358-360`) — no last-position key exists anywhere. |
| Sendspin/PCM socket drop mid-track | **Workable-but-thin** | Reconnect exists but is **fixed 5s** (`sendspin_service.dart:670-682`, not exponential), and recovery is implicit — depends on the server re-sending `stream/start` after reconnect rather than the client explicitly resuming from a known position. `pcm_audio_player.dart`'s `_onStreamDone` deliberately does nothing ("let buffered audio finish," `:523-526`) — reasonable, but there's a documented race where a transitional (non-user) pause that isn't flagged correctly can cause the *next* track's audio to be silently dropped forever by the auto-recovery check (`:589-596`). |
| Test coverage of all of the above | **Gap** | Zero. All 9 test files are database/repository/pure-helper tests (`error_handler_test`, `image_service_test`, `retry_helper_test`, one 4-test file against a single pure function extracted from the audio handler). **Nothing exercises WebSocket reconnection, Sendspin reconnection, audio focus transitions, or Android Auto lifecycle** — precisely the areas flagged above as thin. No widget or integration tests exist at all. |

## 4. Known unknowns / open design risk

| Area | Status | Notes |
|---|---|---|
| Offline playback / download feature | **Pre-design, one blocker resolved, scope narrowed** | See `docs/OFFLINE_PLAYBACK_PLAN.md`. Getting bytes is technically solved (Sendspin PCM capture, confirmed live) but is explicitly scoped to self-hosted providers only — MA's own maintainers have rejected caching streaming-provider content on ToS grounds ([discussion #3912](https://github.com/orgs/music-assistant/discussions/3912)). No implementation started. |
| MA server API stability | **Confirmed fragile** | Directly observed during this investigation: `builtin_player/register`, a command the app's own comments describe as a supported (if legacy) path, no longer exists on current MA (schema 29) — "Invalid command." Any code depending on undocumented/internal MA behavior (which the Sendspin registration approach above necessarily does) should be assumed to need re-validation against future MA releases, not treated as a stable contract. |
| DSP/volume-normalization dual state | **Unclear from this audit** | `streamdetails.dsp` and `volume_normalization_mode` fields observed live carry per-player DSP state server-side; whether the app's own volume/DSP handling can conflict with server-side normalization wasn't in scope here and would need its own look if volume behavior is ever reported as inconsistent. |

## 5. Bottom line

The **data layer is the strongest part of the app** — a real relational
schema, layered repositories, decent test coverage, one known migration-era
loose end (dual-write drift risk, not urgent).

The **mobile-lifecycle layer is the weak part**, and it's weak in a specific,
consistent way: real handling exists for the *complicated, already-debugged*
cases (audio focus ducking, AA race conditions), but the *simple, easy-to-miss*
cases are gaps — no backoff on reconnects, no network-change detection, no
actual position restore after process death, zero test coverage on any of it.
None of this is "hacky" in the sense of being fragile-by-design; it reads as
organically hardened through real bug reports rather than designed
defensively upfront — which is a normal state for an app this size, but it
does mean the next round of "why did playback act weird" reports will likely
land in one of the five Gap rows in §3, not somewhere new.

The **offline-playback investigation is the one area actively resting on
reverse-engineered, undocumented server behavior** rather than a stable public
API — worth keeping scoped small (self-hosted providers only, as already
decided) and worth re-testing against MA server upgrades rather than assuming
it stays working.
