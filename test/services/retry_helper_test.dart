import 'package:flutter_test/flutter_test.dart';
import 'package:ensemble/services/retry_helper.dart';

void main() {
  group('RetryHelper.retry', () {
    test('returns the result on first success without retrying', () async {
      var calls = 0;
      final result = await RetryHelper.retry<int>(
        operation: () async {
          calls++;
          return 42;
        },
      );

      expect(result, 42);
      expect(calls, 1);
    });

    test('retries after a failure and succeeds within maxAttempts', () async {
      var calls = 0;
      final result = await RetryHelper.retry<String>(
        operation: () async {
          calls++;
          if (calls < 3) throw Exception('transient failure');
          return 'ok';
        },
        maxAttempts: 5,
        initialDelaySeconds: 0,
        maxDelaySeconds: 0,
      );

      expect(result, 'ok');
      expect(calls, 3);
    });

    test('rethrows after exhausting maxAttempts', () async {
      var calls = 0;
      await expectLater(
        RetryHelper.retry<int>(
          operation: () async {
            calls++;
            throw Exception('always fails');
          },
          maxAttempts: 3,
          initialDelaySeconds: 0,
          maxDelaySeconds: 0,
        ),
        throwsA(isA<Exception>()),
      );

      expect(calls, 3);
    });

    test('stops immediately when shouldRetry returns false', () async {
      var calls = 0;
      await expectLater(
        RetryHelper.retry<int>(
          operation: () async {
            calls++;
            throw Exception('permanent failure');
          },
          maxAttempts: 5,
          initialDelaySeconds: 0,
          maxDelaySeconds: 0,
          shouldRetry: (_) => false,
        ),
        throwsA(isA<Exception>()),
      );

      // Should fail on the very first attempt, not retry.
      expect(calls, 1);
    });
  });
}
