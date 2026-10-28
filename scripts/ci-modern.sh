#!/usr/bin/env bash
# Pipeline de build/test para Xcode 15+ (GitHub Actions e Macs com toolchain recente).
# Máquinas no Xcode 14.2: use ./scripts/configure-spm-xcode14.sh + build local; a validação “moderna” roda no CI.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SCHEME="${SCHEME:-CrossfitPR}"
PROJECT="${PROJECT:-CrossfitPR.xcodeproj}"

echo "==> Toolchain"
xcodebuild -version
xcrun swift --version

echo "==> SPM (monorepo local — sem file URL absoluta no git)"
if grep -qE 'repositoryURL = "file:///Users/' "$PROJECT/project.pbxproj" 2>/dev/null; then
  echo "ERROR: project.pbxproj contém file URL absoluta (típico de configure-spm-xcode14.sh local)."
  echo "       No CI use XCLocalSwiftPackageReference (relativePath = .). Reverta o pbxproj antes do push."
  exit 1
fi
if ! grep -q 'isa = XCLocalSwiftPackageReference' "$PROJECT/project.pbxproj"; then
  echo "WARN: esperado XCLocalSwiftPackageReference no project.pbxproj"
fi

pick_simulator() {
  if [[ -n "${SIM_NAME:-}" ]]; then
    echo "$SIM_NAME"
    return
  fi
  xcrun simctl list devices available -j | ruby -e "
    require 'json'
    devs = JSON.parse(STDIN.read)['devices'].values.flatten.select { |d| d['isAvailable'] }
    order = [
      /iPhone 16 Pro$/,
      /iPhone 16$/,
      /iPhone 16e$/,
      /iPhone 15 Pro$/,
      /iPhone 15$/,
      /iPhone 14 Pro$/,
      /iPhone/
    ]
    order.each do |pat|
      hit = devs.find { |d| d['name'] =~ pat }
      if hit
        puts hit['name']
        exit 0
      end
    end
    puts 'iPhone 15'
  "
}

SIM="$(pick_simulator)"
echo "==> Simulator: $SIM"
DEST="platform=iOS Simulator,name=${SIM}"

XCB=(xcodebuild -scheme "$SCHEME" -project "$PROJECT" -destination "$DEST" -allowProvisioningUpdates)
if [[ "${CODE_SIGNING_ALLOWED:-YES}" == "NO" ]]; then
  XCB+=(CODE_SIGNING_ALLOWED=NO)
fi

echo "==> Build"
"${XCB[@]}" build

echo "==> UI tests (AppLocalizationQATests)"
"${XCB[@]}" test \
  -only-testing:CrossfitPRUITests/AppLocalizationQATests \
  -skip-testing:CrossfitPRUITests/ReadmeScreenshotsUITests \
  -skip-testing:CrossfitPRUITests/testDemoTabTour

echo "==> Unit tests — Localization (catálogo workout.*)"
(cd Packages/Localization && swift test)

echo "==> Unit tests — Domain"
(cd Packages/Domain && swift test)

echo "CI moderno concluído com sucesso."
