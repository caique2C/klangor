import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'secure_storage_service.dart';
import 'debug_logger.dart';

/// Thrown when an imported PKCS12 file/password can't be used to build a
/// [SecurityContext] (wrong password, corrupt file, unsupported format).
class InvalidClientCertificateException implements Exception {
  final String message;
  InvalidClientCertificateException(this.message);

  @override
  String toString() => message;
}

/// Manages the client certificate used for mutual TLS (mTLS).
///
/// Some Music Assistant servers sit behind a reverse proxy (e.g. Traefik)
/// that requires a private client certificate at the TLS handshake itself,
/// before any HTTP/WebSocket request reaches the app. MA itself has no
/// concept of this — it's enforced entirely below the application layer —
/// so this is wired in globally via [HttpOverrides] rather than per-request.
///
/// The certificate is stored as PKCS12 (.p12/.pfx) bytes plus its password,
/// both in the same encrypted secure storage already used for login
/// credentials (see [SecureStorageService]).
class ClientCertificateService {
  ClientCertificateService._();
  static final ClientCertificateService instance = ClientCertificateService._();

  final _logger = DebugLogger();

  Future<bool> hasCertificate() async {
    final p12 = await SecureStorageService.getClientCertP12Base64();
    return p12 != null;
  }

  Future<DateTime?> importedAt() => SecureStorageService.getClientCertImportedAt();

  /// Validates the given PKCS12 bytes/password by attempting to build a
  /// [SecurityContext] from them, then stores them if that succeeds.
  /// Throws [InvalidClientCertificateException] if the bytes/password don't
  /// produce a usable certificate+key pair.
  Future<void> importP12(Uint8List bytes, String password) async {
    _buildContextFromP12(bytes, password); // throws if invalid

    await SecureStorageService.setClientCertificate(
      p12Base64: base64Encode(bytes),
      password: password,
    );
    _logger.log('🔐 Client certificate imported (${bytes.length} bytes)');
  }

  Future<void> clearCertificate() async {
    await SecureStorageService.clearClientCertificate();
    _logger.log('🔐 Client certificate removed');
  }

  /// Builds a [SecurityContext] with the platform's trusted roots (so the
  /// server's own TLS certificate is still validated normally) plus the
  /// stored client certificate/key for mTLS. Returns null if no certificate
  /// has been imported.
  Future<SecurityContext?> buildSecurityContext() async {
    final p12Base64 = await SecureStorageService.getClientCertP12Base64();
    if (p12Base64 == null) return null;

    final password = await SecureStorageService.getClientCertPassword();
    if (password == null) return null;

    try {
      return _buildContextFromP12(base64Decode(p12Base64), password);
    } catch (e) {
      _logger.log('⚠️ Stored client certificate is no longer valid: $e');
      return null;
    }
  }

  SecurityContext _buildContextFromP12(Uint8List bytes, String password) {
    final context = SecurityContext(withTrustedRoots: true);
    try {
      context.useCertificateChainBytes(bytes, password: password);
      context.usePrivateKeyBytes(bytes, password: password);
    } on TlsException catch (e) {
      throw InvalidClientCertificateException(
        'Could not read certificate — check the file and password. (${e.message})',
      );
    }
    return context;
  }
}

/// Installed as [HttpOverrides.global] at startup when a client certificate
/// is configured. This is the one mechanism that reaches every TLS
/// connection the app makes (the MA WebSocket, Sendspin's WebSocket, plain
/// HTTP image/API fetches) without threading a custom HttpClient through
/// each of them individually - dart:io's WebSocket.connect and package:http
/// both fall back to HttpClient(), which respects this override.
class ClientCertHttpOverrides extends HttpOverrides {
  final SecurityContext _clientContext;
  ClientCertHttpOverrides(this._clientContext);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(_clientContext);
  }
}
