import 'dart:io';
import 'debug_logger.dart';

/// Error types for user-friendly messages
enum ErrorType {
  connection,
  certificate,
  dns,
  noIPv4,
  noIPv6,
  authentication,
  network,
  playback,
  library,
  unknown,
}

class ErrorInfo {
  final ErrorType type;
  final String userMessage;
  final String technicalMessage;
  final bool canRetry;

  ErrorInfo({
    required this.type,
    required this.userMessage,
    required this.technicalMessage,
    this.canRetry = true,
  });
}

class ErrorHandler {
  static final _logger = DebugLogger();

  /// Convert technical errors into user-friendly error messages
  static ErrorInfo handleError(dynamic error, {String context = ''}) {
    _logger.log('❌ Error in $context: $error');

    // Prefer the real exception type over string-sniffing where we have
    // one: dart:io throws distinct types for DNS lookup failures, routing
    // failures (no IPv4/IPv6 path to the host) and TLS/certificate
    // problems, and the OSError attached to a SocketException carries the
    // POSIX errno, which is far more reliable than matching on message text
    // that varies by platform and OS locale.
    if (error is SocketException) {
      final info = _classifySocketException(error);
      if (info != null) return info;
    }

    if (error is HandshakeException || error is TlsException || error is CertificateException) {
      return _classifyTlsError(error);
    }

    final errorStr = error.toString().toLowerCase();

    // TLS/certificate errors - e.g. a server behind a reverse proxy that
    // requires mutual TLS (a client certificate), rejected because none was
    // presented, an expired one, or a wrong password preventing it from
    // being loaded. Checked before the generic network case below since
    // these often also mention "socket"/"connection".
    if (errorStr.contains('handshake') ||
        errorStr.contains('certificate') ||
        errorStr.contains('tlsexception') ||
        errorStr.contains('sslexception') ||
        errorStr.contains('bad_certificate') ||
        errorStr.contains('certificate_required')) {
      return ErrorInfo(
        type: ErrorType.certificate,
        userMessage: 'Secure connection failed. If your server requires a client certificate, check it\'s imported and still valid.',
        technicalMessage: error.toString(),
        canRetry: true,
      );
    }

    // Connection errors
    if (errorStr.contains('not connected') ||
        errorStr.contains('disconnected') ||
        errorStr.contains('connection closed')) {
      return ErrorInfo(
        type: ErrorType.connection,
        userMessage: 'Not connected to Music Assistant',
        technicalMessage: error.toString(),
        canRetry: true,
      );
    }

    // Network errors
    if (errorStr.contains('socket') ||
        errorStr.contains('network') ||
        errorStr.contains('timeout') ||
        errorStr.contains('failed host lookup')) {
      return ErrorInfo(
        type: ErrorType.network,
        userMessage: 'Network connection failed. Please check your connection.',
        technicalMessage: error.toString(),
        canRetry: true,
      );
    }

    // Authentication errors
    if (errorStr.contains('401') ||
        errorStr.contains('unauthorized') ||
        errorStr.contains('authentication') ||
        errorStr.contains('auth')) {
      return ErrorInfo(
        type: ErrorType.authentication,
        userMessage: 'Authentication failed. Please check your credentials.',
        technicalMessage: error.toString(),
        canRetry: false,
      );
    }

    // Unavailable content errors - these won't resolve with retry
    if (errorStr.contains('no playable') ||
        errorStr.contains('lack available providers') ||
        errorStr.contains('no available providers')) {
      return ErrorInfo(
        type: ErrorType.playback,
        userMessage: 'These tracks are unavailable. The music provider may not have them available for streaming.',
        technicalMessage: error.toString(),
        canRetry: false,
      );
    }

    // Playback errors
    if (errorStr.contains('queue') ||
        errorStr.contains('player') ||
        errorStr.contains('track')) {
      return ErrorInfo(
        type: ErrorType.playback,
        userMessage: 'Playback failed. Please try again.',
        technicalMessage: error.toString(),
        canRetry: true,
      );
    }

    // Library/content errors
    if (errorStr.contains('library') ||
        errorStr.contains('not found') ||
        errorStr.contains('no result')) {
      return ErrorInfo(
        type: ErrorType.library,
        userMessage: 'Failed to load content. Please try again.',
        technicalMessage: error.toString(),
        canRetry: true,
      );
    }

    // Unknown errors
    return ErrorInfo(
      type: ErrorType.unknown,
      userMessage: 'An unexpected error occurred. Please try again.',
      technicalMessage: error.toString(),
      canRetry: true,
    );
  }

  /// Classifies a [SocketException] using its [OSError] errno (reliable,
  /// locale/platform independent) with a message-substring fallback for
  /// platforms/cases where the errno isn't populated. Returns null to fall
  /// through to the generic string-matching path below for anything that
  /// isn't one of the specific cases we distinguish here.
  static ErrorInfo? _classifySocketException(SocketException error) {
    final errorCode = error.osError?.errorCode;
    final message = '${error.message} ${error.osError?.message ?? ''}'.toLowerCase();
    final addressType = error.address?.type;

    // DNS resolution failure (EAI_NONAME on Linux/Android, EAI_NODATA, or
    // the "Failed host lookup" wording dart:io itself uses on Android).
    if (errorCode == -2 ||
        errorCode == -5 ||
        message.contains('failed host lookup') ||
        message.contains('name or service not known') ||
        message.contains('nodename nor servname')) {
      return ErrorInfo(
        type: ErrorType.dns,
        userMessage: "Couldn't resolve the server's address (DNS lookup failed). Check the hostname, or that Tailscale/your VPN is connected.",
        technicalMessage: error.toString(),
        canRetry: true,
      );
    }

    // ENETUNREACH ("Network is unreachable") - no route to that address
    // family at all. When we know which address family was being dialed
    // (dart:io attaches it to the exception), say so specifically.
    if (errorCode == 101 || message.contains('network is unreachable')) {
      if (addressType == InternetAddressType.IPv6) {
        return ErrorInfo(
          type: ErrorType.noIPv6,
          userMessage: 'No IPv6 connectivity to the server. Try disabling IPv6 for this connection, or check your network/Tailscale settings.',
          technicalMessage: error.toString(),
          canRetry: true,
        );
      }
      if (addressType == InternetAddressType.IPv4) {
        return ErrorInfo(
          type: ErrorType.noIPv4,
          userMessage: 'No IPv4 connectivity to the server. Check your network/Tailscale settings.',
          technicalMessage: error.toString(),
          canRetry: true,
        );
      }
      return ErrorInfo(
        type: ErrorType.network,
        userMessage: 'The network is unreachable. Check your connection and that Tailscale/your VPN is up.',
        technicalMessage: error.toString(),
        canRetry: true,
      );
    }

    // EHOSTUNREACH ("No route to host") - the address resolved, but nothing
    // on the path could route to it (common when a VPN/tailnet is up but
    // hasn't established a route to that specific peer yet).
    if (errorCode == 113 || message.contains('no route to host')) {
      return ErrorInfo(
        type: addressType == InternetAddressType.IPv6 ? ErrorType.noIPv6 : ErrorType.noIPv4,
        userMessage: 'No route to the server (device found, but unreachable). If you\'re using Tailscale, check the connection to that device.',
        technicalMessage: error.toString(),
        canRetry: true,
      );
    }

    // ECONNREFUSED - reached the host, but nothing is listening on that port.
    if (errorCode == 111 || message.contains('connection refused')) {
      return ErrorInfo(
        type: ErrorType.network,
        userMessage: 'Connection refused by the server. Check the port and that Music Assistant is running.',
        technicalMessage: error.toString(),
        canRetry: true,
      );
    }

    // ETIMEDOUT - reached nothing and no rejection came back either.
    if (errorCode == 110 || message.contains('connection timed out') || message.contains('timed out')) {
      return ErrorInfo(
        type: ErrorType.network,
        userMessage: 'Connection timed out. The server didn\'t respond - check your network and that the server is reachable.',
        technicalMessage: error.toString(),
        canRetry: true,
      );
    }

    return null;
  }

  /// Classifies a TLS-layer failure (dart:io throws [HandshakeException],
  /// [TlsException], or the more specific [CertificateException]),
  /// distinguishing a server demanding/rejecting a client certificate from
  /// a plain handshake failure.
  static ErrorInfo _classifyTlsError(Object error) {
    final message = error.toString().toLowerCase();
    String userMessage;

    if (message.contains('certificate_required') || message.contains('certificate required')) {
      userMessage = 'The server requires a client certificate, but none is installed (or it was rejected). Import one in Settings.';
    } else if (message.contains('bad_certificate') ||
        message.contains('unknown_ca') ||
        message.contains('unknown ca') ||
        message.contains('certificate unknown')) {
      userMessage = 'The server rejected the client certificate. It may be expired, revoked, or issued by an untrusted CA.';
    } else if (message.contains('certificate verify failed') || message.contains('certificate has expired')) {
      userMessage = "The server's certificate could not be verified. It may be expired, self-signed, or untrusted.";
    } else {
      userMessage = 'Secure connection failed. If your server requires a client certificate, check it\'s imported and still valid.';
    }

    return ErrorInfo(
      type: ErrorType.certificate,
      userMessage: userMessage,
      technicalMessage: error.toString(),
      canRetry: true,
    );
  }

  /// Get user-friendly message for specific operations
  static String getOperationErrorMessage(String operation, dynamic error) {
    final errorInfo = handleError(error, context: operation);
    return errorInfo.userMessage;
  }

  /// Check if error is retryable
  static bool isRetryable(dynamic error) {
    final errorInfo = handleError(error);
    return errorInfo.canRetry;
  }

  /// Log error with context
  static void logError(String context, dynamic error, {StackTrace? stackTrace}) {
    _logger.log('❌ [$context] $error');
    if (stackTrace != null) {
      _logger.log('Stack trace: $stackTrace');
    }
  }
}
