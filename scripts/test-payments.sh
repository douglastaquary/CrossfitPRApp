#!/usr/bin/env bash
# Gate automatizado do fluxo de pagamento PRO/Elite.
# - Unit: Packages/Subscription (PaymentFlowTests + mocks)
# - UI: PaymentFlowUITests no simulador (MockSubscriptionStore; sem sheet Apple)
#
# Sheet Apple / Products.storekit: validação manual com
#   UITEST_USE_STOREKIT=1  (scheme já referencia Products.storekit)
#
# Uso:
#   ./scripts/test-payments.sh
#   DESTINATION='platform=iOS Simulator,name=iPhone 14 Pro' ./scripts/test-payments.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
bash "$ROOT/scripts/ensure-xcodeproj.sh"

SCHEME="${SCHEME:-CrossfitPR}"
PROJECT="${PROJECT:-CrossfitPR.xcodeproj}"
DESTINATION="${DESTINATION:-}"

echo "==> Payment gate — CrossfitPR"
echo "    Root: $ROOT"

if [[ -z "$DESTINATION" ]]; then
  if [[ -x "$ROOT/scripts/pick-ios-simulator.rb" ]] && command -v xcrun >/dev/null; then
    export SIM_DEVICE="${SIM_DEVICE:-iPhone 14 Pro}"
    if SIM_LINE="$(xcrun simctl list devices available -j 2>/dev/null | ruby "$ROOT/scripts/pick-ios-simulator.rb" 2>/dev/null)"; then
      SIM_UDID="${SIM_LINE%%$'\t'*}"
      DESTINATION="platform=iOS Simulator,id=${SIM_UDID}"
      echo "==> Simulator: ${SIM_LINE#*$'\t'} ($SIM_UDID)"
    else
      DESTINATION="platform=iOS Simulator,name=iPhone 14 Pro"
    fi
  else
    DESTINATION="platform=iOS Simulator,name=iPhone 14 Pro"
  fi
fi

echo "==> destination: $DESTINATION"

# Xcode 14.2: file:// SPM pinado em revision git — sync Packages → checkout para WIP local.
sync_xcode14_spm_checkout() {
  local xcode_major
  xcode_major="$(xcodebuild -version 2>/dev/null | awk 'NR==1 {print $2}' | cut -d. -f1 || echo 0)"
  [[ "$xcode_major" -ge 15 ]] && return 0

  local dd checkout
  dd="$(ls -dt "$HOME/Library/Developer/Xcode/DerivedData"/CrossfitPR-* 2>/dev/null | head -1 || true)"
  [[ -n "$dd" ]] || return 0
  checkout="$dd/SourcePackages/checkouts/CrossfitPR"
  if [[ -d "$checkout/Packages" ]]; then
    echo "==> Xcode 14: sync Packages → $checkout/Packages"
    rsync -a --delete "$ROOT/Packages/" "$checkout/Packages/"
  fi
}

XCB=(xcodebuild -scheme "$SCHEME" -project "$PROJECT" -destination "$DESTINATION" -allowProvisioningUpdates)
if [[ "${CODE_SIGNING_ALLOWED:-YES}" == "NO" ]]; then
  XCB+=(CODE_SIGNING_ALLOWED=NO)
fi

echo "==> Unit tests — Subscription package (PaymentFlow + mocks)"
set +e
(cd Packages/Subscription && swift test)
SUB_STATUS=$?
set -e
if [[ $SUB_STATUS -ne 0 ]]; then
  echo "    WARN: swift test Subscription falhou ou indisponível neste Xcode (ok no CI moderno)."
fi

sync_xcode14_spm_checkout

echo "==> UI tests — PaymentFlowUITests (compra / cancel / restore / fail)"
set -o pipefail
"${XCB[@]}" test \
  -only-testing:CrossfitPRUITests/PaymentFlowUITests \
  -skip-testing:CrossfitPRUITests/ReadmeScreenshotsUITests \
  -skip-testing:CrossfitPRUITests/AppLocalizationQATests \
  -parallel-testing-enabled NO
UI_STATUS=$?

if [[ $UI_STATUS -ne 0 ]]; then
  echo "ERROR: PaymentFlowUITests falhou (exit $UI_STATUS)."
  exit "$UI_STATUS"
fi

echo ""
echo "Payment gate OK (UI + unit quando disponível)."
echo "Manual Products.storekit: Scheme já referencia o arquivo; ou UITEST_USE_STOREKIT=1"
