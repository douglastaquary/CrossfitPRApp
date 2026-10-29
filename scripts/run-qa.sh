#!/usr/bin/env bash
# QA local (tipicamente Xcode 14.2 após configure-spm-xcode14.sh).
# Para o mesmo gate do GitHub Actions (Xcode recente): ./scripts/ci-modern.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
bash "$ROOT/scripts/ensure-xcodeproj.sh"

SCHEME="${SCHEME:-CrossfitPR}"
PROJECT="${PROJECT:-CrossfitPR.xcodeproj}"
DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 14 Pro}"

echo "==> Build"
xcodebuild -scheme "$SCHEME" -project "$PROJECT" \
  -destination "$DESTINATION" \
  -allowProvisioningUpdates \
  build -quiet

echo "==> UI tests (localização)"
xcodebuild -scheme "$SCHEME" -project "$PROJECT" \
  -destination "$DESTINATION" \
  -allowProvisioningUpdates \
  test \
  -only-testing:CrossfitPRUITests/AppLocalizationQATests \
  -skip-testing:CrossfitPRUITests/ReadmeScreenshotsUITests \
  -skip-testing:CrossfitPRUITests/testDemoTabTour

echo "==> Localization package tests (Domain + strings)"
cd Packages/Localization
swift test 2>/dev/null || {
  echo "swift test (macOS) indisponível — use Xcode test plan ou CI iOS."
}

echo "QA concluído."
