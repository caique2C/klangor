<div align="center">
  <img src="assets/images/klangor_logo.png" alt="Klangor Logo" height="200">

  [![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg?style=for-the-badge)](LICENSE)

---

  <p><strong>An unofficial mobile client for Music Assistant</strong></p>
  <p>Stream your music library directly to your phone, or control playback on any connected speaker.</p>
  <p><strong>Built with AI-assisted development using Claude Code.</strong></p>
</div>

---

## What is Klangor?

Klangor is a personal fork of [Ensemble](https://github.com/CollotsSpot/Ensemble) by
[CollotsSpot](https://github.com/CollotsSpot). Ensemble is where all of the original design,
feature set, and UI came from — this fork exists because a series of bug-hunting sessions
turned into a substantial rewrite of the app's internals (see below), well beyond the size of
change that fits into a normal pull request, continuing the same AI-assisted development
approach the original Ensemble project used. Klangor is not published or supported anywhere
beyond this repository; it is not affiliated with, endorsed by, or a replacement for Ensemble.

---

## Disclaimer

**Klangor is an unofficial, community-built mobile client for Music Assistant. It is not
affiliated with, endorsed by, or supported by the Music Assistant project, nor by the Ensemble
project it was forked from.**

---

## Relationship to Ensemble — why a fork instead of pull requests

The commits on top of Ensemble fall into two groups:

1. **A long series of targeted bug fixes**, mostly around Android Auto (cold-start caching,
   disconnect detection, shuffle/repeat sync, artwork loading, reconnect races). These would
   have been reasonable individual PRs.
2. **A small number of much larger commits** that rework shared internals: a relational
   database schema replacing a JSON-blob cache, a repository layer sitting in front of it, a
   type-safe player-identity wrapper replacing an ad-hoc string comparison that had been
   independently re-fixed at close to 20 call sites, a single notification/Android-Auto state
   bridge replacing ~30 scattered call sites, and a from-scratch test suite (the project had
   none before). These touch the same handful of shared files repeatedly and depend on each
   other — they aren't safely separable into small, independently reviewable PRs, and
   bundling a rewrite of this scope into someone else's project via pull requests isn't
   realistic or fair to ask a maintainer to review. Maintaining it as an independent fork was
   the pragmatic option.

None of this reflects a problem with Ensemble as a project — it reflects the natural result of
debugging real, hard-to-reproduce issues (race conditions, cache inconsistency) far enough that
the fix stops being local and starts being structural.

---

## What changed vs. Ensemble (high level)

### Re-architected

- **Relational library database (Drift schema v8)** — the previous cache was a single JSON-blob
  key/value table with no foreign keys or joins, and a cache key that didn't include the
  provider (a collision risk with multiple providers). Replaced with typed `Artists` / `Albums`
  / `Tracks` / `Playlists` / `PlaylistTracks` / `Audiobooks` / `Chapters` /
  `ProviderMappings` tables and a `LibraryRepository` that screens, artist/album/playlist detail
  pages, and Android Auto's browse tree now read from directly.
- **Player-identity handling (`PlayerRepository` / `RawPlayerId`)** — the app compares a
  locally-stored "raw" player ID against Music Assistant's live, resolved player IDs in many
  places; a subtle mismatch bug here had been fixed independently at nearly 20 call sites over
  time. Replaced with an opaque `RawPlayerId` wrapper that only `PlayerRepository` can resolve,
  so the bug class can no longer reappear at a new call site by accident.
- **`PlaybackNotificationBridge`** — centralizes what used to be ~30 scattered direct calls from
  the app's data layer into the OS media notification / Android Auto surface, into one seam.
- **Unified image cache (`ImageService`)** — the Flutter UI and the native Android Auto artwork
  provider used to fetch and cache artwork completely independently, and went stale
  independently. Both sides now share one on-disk cache directory and hashing convention.
- **Track-tap playback reliability** — fixed three stacked race conditions (a stream-generation
  race between the old and new track, an overloaded "user paused" flag, and a server-side
  `play_media` race) that made tapping a track in an album/playlist unreliable.

### Also changed

- **Android Auto**: extensive stabilization pass — reliable disconnect detection, cold-start
  artwork/list caching, shuffle/repeat state sync, a "Smart Shuffle" mode, voice search, and a
  dedicated `ArtworkContentProvider` for car-head-unit artwork.
- **Test suite added** — the project previously had no automated tests; added unit/widget tests
  for the database, both repositories, the audio handler, image service, and error/retry
  helpers.
- **Icon package**: consolidated on `material_symbols_icons`, dropping the older
  `material_design_icons_flutter` dependency.
- **Connection resilience**: the WebSocket and local-playback (Sendspin) connections now retry
  with exponential backoff instead of giving up after one failed attempt, and reconnect
  promptly when network connectivity is restored rather than waiting for the app to be
  foregrounded. A pass over error-handling call sites also fixed 16 places where a mismatched
  handler return type could mask the real underlying error.
- Full rebrand: app name, Android `applicationId`/package (`com.klangor.app`), notification
  channel/method-channel identifiers, launcher icons, and the internal builtin-player ID prefix.

For the detailed, commit-by-commit reasoning behind each of these, see the
[Releases page](https://github.com/caique2C/klangor/releases) or the commit history — they're
written as design-decision records, not changelogs.

---

## Features

Klangor currently has the same feature set as the Ensemble version it was forked from:

### Local Playback
- **Stream to Your Phone** - Play music from your Music Assistant library directly on your mobile device via Sendspin protocol
- **Background Playback** - Music continues playing when the app is minimized
- **Media Notifications** - Control playback from your notification shade with album art display
- **Instant Response** - Pause/resume in ~300ms

### Remote Control
- **Multi-Player Support** - Control any speaker or device connected to Music Assistant
- **Device Selector** - Swipe down on mini player to reveal all your devices
- **Multi-Room Grouping** - Long-press any player to sync it with the current player
- **Full Playback Controls** - Play, pause, skip, seek, and adjust volume
- **Volume Precision Mode** - Hold the volume slider for fine-grained control with haptic feedback
- **Power Control** - Turn players on/off directly from the mini player

### Queue Management
- **View & Manage Queue** - See upcoming tracks in the playback queue
- **Drag to Reorder** - Instant drag handles for reordering tracks
- **Swipe left to Delete** - Remove tracks with a simple swipe gesture
- **Swipe right to play next** - Move tracks with a simple swipe gesture

### Home Screen
- **Customizable Rows** - Toggle and reorder: Recently Played, Discover Artists, Discover Albums
- **Favorites Rows** - Optional rows for Favorite Albums, Artists, Tracks, Playlists, and Radio Stations
- **Adaptive Layout** - Rows scale properly for different screen sizes and aspect ratios
- **Pull to Refresh** - Refresh content with a simple pull gesture

### Library
- **Music** - Browse artists, albums, playlists, and tracks from all your music sources
- **Radio Stations** - Browse and play radio stations with list or grid view
- **Podcasts** - Browse podcasts, view episodes with descriptions and publish dates
- **Audiobooks** - Browse by title, series, or author with progress tracking
- **Favorites Filter** - Toggle to show only your favorite items
- **Album Type Filter** - Show/hide albums by type (Album, Single, EP, Compilation, Live, Soundtrack)
- **Providers Filter** - Toggle to show only specific provider items
- **Letter Scrollbar** - Fast navigation through long lists
- **Provider Icons** - Provider icons on library covers

### Search
- **Universal Search** - Find music, podcasts, radio stations, playlists, and audiobooks
- **Fuzzy Matching** - Typo-tolerant search (e.g., "beetles" finds "Beatles")
- **Smart Scoring** - Results ranked by relevance with colored type indicators
- **Search History** - Quickly access your recent searches
- **Quick Actions** - Long-press any result to add to queue or play next

### Audiobooks
- **Chapter Navigation** - Jump between chapters with timestamp display
- **Progress Tracking** - Track your listening progress across sessions
- **Continue Listening** - Pick up where you left off
- **Mark as Finished/Unplayed** - Manage your reading progress
- **Series Support** - View audiobooks organized by series with collage cover art

### Podcasts
- **Episode Browser** - View full episode list with artwork and descriptions
- **Skip Controls** - Skip forward/backward during playback
- **High-Resolution Artwork** - Fetched via iTunes for best quality

### Android Auto
- **Media Browsing** - Browse your library from your car's display with categories for Home, Music, Audiobooks, Podcasts, and Radio
- **Voice Search** - Find and play tracks using voice commands
- **Full Playback Controls** - Play, pause, and skip from your car's head unit
- **Album Art & Metadata** - Track info and artwork displayed on your car's screen
- **Smart Queueing** - Tap any track in an album or playlist to play from that point with the full queue

### Smart Features
- **Instant App Restore** - App loads instantly with cached library data while syncing in background
- **Auto-Reconnect** - Automatically reconnects when connection is lost
- **Offline Browsing** - Browse your cached library even when disconnected
- **Hero Animations** - Smooth transitions between screens
- **Welcome Screen** - Guided onboarding for first-time users

### Theming
- **Material You** - Dynamic theming based on your device's wallpaper
- **Adaptive Colors** - Album artwork-based color schemes
- **Light/Dark Mode** - System-aware or manual theme selection

## Setup

1. Launch the app
2. Enter your Music Assistant server URL
3. Connect to your server
4. Start playing! Music plays on your phone by default, or swipe down on the mini player to choose a different player.

### Finding Your Server URL

**Important:** You need the **Music Assistant** URL, not your Home Assistant URL.

To find the correct URL:
1. Open Music Assistant web UI
2. Go to **Settings** > **About**
3. Look for **Base URL** (e.g., `http://192.168.1.100:8095`)

### Home Assistant Add-on Users

If you run Music Assistant as a Home Assistant add-on:
- Use the IP address of your Home Assistant server
- Do **not** use your Home Assistant URL or ingress URL

### Android Auto

Since Klangor is not installed from the Play Store, you need to enable unknown sources in Android Auto:

1. Open **Android Auto** settings on your phone
2. Tap the **Version** number at the bottom 10 times to enable developer mode
3. Tap the three-dot menu and open **Developer settings**
4. Enable **Unknown sources**
5. Connect your phone to your car via USB or wirelessly
6. Klangor will appear in Android Auto's app list

### Remote Access

For access outside your home network, you'll need to expose Music Assistant through a reverse proxy (e.g., Traefik, Nginx Proxy Manager, Cloudflare Tunnel).

## Requirements

- Music Assistant server (v2.7.0 beta 20 or later recommended)
- Network connectivity to your Music Assistant server
- Android device (Android 5.0+)
- Audiobookshelf provider configured in Music Assistant (for audiobook features)

## Credits

- **[Ensemble](https://github.com/CollotsSpot/Ensemble)** by [Chris Laycock / CollotsSpot](https://github.com/CollotsSpot) — the original project this fork is based on. All core design, feature set, and most of the UI originate there. If you don't need this fork's specific fixes, use upstream Ensemble instead, and consider supporting its author.

## License

MIT License — see [LICENSE](LICENSE). Retains the original Ensemble copyright per the terms of
the MIT license it was released under, plus a copyright notice for this fork's changes.

---

## For Developers

<details>
<summary>Build from Source</summary>

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK

### Build Instructions

1. Clone the repository
```bash
git clone https://github.com/caique2C/klangor.git
cd klangor
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate localizations and Drift database code
```bash
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
```

4. Generate launcher icons
```bash
flutter pub run flutter_launcher_icons
```

5. Build APK
```bash
flutter build apk --release
```

The APK will be available at `build/app/outputs/flutter-apk/app-release.apk`

</details>

<details>
<summary>Technologies Used</summary>

- **Flutter** - Cross-platform mobile framework
- **audio_service** - Background playback and media notifications
- **web_socket_channel** - WebSocket communication with Music Assistant
- **provider** - State management
- **drift** - Relational local database (library cache)
- **cached_network_image** / custom `ImageService` - Image caching, shared with Android Auto
- **shared_preferences** - Local settings storage

</details>
