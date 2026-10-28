#!/usr/bin/env bash
# Captura automática de screenshots + GIF para o README (UI Tests + simctl).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [[ -z "${SIM_UDID:-}" ]]; then
  SIM_LINE="$(xcrun simctl list devices available -j | ruby "$ROOT/scripts/pick-ios-simulator.rb")"
  UDID="${SIM_LINE%%$'\t'*}"
  echo "→ Simulador: ${SIM_LINE#*$'\t'}"
else
  UDID="$SIM_UDID"
fi
BUNDLE_ID="com.douglast.CrossfitPR"
DOCS="$ROOT/docs"
VIDEO="$DOCS/media/crossfitpr-demo.mov"
GIF="$DOCS/media/crossfitpr-demo.gif"
DEST="platform=iOS Simulator,id=$UDID"

mkdir -p "$DOCS/screenshots" "$DOCS/media"

echo "→ Boot simulador $UDID"
xcrun simctl boot "$UDID" 2>/dev/null || true
open -a Simulator
sleep 3

echo "→ Limpa app (onboarding fresco nos testes)"
xcrun simctl uninstall booted "$BUNDLE_ID" 2>/dev/null || true

export CROSSFITPR_DOCS_ROOT="$DOCS"

echo "→ UI Test: screenshots"
xcodebuild test \
  -scheme CrossfitPR \
  -project "$ROOT/CrossfitPR.xcodeproj" \
  -destination "$DEST" \
  -allowProvisioningUpdates \
  -only-testing:CrossfitPRUITests/ReadmeScreenshotsUITests/testCaptureReadmeScreenshots \
  -only-testing:CrossfitPRUITests/ReadmeScreenshotsUITests/testCaptureInsightsProAndElite \
  -only-testing:CrossfitPRUITests/ReadmeScreenshotsUITests/testCaptureWatchPOCScreens \
  2>&1 | xcbeautify 2>/dev/null || xcodebuild test \
  -scheme CrossfitPR \
  -project "$ROOT/CrossfitPR.xcodeproj" \
  -destination "$DEST" \
  -allowProvisioningUpdates \
  -only-testing:CrossfitPRUITests/ReadmeScreenshotsUITests/testCaptureReadmeScreenshots \
  -only-testing:CrossfitPRUITests/ReadmeScreenshotsUITests/testCaptureInsightsProAndElite \
  -only-testing:CrossfitPRUITests/ReadmeScreenshotsUITests/testCaptureWatchPOCScreens

xcrun simctl uninstall booted "$BUNDLE_ID" 2>/dev/null || true

echo "→ Grava vídeo + tour de tabs"
( xcrun simctl io booted recordVideo "$VIDEO" --force ) &
REC_PID=$!
sleep 2

xcodebuild test \
  -scheme CrossfitPR \
  -project "$ROOT/CrossfitPR.xcodeproj" \
  -destination "$DEST" \
  -allowProvisioningUpdates \
  -only-testing:CrossfitPRUITests/ReadmeScreenshotsUITests/testDemoTabTour \
  2>&1 | tail -5

sleep 2
kill -INT "$REC_PID" 2>/dev/null || true
wait "$REC_PID" 2>/dev/null || true

if command -v ffmpeg >/dev/null 2>&1; then
  echo "→ GIF"
  ffmpeg -y -i "$VIDEO" \
    -vf "fps=8,scale=390:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    -loop 0 "$GIF"
  echo "   $GIF"
elif command -v convert >/dev/null 2>&1; then
  echo "→ GIF (ImageMagick a partir dos PNGs)"
  convert -delay 25 -loop 0 \
    "$DOCS/screenshots/onboarding.png" \
    "$DOCS/screenshots/categories.png" \
    "$DOCS/screenshots/insights-free.png" \
    "$DOCS/screenshots/insights-pro.png" \
    "$DOCS/screenshots/insights-elite.png" \
    "$DOCS/screenshots/pro-upgrade.png" \
    "$DOCS/screenshots/watch-session.png" \
    "$DOCS/screenshots/watch-rest.png" \
    "$DOCS/screenshots/settings.png" \
    -resize 390x \
    "$GIF"
  echo "   $GIF"
else
  echo "⚠️  Instale ffmpeg ou ImageMagick; mov em $VIDEO"
fi

echo ""
echo "Screenshots:"
ls -la "$DOCS/screenshots/"*.png 2>/dev/null || true
