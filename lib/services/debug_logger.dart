import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';

/// Log levels for filtering and display
enum LogLevel {
  perf,   // Performance timing (for FPS diagnosis)
  debug,  // Verbose debugging info (hidden by default)
  info,   // General information
  warning, // Potential issues
  error,  // Errors and failures
}

class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? context;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.context,
  });

  String get formatted {
    final time = timestamp.toIso8601String().substring(11, 23);
    final levelStr = level.name.toUpperCase().padRight(5);
    final contextStr = context != null ? '[$context] ' : '';
    return '[$time] $levelStr $contextStr$message';
  }
}

class DebugLogger {
  static final DebugLogger _instance = DebugLogger._internal();
  factory DebugLogger() => _instance;
  DebugLogger._internal();

  final List<LogEntry> _entries = [];
  final _maxLogs = 1000;

  // --- File persistence (survives a process restart) -------------------------
  //
  // The in-memory ring buffer above is lost whenever the app process is killed
  // (exactly what happens when Android / Android Auto cold-starts or reaps the
  // app). To keep logs across such a restart, every entry is also appended to
  // an on-disk file.
  //
  // Overflow protection: two rotating files. When the active file would exceed
  // [_maxLogFileBytes], it is rotated to "<name>.1" (replacing any previous
  // ".1") and a fresh active file is started. On-disk usage therefore never
  // exceeds ~2 × _maxLogFileBytes, no matter how long the app runs.
  static const int _maxLogFileBytes = 512 * 1024; // 512 KB per file (~1 MB total)
  static const int _maxPendingBeforeReady = 500;

  File? _logFile; // active file
  File? _logFileOld; // rotated ("previous") file
  int _currentFileBytes = 0;
  bool _fileLoggingReady = false;
  // Entries logged before initFileLogging() completes are held here, then
  // flushed to disk once the file is ready (bounded so a failed init can't
  // grow this without limit).
  final List<String> _pendingBeforeReady = [];
  // Serializes all disk writes so appends/rotation never interleave.
  Future<void> _writeChain = Future.value();

  /// Initialise on-disk log persistence. Call once, early in main(), before
  /// other startup logging so those lines are persisted too. Safe to call even
  /// if it fails — logging never throws into the app.
  Future<void> initFileLogging() async {
    try {
      final dir = await getApplicationSupportDirectory();
      final logDir = Directory('${dir.path}/logs');
      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }
      _logFile = File('${logDir.path}/klangor.log');
      _logFileOld = File('${logDir.path}/klangor.log.1');
      if (await _logFile!.exists()) {
        _currentFileBytes = await _logFile!.length();
      }
      _fileLoggingReady = true;

      // Session marker makes restarts easy to spot when reading the file back.
      _enqueueWrite('\n===== session start ${DateTime.now().toIso8601String()} =====\n');

      // Flush anything logged before the file was ready.
      if (_pendingBeforeReady.isNotEmpty) {
        _enqueueWrite('${_pendingBeforeReady.join('\n')}\n');
        _pendingBeforeReady.clear();
      }
    } catch (e) {
      // Never let logging break the app.
      debugPrint('DebugLogger: file logging init failed: $e');
    }
  }

  void _persist(String line) {
    if (!_fileLoggingReady) {
      if (_pendingBeforeReady.length < _maxPendingBeforeReady) {
        _pendingBeforeReady.add(line);
      }
      return;
    }
    _enqueueWrite('$line\n');
  }

  void _enqueueWrite(String text) {
    final bytes = utf8.encode(text).length;
    _writeChain = _writeChain.then((_) async {
      final file = _logFile;
      if (file == null) return;
      try {
        // Rotate first if this write would push the active file over the cap.
        if (_currentFileBytes + bytes > _maxLogFileBytes) {
          await _rotate();
        }
        // flush:false → written to the OS page cache, which survives the app
        // process being killed (only a device power loss would lose it), so
        // we get restart-durability without an fsync per log line.
        await file.writeAsString(text, mode: FileMode.append, flush: false);
        _currentFileBytes += bytes;
      } catch (e) {
        debugPrint('DebugLogger: file write failed: $e');
      }
    });
  }

  Future<void> _rotate() async {
    final active = _logFile;
    final old = _logFileOld;
    if (active == null || old == null) return;
    try {
      if (await old.exists()) await old.delete();
      if (await active.exists()) await active.rename(old.path);
    } catch (e) {
      debugPrint('DebugLogger: rotate failed: $e');
    }
    _currentFileBytes = 0;
  }

  /// Full persisted log (previous rotated file + active file), oldest first.
  /// Spans process restarts, unlike the in-memory buffer. May begin
  /// mid-stream if rotation has discarded older history.
  Future<String> getPersistedLogs() async {
    final buffer = StringBuffer();
    try {
      await _writeChain; // make sure queued writes have hit disk
      final old = _logFileOld;
      final active = _logFile;
      if (old != null && await old.exists()) {
        buffer.write(await old.readAsString());
      }
      if (active != null && await active.exists()) {
        buffer.write(await active.readAsString());
      }
    } catch (e) {
      debugPrint('DebugLogger: read persisted logs failed: $e');
    }
    return buffer.toString();
  }

  void _clearFiles() {
    _writeChain = _writeChain.then((_) async {
      try {
        if (_logFile != null && await _logFile!.exists()) await _logFile!.delete();
        if (_logFileOld != null && await _logFileOld!.exists()) await _logFileOld!.delete();
      } catch (e) {
        debugPrint('DebugLogger: clear files failed: $e');
      }
      _currentFileBytes = 0;
    });
  }

  // Minimum level to display in debug console (debug builds show all)
  LogLevel _minConsoleLevel = kDebugMode ? LogLevel.debug : LogLevel.info;

  List<LogEntry> get entries => List.unmodifiable(_entries);

  /// Legacy getter for backward compatibility
  List<String> get logs => _entries.map((e) => e.formatted).toList();

  // Set to true to only log perf entries (for FPS diagnosis)
  // Set to false for normal operation with full logging for user bug reports
  static const bool _perfOnlyMode = false;

  void _addEntry(LogLevel level, String message, {String? context}) {
    // In perf-only mode, skip all non-perf logs
    if (_perfOnlyMode && level != LogLevel.perf) {
      return;
    }

    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      context: context,
    );

    // Always store in memory
    _entries.add(entry);
    if (_entries.length > _maxLogs) {
      _entries.removeAt(0);
    }

    // Also persist to disk (survives a process restart; see initFileLogging).
    _persist(entry.formatted);

    // Only print to console if above minimum level
    if (level.index >= _minConsoleLevel.index) {
      debugPrint(entry.formatted);
    }
  }

  /// Debug level - verbose info for development
  void debug(String message, {String? context}) {
    _addEntry(LogLevel.debug, message, context: context);
  }

  /// Info level - general operational info
  void info(String message, {String? context}) {
    _addEntry(LogLevel.info, message, context: context);
  }

  /// Warning level - potential issues
  void warning(String message, {String? context}) {
    _addEntry(LogLevel.warning, message, context: context);
  }

  /// Error level - failures and errors
  void error(String message, {String? context, Object? error, StackTrace? stackTrace}) {
    var fullMessage = message;
    if (error != null) {
      fullMessage += ': $error';
    }
    _addEntry(LogLevel.error, fullMessage, context: context);
    if (stackTrace != null && kDebugMode) {
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Legacy method for backward compatibility
  void log(String message) {
    _addEntry(LogLevel.info, message);
  }

  /// Performance logging - always prints to console for real-time monitoring
  void perf(String message, {String? context}) {
    _addEntry(LogLevel.perf, message, context: context);
  }

  /// Track build time of a widget
  final Map<String, Stopwatch> _buildTimers = {};

  void startBuild(String widgetName) {
    _buildTimers[widgetName] = Stopwatch()..start();
  }

  void endBuild(String widgetName) {
    final sw = _buildTimers.remove(widgetName);
    if (sw != null) {
      sw.stop();
      if (sw.elapsedMilliseconds > 4) { // Only log if > 4ms (slow for 60fps)
        perf('BUILD ${sw.elapsedMilliseconds}ms', context: widgetName);
      }
    }
  }

  /// Track frame times during scroll
  Stopwatch? _frameTimer;
  int _slowFrameCount = 0;
  int _totalFrameCount = 0;

  void startFrame() {
    _frameTimer = Stopwatch()..start();
  }

  void endFrame() {
    if (_frameTimer != null) {
      _frameTimer!.stop();
      _totalFrameCount++;
      final ms = _frameTimer!.elapsedMilliseconds;
      if (ms > 16) { // > 16ms means dropped frame at 60fps
        _slowFrameCount++;
        perf('SLOW FRAME ${ms}ms (${_slowFrameCount}/${_totalFrameCount} slow)', context: 'Scroll');
      }
    }
  }

  void resetFrameStats() {
    _slowFrameCount = 0;
    _totalFrameCount = 0;
  }

  void clear() {
    _entries.clear();
    _clearFiles();
  }

  String getAllLogs() {
    return _entries.map((e) => e.formatted).join('\n');
  }

  /// Get logs filtered by minimum level
  String getLogsFiltered({LogLevel minLevel = LogLevel.info}) {
    return _entries
        .where((e) => e.level.index >= minLevel.index)
        .map((e) => e.formatted)
        .join('\n');
  }

  /// Generate a formatted bug report with device info
  Future<String> generateBugReport() async {
    final buffer = StringBuffer();

    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('Klangor Bug Report');
    buffer.writeln('Generated: ${DateTime.now().toIso8601String()}');
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln();

    // App info
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      buffer.writeln('APP INFO:');
      buffer.writeln('  Version: ${packageInfo.version} (${packageInfo.buildNumber})');
      buffer.writeln('  Package: ${packageInfo.packageName}');
      buffer.writeln();
    } catch (e) {
      buffer.writeln('APP INFO: Unable to retrieve');
      buffer.writeln();
    }

    // Device info
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final android = await deviceInfo.androidInfo;
        buffer.writeln('DEVICE INFO:');
        buffer.writeln('  Model: ${android.manufacturer} ${android.model}');
        buffer.writeln('  Android: ${android.version.release} (SDK ${android.version.sdkInt})');
        buffer.writeln('  Device: ${android.device}');
        buffer.writeln();
      } else if (Platform.isIOS) {
        final ios = await deviceInfo.iosInfo;
        buffer.writeln('DEVICE INFO:');
        buffer.writeln('  Model: ${ios.model}');
        buffer.writeln('  iOS: ${ios.systemVersion}');
        buffer.writeln('  Name: ${ios.name}');
        buffer.writeln();
      }
    } catch (e) {
      buffer.writeln('DEVICE INFO: Unable to retrieve');
      buffer.writeln();
    }

    // Log statistics
    final errorCount = _entries.where((e) => e.level == LogLevel.error).length;
    final warningCount = _entries.where((e) => e.level == LogLevel.warning).length;
    buffer.writeln('LOG SUMMARY:');
    buffer.writeln('  Total entries: ${_entries.length}');
    buffer.writeln('  Errors: $errorCount');
    buffer.writeln('  Warnings: $warningCount');
    buffer.writeln();

    buffer.writeln('═══════════════════════════════════════');

    // Prefer the on-disk log: it spans process restarts (e.g. an Android Auto
    // cold-start), so it includes sessions the in-memory buffer has already
    // lost. Falls back to the in-memory buffer if file logging is unavailable.
    final persisted = await getPersistedLogs();
    if (persisted.trim().isNotEmpty) {
      buffer.writeln('LOGS (persisted, oldest first, across sessions):');
      buffer.writeln('═══════════════════════════════════════');
      buffer.writeln();
      buffer.write(persisted);
    } else {
      buffer.writeln('LOGS (newest first):');
      buffer.writeln('═══════════════════════════════════════');
      buffer.writeln();
      for (final entry in _entries.reversed) {
        buffer.writeln(entry.formatted);
      }
    }

    return buffer.toString();
  }
}
