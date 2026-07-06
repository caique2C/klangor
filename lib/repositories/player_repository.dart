import '../models/player.dart';
import '../services/debug_logger.dart';

/// Opaque wrapper for a player id as persisted by `SettingsService`
/// (currently only the builtin/local player id) - i.e. a value that may be
/// stale relative to whatever live id Music Assistant is using right now.
///
/// This type deliberately has no public accessor for the underlying string
/// and no `==` against [String]: the bug this session kept re-appearing
/// (raw stored id compared directly to a live [Player.playerId], three
/// separate times, in three separate files, after already being "fixed"
/// once) happened precisely because both sides of that comparison were
/// plain [String] and looked interchangeable. Making this type distinct
/// doesn't make the mistake a compile error (Dart's `==` accepts any
/// [Object]), but it does mean there is no direct way to read a comparable
/// value out of it anywhere outside this file - the only things you can do
/// with one are pass it to [PlayerRepository.idsMatchRaw]/[resolveRaw], or
/// log it. If you find yourself wanting more than that, you're probably
/// about to reintroduce this bug.
class RawPlayerId {
  final String _value;
  const RawPlayerId(this._value);

  @override
  String toString() => _value;
}

/// Opaque handle for a player id that Music Assistant is *currently* using,
/// as opposed to a raw/stored id that may be stale. Prefer this over passing
/// a bare [String] around wherever a new call site can adopt it - it makes
/// "did I forget to resolve this id?" a compile-time question instead of a
/// runtime bug.
class PlayerHandle {
  final String id;
  const PlayerHandle(this.id);

  @override
  String toString() => id;

  @override
  bool operator ==(Object other) => other is PlayerHandle && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Single owner of Music Assistant player-id resolution.
///
/// Newer Music Assistant versions wrap Sendspin-registered players behind a
/// `universal_player` entry whose id is `"up" + lowercase(original id)`. Any
/// code that compares or sends a stored/raw player id (e.g. from
/// `SettingsService.getBuiltinPlayerId()`) against MA's live player list must
/// go through [idsMatch]/[resolve] rather than comparing raw strings
/// directly. Doing the raw comparison inline was previously the cause of a
/// class of bugs - unresponsive hardware volume, playback lag on
/// pause/skip, and Android Auto's "Queue ... is not available" error -
/// because the same fix had to be applied independently at ~18 call sites
/// instead of owned in one place. Don't re-implement this at a new call
/// site; depend on this repository instead.
class PlayerRepository {
  final List<Player> Function() _players;
  final DebugLogger _logger = DebugLogger();

  PlayerRepository(this._players);

  static bool idsMatch(String playerId, String otherId) =>
      playerId == otherId || playerId.toLowerCase() == 'up${otherId.toLowerCase()}';

  /// Resolve a stored/raw player id to whatever id Music Assistant is
  /// actually using for that player right now.
  PlayerHandle resolve(String rawId) {
    final match = _players().where((p) => idsMatch(p.playerId, rawId)).firstOrNull;
    final resolvedId = match?.playerId ?? rawId;
    // Only log when resolution actually changes something (the universal_player
    // wrapping case) or fails to find a match - this is the exact signal that
    // was missing while diagnosing this session's ID-mismatch bugs.
    if (resolvedId != rawId) {
      _logger.debug('Resolved player id "$rawId" -> "$resolvedId"', context: 'PlayerRepository');
    } else if (match == null) {
      _logger.debug('No live player matches "$rawId" - using raw id as-is', context: 'PlayerRepository');
    }
    return PlayerHandle(resolvedId);
  }

  /// Convenience for call sites not yet migrated to [PlayerHandle].
  String resolvePlayerId(String rawId) => resolve(rawId).id;

  /// [idsMatch], but for a [RawPlayerId] straight from SettingsService -
  /// the standard way to check "is this live player the stored builtin one".
  static bool idsMatchRaw(String playerId, RawPlayerId rawOtherId) =>
      idsMatch(playerId, rawOtherId._value);

  /// [resolve], but for a [RawPlayerId] straight from SettingsService.
  PlayerHandle resolveRaw(RawPlayerId rawId) => resolve(rawId._value);

  /// [resolvePlayerId], but for a [RawPlayerId] straight from SettingsService.
  String resolveRawId(RawPlayerId rawId) => resolveRaw(rawId).id;
}
