import 'package:flutter_test/flutter_test.dart';
import 'package:ensemble/services/error_handler.dart';

void main() {
  group('ErrorHandler.handleError', () {
    test('classifies disconnection errors as connection, retryable', () {
      final info = ErrorHandler.handleError(Exception('Not connected to server'));
      expect(info.type, ErrorType.connection);
      expect(info.canRetry, isTrue);
    });

    test('classifies socket/timeout errors as network, retryable', () {
      final info = ErrorHandler.handleError(Exception('SocketException: timeout'));
      expect(info.type, ErrorType.network);
      expect(info.canRetry, isTrue);
    });

    test('classifies 401/auth errors as authentication, not retryable', () {
      final info = ErrorHandler.handleError(Exception('401 Unauthorized'));
      expect(info.type, ErrorType.authentication);
      expect(info.canRetry, isFalse);
    });

    test('classifies "no playable" provider errors as non-retryable playback errors', () {
      final info = ErrorHandler.handleError(Exception('No playable streams: lack available providers'));
      expect(info.type, ErrorType.playback);
      expect(info.canRetry, isFalse);
    });

    test('classifies queue/player errors as retryable playback errors', () {
      final info = ErrorHandler.handleError(Exception('Queue ensemble_player is not available'));
      expect(info.type, ErrorType.playback);
      expect(info.canRetry, isTrue);
    });

    test('classifies library/not-found errors as retryable library errors', () {
      final info = ErrorHandler.handleError(Exception('Item not found in library'));
      expect(info.type, ErrorType.library);
      expect(info.canRetry, isTrue);
    });

    test('falls back to unknown, retryable for unrecognized errors', () {
      final info = ErrorHandler.handleError(Exception('Something completely unexpected'));
      expect(info.type, ErrorType.unknown);
      expect(info.canRetry, isTrue);
    });

    test('matching is checked in priority order (connection before network)', () {
      // Contains both "disconnected" (connection) and "network" - connection
      // is checked first in ErrorHandler and should win.
      final info = ErrorHandler.handleError(Exception('disconnected: network unreachable'));
      expect(info.type, ErrorType.connection);
    });
  });

  group('ErrorHandler.isRetryable', () {
    test('mirrors handleError.canRetry', () {
      expect(ErrorHandler.isRetryable(Exception('401 Unauthorized')), isFalse);
      expect(ErrorHandler.isRetryable(Exception('timeout')), isTrue);
    });
  });

  group('ErrorHandler.getOperationErrorMessage', () {
    test('returns the user-facing message for the classified error', () {
      final message = ErrorHandler.getOperationErrorMessage('login', Exception('401 Unauthorized'));
      expect(message, 'Authentication failed. Please check your credentials.');
    });
  });
}
