#!/usr/bin/env bash
# Capturas README das telas watchOS (target CrossfitPRWatch) — rode após build no simulador Watch.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCS="$ROOT/docs/screenshots"
BUNDLE_ID="com.douglast.CrossfitPR.watchkitapp"
WATCH_NAME="${WATCH_SIM_NAME:-Apple Watch Series 8 (45mm)}"

mkdir -p "$DOCS"

echo "→ Build CrossfitPR + Watch (simulador Watch)"
xcodebuild build \
  -scheme CrossfitPR \
  -project "$ROOT/CrossfitPR.xcodeproj" \
  -destination "platform=watchOS Simulator,name=$WATCH_NAME" \
  -allowProvisioningUpdates \
  CODE_SIGNING_ALLOWED=NO

WATCH_UDID="$(xcrun simctl list devices available -j | ruby -e "
require 'json'
name = ARGV[0]
JSON.parse(STDIN.read)['devices'].each_value do |list|
  list.each do |d|
    next unless d['name'] == name && d['isAvailable']
    puts d['udid']
    exit
  end
end
" "$WATCH_NAME")"

if [[ -z "$WATCH_UDID" ]]; then
  echo "⚠️  Simulador Watch não encontrado: $WATCH_NAME"
  echo "    Liste: xcrun simctl list devices available | grep Watch"
  exit 1
fi

xcrun simctl boot "$WATCH_UDID" 2>/dev/null || true

APP_PATH="$(find "$HOME/Library/Developer/Xcode/DerivedData" -path "*Build/Products/Debug-watchsimulator/CrossfitPRWatch.app" -print -quit 2>/dev/null || true)"
if [[ -z "$APP_PATH" || ! -d "$APP_PATH" ]]; then
  echo "⚠️  CrossfitPRWatch.app não encontrado em DerivedData — abra o Xcode e faça build do scheme CrossfitPR."
  exit 1
fi

xcrun simctl install "$WATCH_UDID" "$APP_PATH"
xcrun simctl launch "$WATCH_UDID" "$BUNDLE_ID" || true
sleep 3

xcrun simctl io "$WATCH_UDID" screenshot "$DOCS/watch-session.png"
echo "   $DOCS/watch-session.png (tab Sessão — troque tabs manualmente ou estenda o script)"

echo "→ Para rest/breath: navegue no simulador e rode:"
echo "   xcrun simctl io $WATCH_UDID screenshot $DOCS/watch-rest.png"
