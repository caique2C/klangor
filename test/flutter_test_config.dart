import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:sqlite3/open.dart';

/// Ubuntu/Debian dev machines commonly ship only the versioned
/// `libsqlite3.so.0` (from `libsqlite3-0`), not the unversioned `.so` symlink
/// that `libsqlite3-dev` would add and that dart:ffi's default resolver looks
/// for. Rather than requiring every contributor/CI box to install the -dev
/// package, fall back to the versioned library so `flutter test` works out
/// of the box for drift's NativeDatabase.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  if (Platform.isLinux) {
    open.overrideFor(OperatingSystem.linux, () {
      for (final candidate in [
        'libsqlite3.so',
        'libsqlite3.so.0',
        '/usr/lib/x86_64-linux-gnu/libsqlite3.so.0',
        '/lib/x86_64-linux-gnu/libsqlite3.so.0',
      ]) {
        try {
          return DynamicLibrary.open(candidate);
        } catch (_) {
          // Try the next candidate.
        }
      }
      throw StateError('Could not locate a usable libsqlite3 for tests');
    });
  }

  await testMain();
}
