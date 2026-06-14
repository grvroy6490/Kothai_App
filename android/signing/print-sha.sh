#!/usr/bin/env bash
# Prints app debug/release SHA from Gradle and reminds about Play Console SHA.
set -e
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT/android"
echo "=== Visai signingReport (app module) ==="
./gradlew :app:signingReport 2>/dev/null | awk '
  /^Variant:/ { v=$0 }
  /^SHA1:/ { print v; print $0 }
  /^SHA-256:/ { print $0; print "" }
'
echo "=== Play Store ==="
echo "Copy App signing key SHA-1/256: play.google.com/console/developers/app/keymanagement"
echo "  (or Test and release → Setup → App signing)"
echo "Update: android/signing/sha_fingerprints.json → playStoreAppSigning"
echo "Doc:   android/signing/SHA_FINGERPRINTS.md"
