#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APK_PATH="$ROOT_DIR/build/app/outputs/flutter-apk/app-release.apk"

echo "Working in $ROOT_DIR"

echo "Cleaning previous build artifacts..."
flutter clean

echo "Resolving dependencies..."
flutter pub get

echo "Building release APK..."
flutter build apk --release

if [ ! -f "$APK_PATH" ]; then
  echo "ERROR: APK not found at $APK_PATH" >&2
  exit 1
fi

echo "Checking APK for libapp.so..."
if python3 - "$APK_PATH" <<'PY'
import sys, zipfile
apk = sys.argv[1]
with zipfile.ZipFile(apk) as z:
    names = z.namelist()
    for n in names:
        if n.endswith('libapp.so'):
            sys.exit(0)
    # not found; print native libs for debugging
    for n in names:
        if n.startswith('lib/') and n.endswith('.so'):
            print(n)
    sys.exit(2)
PY
then
  echo "OK: libapp.so found in $APK_PATH"
else
  echo "ERROR: libapp.so missing in $APK_PATH" >&2
  exit 2
fi

if [ "${1-}" = "--install" ]; then
  echo "Installing APK to connected device..."
  adb install -r "$APK_PATH"
  echo "Launching app via monkey to verify startup..."
  # Attempt to derive package name from AndroidManifest
  PKG=$(unzip -p "$APK_PATH" AndroidManifest.xml | grep -oP 'package="\K[^"]+' | head -1 || true)
  if [ -n "$PKG" ]; then
    adb shell monkey -p "$PKG" 1
  else
    echo "WARNING: Could not determine package name from AndroidManifest.xml" >&2
  fi
fi

echo "Build and verification completed successfully."
