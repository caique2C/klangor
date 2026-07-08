import 'package:flutter_test/flutter_test.dart';
import 'package:klangor/models/player.dart';
import 'package:klangor/repositories/player_repository.dart';

Player _player(String id) => Player(
      playerId: id,
      name: id,
      available: true,
      powered: true,
      state: 'idle',
    );

void main() {
  group('PlayerRepository.idsMatch', () {
    test('matches identical ids', () {
      expect(PlayerRepository.idsMatch('klangor_harald', 'klangor_harald'), isTrue);
    });

    test('matches when one side is "up"-prefixed (universal_player wrapping)', () {
      expect(PlayerRepository.idsMatch('upklangor_harald', 'klangor_harald'), isTrue);
    });

    test('matches case-insensitively for the "up"-prefixed form', () {
      expect(PlayerRepository.idsMatch('UPKlangor_Harald', 'klangor_harald'), isTrue);
    });

    test('does not match unrelated ids', () {
      expect(PlayerRepository.idsMatch('klangor_harald', 'chromecast_kitchen'), isFalse);
    });

    test('does not match a merely-similar id that is not actually up-prefixed', () {
      expect(PlayerRepository.idsMatch('supklangor_harald', 'klangor_harald'), isFalse);
    });
  });

  group('PlayerRepository.resolve / resolvePlayerId', () {
    test('resolves a raw id to the live up-prefixed player id', () {
      final repo = PlayerRepository(() => [_player('upklangor_harald')]);

      final handle = repo.resolve('klangor_harald');

      expect(handle.id, 'upklangor_harald');
      expect(repo.resolvePlayerId('klangor_harald'), 'upklangor_harald');
    });

    test('returns the exact id unchanged when it already matches a live player', () {
      final repo = PlayerRepository(() => [_player('klangor_harald')]);
      expect(repo.resolvePlayerId('klangor_harald'), 'klangor_harald');
    });

    test('falls back to the raw id when no live player matches', () {
      final repo = PlayerRepository(() => [_player('chromecast_kitchen')]);
      expect(repo.resolvePlayerId('klangor_harald'), 'klangor_harald');
    });

    test('falls back to the raw id when the player list is empty', () {
      final repo = PlayerRepository(() => []);
      expect(repo.resolvePlayerId('klangor_harald'), 'klangor_harald');
    });

    test('re-reads the player list on every call (reflects live updates)', () {
      var players = <Player>[];
      final repo = PlayerRepository(() => players);

      expect(repo.resolvePlayerId('klangor_harald'), 'klangor_harald');

      players = [_player('upklangor_harald')];
      expect(repo.resolvePlayerId('klangor_harald'), 'upklangor_harald');
    });
  });

  group('PlayerRepository.idsMatchRaw / resolveRaw', () {
    test('matches a RawPlayerId the same way idsMatch would for its string', () {
      const raw = RawPlayerId('klangor_harald');
      expect(PlayerRepository.idsMatchRaw('upklangor_harald', raw), isTrue);
      expect(PlayerRepository.idsMatchRaw('chromecast_kitchen', raw), isFalse);
    });

    test('resolveRaw/resolveRawId resolve a RawPlayerId to the live wrapped id', () {
      final repo = PlayerRepository(() => [_player('upklangor_harald')]);
      const raw = RawPlayerId('klangor_harald');

      expect(repo.resolveRaw(raw).id, 'upklangor_harald');
      expect(repo.resolveRawId(raw), 'upklangor_harald');
    });
  });

  group('RawPlayerId', () {
    test('toString reveals the underlying value for logging', () {
      expect(const RawPlayerId('klangor_harald').toString(), 'klangor_harald');
    });
  });

  group('PlayerHandle', () {
    test('equality is value-based', () {
      expect(const PlayerHandle('a'), const PlayerHandle('a'));
      expect(const PlayerHandle('a') == const PlayerHandle('b'), isFalse);
    });

    test('toString returns the underlying id', () {
      expect(const PlayerHandle('klangor_harald').toString(), 'klangor_harald');
    });
  });
}
