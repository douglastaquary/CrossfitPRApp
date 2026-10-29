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

# Sem um Watch pareado, o destino só-iPhone não compila o companion. O embed
# cria PlugIns/CrossfitPRWatch.app vazio e o ValidateEmbeddedBinary falha com
# "Couldn't load Info dictionary".
pick_watch_line() {
  if [[ -n "${WATCH_UDID:-}" ]]; then
    echo -e "${WATCH_UDID}\t${WATCH_NAME:-Apple Watch}"
    return
  fi
  xcrun simctl list devices available -j | SIM_KIND=watchOS ruby "$PICK_SCRIPT"
}

set +e
WATCH_LINE="$(pick_watch_line)"
watch_pick_status=$?
set -e
if [[ "$watch_pick_status" -ne 0 ]]; then
  echo "==> Nenhum Apple Watch disponível; baixando runtime watchOS"
  xcodebuild -downloadPlatform watchOS
  WATCH_LINE="$(pick_watch_line)"
fi
WATCH_UDID="${WATCH_LINE%%$'\t'*}"
WATCH_LABEL="${WATCH_LINE#*$'\t'}"
echo "==> Watch: $WATCH_LABEL"
echo "    UDID: $WATCH_UDID"
WATCH_SIM_DEST="platform=watchOS Simulator,id=${WATCH_UDID}"
if [[ "$(uname -m)" == "arm64" && -z "${WATCH_DEST:-}" ]]; then
  WATCH_SIM_DEST="${WATCH_SIM_DEST},arch=arm64"
fi
echo "    destination: $WATCH_SIM_DEST"

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

echo "==> Boot simulator (UI tests) e parear Watch"
xcrun simctl boot "$SIM_UDID" 2>/dev/null || true
xcrun simctl bootstatus "$SIM_UDID" -b 2>/dev/null || true
xcrun simctl boot "$WATCH_UDID" 2>/dev/null || true
xcrun simctl pair "$WATCH_UDID" "$SIM_UDID" || true

BUILD_CONFIG="${BUILD_CONFIG:-Debug}"
# Sem conta Apple. Os dois lados ficam ad hoc ("-"), sem entitlements de
# iCloud/push: esse arquivo invalida a assinatura de simulador. Sem
# CodeSignOnCopy o Xcode 26.3 encolhe o executável em PlugIns/ e o
# ValidateEmbeddedBinary recusa o Watch mesmo com Info.plist válido.
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
    "CODE_SIGN_ENTITLEMENTS="
    COPY_PHASE_STRIP=NO
  )
fi
XCB=(xcodebuild -scheme "$SCHEME" -project "$PROJECT" -destination "$DEST" -configuration "$BUILD_CONFIG" -allowProvisioningUpdates ENABLE_DEBUG_DYLIB=NO)
if ((${#SIGNING_OVERRIDES[@]})); then
  XCB+=("${SIGNING_OVERRIDES[@]}")
fi
if ((${#ARCH_OVERRIDES[@]})); then
  XCB+=("${ARCH_OVERRIDES[@]}")
fi

echo "==> Resolve Package Graph"
"${XCB[@]}" -resolvePackageDependencies

dump_watch_app() {
  local app="$1"
  echo "-- $app"
  ls -la "$app" || true
  if [[ -f "$app/CrossfitPRWatch" ]]; then
    echo "   executable bytes: $(wc -c < "$app/CrossfitPRWatch" | tr -d ' ')"
    codesign -dv "$app" 2>&1 | head -20 || true
  fi
  if [[ -f "$app/Info.plist" ]]; then
    plutil -p "$app/Info.plist" || true
  else
    echo "   (sem Info.plist)"
  fi
}

echo "==> Build watchOS antes do embed ($BUILD_CONFIG)"
# -target, não o scheme: o scheme também sobe o app iOS e o embed vazio
# mascara o erro real do companion.
WATCH_XCB=(xcodebuild -target CrossfitPRWatch -project "$PROJECT" -destination "${WATCH_DEST:-$WATCH_SIM_DEST}" -configuration "$BUILD_CONFIG" -allowProvisioningUpdates ENABLE_DEBUG_DYLIB=NO)
if ((${#SIGNING_OVERRIDES[@]})); then
  WATCH_XCB+=("${SIGNING_OVERRIDES[@]}")
fi
if ((${#ARCH_OVERRIDES[@]})); then
  WATCH_XCB+=("${ARCH_OVERRIDES[@]}")
fi
"${WATCH_XCB[@]}" build

# Xcode 26 com arch=arm64 grava em Debug-watchsimulator-arm64, não em
# Debug-watchsimulator/. O -path '*Debug-watchsimulator/…' não achava o .app
# mesmo com BUILD SUCCEEDED.
WATCH_PRODUCT=""
WATCH_FALLBACK=""
WATCH_APPS=()
set +o pipefail
while IFS= read -r app; do
  [[ -n "$app" ]] || continue
  WATCH_APPS+=("$app")
  [[ -f "$app/Info.plist" ]] || continue
  case "$app" in
    *watchsimulator*) WATCH_PRODUCT="$app"; break ;;
  esac
  WATCH_FALLBACK="$app"
done < <(find "$HOME/Library/Developer/Xcode/DerivedData" "$ROOT/build" -name 'CrossfitPRWatch.app' -type d 2>/dev/null)
set -o pipefail
WATCH_PRODUCT="${WATCH_PRODUCT:-$WATCH_FALLBACK}"
if [[ -z "$WATCH_PRODUCT" ]]; then
  echo "ERROR: CrossfitPRWatch.app não saiu com Info.plist (watchsimulator)."
  if ((${#WATCH_APPS[@]})); then
    for app in "${WATCH_APPS[@]}"; do
      dump_watch_app "$app"
    done
  else
    echo "Nenhum CrossfitPRWatch.app em DerivedData nem em build/."
  fi
  exit 1
fi
echo "==> Watch product: $WATCH_PRODUCT"

# O scheme CrossfitPR só lista destinos iOS. Passar o simulador watchOS aqui
# faz o xcodebuild abortar ("Unable to find a destination"), mesmo com o
# companion já compilado via -target.
echo "==> Build iOS ($BUILD_CONFIG)"
mkdir -p "$ROOT/build"
set +e
"${XCB[@]}" build 2>&1 | tee "$ROOT/build/ios-build.log"
ios_status=${PIPESTATUS[0]}
set -e
if [[ "$ios_status" -ne 0 ]]; then
  echo "==> Erros do xcodebuild:"
  grep -E "error:|warning:.*[Ee]mbed|ValidateEmbeddedBinary|Embedded binary|Foundation extension|CodeSign" "$ROOT/build/ios-build.log" | tail -40 || true
  echo "==> Embed falhou; produtos CrossfitPRWatch.app:"
  set +o pipefail
  while IFS= read -r app; do
    dump_watch_app "$app"
  done < <(find "$HOME/Library/Developer/Xcode/DerivedData" -name 'CrossfitPRWatch.app' -type d 2>/dev/null)
  set -o pipefail
  exit "$ios_status"
fi

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
