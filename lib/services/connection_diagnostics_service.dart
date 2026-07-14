import 'dart:async';
import 'dart:io';
import 'client_certificate_service.dart';
import 'settings_service.dart';
import 'debug_logger.dart';

/// Result of a single diagnostic check. [unknown] is distinct from [failed]
/// so the UI can show a neutral state instead of a false red for something
/// that simply hasn't been determined yet (e.g. a cert-required hint that
/// has never been probed). [skipped] means the check doesn't apply (e.g. no
/// AAAA record at all, so there's nothing to judge IPv6 reachability by).
enum DiagnosticStatus { unknown, ok, failed, skipped }

class ConnectionDiagnostics {
  final DiagnosticStatus dnsStatus;
  final Duration? dnsTime;
  final DiagnosticStatus ipv4Status;
  final DiagnosticStatus ipv6Status;
  final bool certificateConfigured;
  final DiagnosticStatus certificateStatus;
  final bool serverConnected;
  final Duration? roundTripTime;
  final DateTime checkedAt;

  const ConnectionDiagnostics({
    required this.dnsStatus,
    this.dnsTime,
    required this.ipv4Status,
    required this.ipv6Status,
    required this.certificateConfigured,
    required this.certificateStatus,
    required this.serverConnected,
    this.roundTripTime,
    required this.checkedAt,
  });
}

/// Runs a fresh set of network/connectivity checks against the configured
/// server on demand - nothing here is cached, so every call reflects
/// current reality rather than whatever happened to be true the last time
/// something rendered this screen.
class ConnectionDiagnosticsService {
  static final _logger = DebugLogger();

  static Future<ConnectionDiagnostics> run({
    required String serverUrl,
    required bool serverConnected,
    Future<Duration?> Function()? measureRoundTripTime,
  }) async {
    final uri = _parseServerUri(serverUrl);
    final host = uri.host;
    final port = uri.hasPort ? uri.port : (uri.scheme == 'http' || uri.scheme == 'ws' ? 8095 : 443);

    var addresses = <InternetAddress>[];
    var dnsStatus = DiagnosticStatus.failed;
    Duration? dnsTime;
    try {
      final stopwatch = Stopwatch()..start();
      addresses = await InternetAddress.lookup(host).timeout(const Duration(seconds: 5));
      stopwatch.stop();
      dnsTime = stopwatch.elapsed;
      dnsStatus = addresses.isNotEmpty ? DiagnosticStatus.ok : DiagnosticStatus.failed;
    } catch (e) {
      _logger.log('Diagnostics: DNS lookup for $host failed: $e');
    }

    // Run both address families concurrently rather than back-to-back -
    // each can take up to a few seconds to time out on an unreachable
    // family (e.g. no IPv6 route), and there's no reason to pay that twice
    // in sequence.
    final results = await Future.wait([
      _checkAddressFamily(addresses, InternetAddressType.IPv4, port),
      _checkAddressFamily(addresses, InternetAddressType.IPv6, port),
    ]);
    final ipv4Status = results[0];
    final ipv6Status = results[1];

    final certConfigured = await ClientCertificateService.instance.hasCertificate();
    final certRequiredHint = await SettingsService.getClientCertRequiredHint();
    final certStatus = _resolveCertificateStatus(
      configured: certConfigured,
      requiredHint: certRequiredHint,
      serverConnected: serverConnected,
      basicConnectivityOk: ipv4Status == DiagnosticStatus.ok || ipv6Status == DiagnosticStatus.ok,
    );

    Duration? rtt;
    if (serverConnected && measureRoundTripTime != null) {
      rtt = await measureRoundTripTime();
    }

    return ConnectionDiagnostics(
      dnsStatus: dnsStatus,
      dnsTime: dnsTime,
      ipv4Status: ipv4Status,
      ipv6Status: ipv6Status,
      certificateConfigured: certConfigured,
      certificateStatus: certStatus,
      serverConnected: serverConnected,
      roundTripTime: rtt,
      checkedAt: DateTime.now(),
    );
  }

  static DiagnosticStatus _resolveCertificateStatus({
    required bool configured,
    required bool? requiredHint,
    required bool serverConnected,
    required bool basicConnectivityOk,
  }) {
    if (!configured) {
      // No cert configured: this row is about the TLS/cert layer not being
      // what's blocking the connection, not about whether one exists.
      return basicConnectivityOk || serverConnected ? DiagnosticStatus.ok : DiagnosticStatus.unknown;
    }
    if (serverConnected) {
      // Connected at all means whatever cert decision runWithCertFallback()
      // made (needed+presented, or skipped) worked for this server.
      return DiagnosticStatus.ok;
    }
    if (requiredHint == true) {
      // Previously confirmed required, but we're not connected right now -
      // can't tell from here alone whether the cert is the reason, but
      // it's the most actionable thing to flag.
      return DiagnosticStatus.failed;
    }
    return DiagnosticStatus.unknown;
  }

  static Uri _parseServerUri(String serverUrl) {
    var url = serverUrl;
    if (!url.contains('://')) {
      url = 'https://$url';
    }
    return Uri.parse(url);
  }

  static Future<DiagnosticStatus> _checkAddressFamily(
    List<InternetAddress> addresses,
    InternetAddressType type,
    int port,
  ) async {
    final candidates = addresses.where((a) => a.type == type).toList();
    if (candidates.isEmpty) {
      return DiagnosticStatus.skipped;
    }
    // Only the first resolved address - trying every candidate in sequence
    // could multiply an unreachable family's timeout by however many
    // records the server has, for no real diagnostic benefit.
    try {
      final socket = await Socket.connect(candidates.first, port, timeout: const Duration(seconds: 3));
      socket.destroy();
      return DiagnosticStatus.ok;
    } catch (e) {
      _logger.log('Diagnostics: ${type.name} connect to ${candidates.first}:$port failed: $e');
      return DiagnosticStatus.failed;
    }
  }
}
