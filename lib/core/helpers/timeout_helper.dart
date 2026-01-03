import 'dart:async';

class TimeoutHelper {
  static Future<T> run<T>(
      Future<T> future, {
        Duration duration = const Duration(seconds: 5 ),
        String? timeoutMessage,
      }) {
    return future.timeout(
      duration,
      onTimeout: () {
        throw TimeoutException(
          timeoutMessage ?? 'Request timeout',
        );
      },
    );
  }
}
