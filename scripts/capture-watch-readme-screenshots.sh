#!/usr/bin/env bash
# Capturas README das telas watchOS (scheme CrossfitPRWatch).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
bash "$ROOT/scripts/ensure-xcodeproj.sh"
DOCS="$ROOT/docs/screenshots"
BUNDLE_ID="com.douglast.CrossfitPR.watchkitapp"
PICK_SCRIPT="${ROOT}/scripts/pick-watch-simulator.rb"

mkdir -p "$DOCS"
export WATCH_SIM_DEVICE="${WATCH_SIM_DEVICE:-Apple Watch Series 8 (41mm)}"
export WATCH_SIM_OS="${WATCH_SIM_OS:-9.0}"

WATCH_LINE="$(xcrun simctl list devices available -j | ruby "$PICK_SCRIPT")"
WATCH_UDID="${WATCH_LINE%%$'\t'*}"
WATCH_LABEL="${WATCH_LINE#*$'\t'}"
echo "→ Simulador: $WATCH_LABEL ($WATCH_UDID)"

echo "→ Build CrossfitPRWatch"
DEST="platform=watchOS Simulator,name=${WATCH_SIM_DEVICE},OS=${WATCH_SIM_OS}"
xcodebuild build \
  -scheme CrossfitPRWatch \
  -project "$ROOT/CrossfitPR.xcodeproj" \
  -destination "$DEST" \
  CODE_SIGNING_ALLOWED=NO

xcrun simctl boot "$WATCH_UDID" 2>/dev/null || true
xcrun simctl bootstatus "$WATCH_UDID" -b 2>/dev/null || true

APP_PATH="$(find "$HOME/Library/Developer/Xcode/DerivedData" -path "*Build/Products/Debug-watchsimulator/CrossfitPRWatch.app" -print -quit 2>/dev/null || true)"
if [[ -z "$APP_PATH" || ! -d "$APP_PATH" ]]; then
  echo "⚠️  CrossfitPRWatch.app não encontrado em DerivedData."
  exit 1
fi

xcrun simctl install "$WATCH_UDID" "$APP_PATH"

capture_tab() {
  local tab="$1"
  local outfile="$2"
  xcrun simctl terminate "$WATCH_UDID" "$BUNDLE_ID" 2>/dev/null || true
  sleep 0.5
  xcrun simctl launch "$WATCH_UDID" "$BUNDLE_ID" -WatchSnapshotTab "$tab" >/dev/null
  sleep 2.5
  xcrun simctl io "$WATCH_UDID" screenshot "$outfile"
  echo "   $outfile (tab $tab)"
}

capture_tab 0 "$DOCS/watch-session.png"
capture_tab 1 "$DOCS/watch-load.png"
capture_tab 2 "$DOCS/watch-rest.png"
capture_tab 3 "$DOCS/watch-breath.png"

echo "→ Capturas watch concluídas em $DOCS"
