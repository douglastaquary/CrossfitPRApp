#!/usr/bin/env bash
# Pipeline de build/test para Xcode 15+ (GitHub Actions e Macs com toolchain recente).
# Máquinas no Xcode 14.2: use ./scripts/configure-spm-xcode14.sh + build local; a validação “moderna” roda no CI.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SCHEME="${SCHEME:-CrossfitPR}"
PROJECT="${PROJECT:-CrossfitPR.xcodeproj}"
PICK_SCRIPT="${ROOT}/scripts/pick-ios-simulator.rb"

echo "==> Toolchain"
xcodebuild -version
xcrun swift --version

echo "==> XcodeGen (project.yml → CrossfitPR.xcodeproj)"
export XCODEGEN_VERSION="${XCODEGEN_VERSION:-2.46.0}"
export REGENERATE_XCODEPROJ=1
bash "$ROOT/scripts/generate-xcodeproj.sh"

echo "==> SPM (monorepo local — sem file URL absoluta no git)"
if grep -qE 'repositoryURL = "file:///Users/' "$PROJECT/project.pbxproj" 2>/dev/null; then
  echo "ERROR: project.pbxproj contém file URL absoluta (típico de configure-spm-xcode14.sh local)."
  echo "       Regenere limpo: REGENERATE_XCODEPROJ=1 ./scripts/generate-xcodeproj.sh (não commitar — xcodeproj está no .gitignore)."
  exit 1
fi
if ! grep -q 'isa = XCLocalSwiftPackageReference' "$PROJECT/project.pbxproj"; then
  echo "WARN: esperado XCLocalSwiftPackageReference no project.pbxproj"
fi

# Imprime "UDID<TAB>NAME" — destino xcodebuild usa id= (evita falha name + OS:latest no Xcode 26).
pick_simulator_line() {
  if [[ -n "${SIM_UDID:-}" ]]; then
    local name="${SIM_NAME:-iOS Simulator}"
    echo -e "${SIM_UDID}\t${name}"
    return
  fi
  export SIM_DEVICE="${SIM_DEVICE:-iPhone 17 Pro}"
  xcrun simctl list devices available -j | ruby "$PICK_SCRIPT"
}

SIM_LINE="$(pick_simulator_line)"
SIM_UDID="${SIM_LINE%%$'\t'*}"
SIM_LABEL="${SIM_LINE#*$'\t'}"
echo "==> Simulator: $SIM_LABEL"
echo "    UDID: $SIM_UDID"

if [[ -n "${SIM_DEST:-}" ]]; then
  DEST="$SIM_DEST"
else
  DEST="platform=iOS Simulator,id=${SIM_UDID}"
fi
echo "    destination: $DEST"

echo "==> Boot simulator (UI tests)"
xcrun simctl boot "$SIM_UDID" 2>/dev/null || true
xcrun simctl bootstatus "$SIM_UDID" -b 2>/dev/null || true

BUILD_CONFIG="${BUILD_CONFIG:-Debug}"
XCB=(xcodebuild -scheme "$SCHEME" -project "$PROJECT" -destination "$DEST" -configuration "$BUILD_CONFIG" -allowProvisioningUpdates)
if [[ "${CODE_SIGNING_ALLOWED:-YES}" == "NO" ]]; then
  XCB+=(CODE_SIGNING_ALLOWED=NO)
fi

echo "==> Resolve Package Graph"
"${XCB[@]}" -resolvePackageDependencies

echo "==> Build ($BUILD_CONFIG)"
"${XCB[@]}" build

echo "==> Build watchOS (CrossfitPRWatch embed)"
WATCH_DEST="${WATCH_DEST:-generic/platform=watchOS Simulator}"
WATCH_XCB=(xcodebuild -scheme "$SCHEME" -project "$PROJECT" -destination "$WATCH_DEST" -configuration "$BUILD_CONFIG" -allowProvisioningUpdates)
if [[ "${CODE_SIGNING_ALLOWED:-YES}" == "NO" ]]; then
  WATCH_XCB+=(CODE_SIGNING_ALLOWED=NO)
fi
"${WATCH_XCB[@]}" build

echo "==> UI tests (AppLocalizationQATests)"
"${XCB[@]}" test \
  -only-testing:CrossfitPRUITests/AppLocalizationQATests \
  -skip-testing:CrossfitPRUITests/ReadmeScreenshotsUITests \
  -skip-testing:CrossfitPRUITests/testDemoTabTour

echo "==> UI tests (PaymentFlowUITests)"
"${XCB[@]}" test \
  -only-testing:CrossfitPRUITests/PaymentFlowUITests \
  -skip-testing:CrossfitPRUITests/ReadmeScreenshotsUITests

echo "==> Unit tests — Localization (catálogo workout.*)"
(cd Packages/Localization && swift test)

echo "==> Unit tests — Domain"
(cd Packages/Domain && swift test)

echo "==> Unit tests — Subscription (PaymentFlow)"
(cd Packages/Subscription && swift test)

echo "CI moderno concluído com sucesso."
