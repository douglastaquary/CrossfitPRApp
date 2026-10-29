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
  # arch= no destino fixa o slice ativo. Sem isto o Xcode 26 no runner arm64
  # ainda agenda compile x86_64 (GeneratedAssetSymbols) contra módulos SPM arm64.
  if [[ "$(uname -m)" == "arm64" ]]; then
    DEST="${DEST},arch=arm64"
  fi
fi
echo "    destination: $DEST"

# macos-15 é arm64. ARCHS do iphonesimulator inclui x86_64; os produtos SPM
# (Application, etc.) só emitem a arch do host. O app então falha com:
# could not find module 'Application' for target 'x86_64-apple-ios-simulator'.
# Não vai para project.yml: a máquina local de dev é Intel (simulador x86_64).
ARCH_OVERRIDES=()
if [[ "$(uname -m)" == "arm64" ]]; then
  ARCH_OVERRIDES+=(
    ONLY_ACTIVE_ARCH=YES
    ARCHS=arm64
    "EXCLUDED_ARCHS[sdk=iphonesimulator*]=x86_64"
    "EXCLUDED_ARCHS[sdk=watchsimulator*]=x86_64"
  )
fi

echo "==> Boot simulator (UI tests)"
xcrun simctl boot "$SIM_UDID" 2>/dev/null || true
xcrun simctl bootstatus "$SIM_UDID" -b 2>/dev/null || true

BUILD_CONFIG="${BUILD_CONFIG:-Debug}"
# CODE_SIGNING_ALLOWED=NO no workflow significa "sem conta Apple". No Xcode 26
# isso não pode ir literal para o xcodebuild: o app sai ad hoc ("-") e o
# Watch em PlugIns/ fica sem assinatura. ValidateEmbeddedBinary e
# RegisterExecutionPolicyException falham. Ad hoc igual nos dois, sem team.
SIGNING_OVERRIDES=()
if [[ "${CODE_SIGNING_ALLOWED:-YES}" == "NO" ]]; then
  SIGNING_OVERRIDES+=(
    CODE_SIGN_STYLE=Manual
    "DEVELOPMENT_TEAM="
    "CODE_SIGN_IDENTITY=-"
    CODE_SIGNING_ALLOWED=YES
    CODE_SIGNING_REQUIRED=NO
    AD_HOC_CODE_SIGNING_ALLOWED=YES
    "PROVISIONING_PROFILE_SPECIFIER="
  )
fi
XCB=(xcodebuild -scheme "$SCHEME" -project "$PROJECT" -destination "$DEST" -configuration "$BUILD_CONFIG" -allowProvisioningUpdates)
if ((${#SIGNING_OVERRIDES[@]})); then
  XCB+=("${SIGNING_OVERRIDES[@]}")
fi
if ((${#ARCH_OVERRIDES[@]})); then
  XCB+=("${ARCH_OVERRIDES[@]}")
fi

echo "==> Resolve Package Graph"
"${XCB[@]}" -resolvePackageDependencies

echo "==> Build ($BUILD_CONFIG)"
"${XCB[@]}" build

echo "==> Build watchOS (CrossfitPRWatch embed)"
WATCH_DEST="${WATCH_DEST:-generic/platform=watchOS Simulator}"
WATCH_XCB=(xcodebuild -scheme "$SCHEME" -project "$PROJECT" -destination "$WATCH_DEST" -configuration "$BUILD_CONFIG" -allowProvisioningUpdates)
if ((${#SIGNING_OVERRIDES[@]})); then
  WATCH_XCB+=("${SIGNING_OVERRIDES[@]}")
fi
if ((${#ARCH_OVERRIDES[@]})); then
  WATCH_XCB+=("${ARCH_OVERRIDES[@]}")
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
