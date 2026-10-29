#!/usr/bin/env bash
# Falha se project.pbxproj não bate com project.yml (rode generate-xcodeproj.sh).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
PBX="$ROOT/CrossfitPR.xcodeproj/project.pbxproj"
TMP="$(mktemp -d)"

cp "$PBX" "$TMP/before.pbxproj"
bash "$ROOT/scripts/generate-xcodeproj.sh" >/dev/null

if diff -q "$TMP/before.pbxproj" "$PBX" >/dev/null; then
  echo "verify-xcodeproj: project.pbxproj em sync com project.yml"
  rm -rf "$TMP"
  exit 0
fi

echo "ERROR: project.pbxproj desatualizado — rode ./scripts/generate-xcodeproj.sh e commite."
diff -u "$TMP/before.pbxproj" "$PBX" | head -60 || true
rm -rf "$TMP"
exit 1
