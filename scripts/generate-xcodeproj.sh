#!/usr/bin/env bash
# Regenera CrossfitPR.xcodeproj a partir de project.yml (fonte de verdade).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
SPEC="${ROOT}/project.yml"
XCODEGEN_VERSION="${XCODEGEN_VERSION:-2.46.0}"
CACHE_DIR="${ROOT}/.tools/xcodegen"

find_xcodegen() {
  if command -v xcodegen >/dev/null 2>&1; then
    command -v xcodegen
    return 0
  fi
  if [[ -x "$CACHE_DIR/bin/xcodegen" ]]; then
    echo "$CACHE_DIR/bin/xcodegen"
    return 0
  fi
  return 1
}

install_xcodegen_to_cache() {
  mkdir -p "$CACHE_DIR"
  local zip="/tmp/xcodegen-${XCODEGEN_VERSION}.zip"
  echo "→ Baixando XcodeGen ${XCODEGEN_VERSION} para .tools/ (Homebrew indisponível neste macOS)"
  curl -fsSL "https://github.com/yonaskolb/XcodeGen/releases/download/${XCODEGEN_VERSION}/xcodegen.zip" -o "$zip"
  rm -rf "$CACHE_DIR/xcodegen"
  unzip -q -o "$zip" -d "$CACHE_DIR"
  mv "$CACHE_DIR/xcodegen/bin/xcodegen" "$CACHE_DIR/bin-xcodegen"
  rm -rf "$CACHE_DIR/xcodegen"
  mkdir -p "$CACHE_DIR/bin"
  mv "$CACHE_DIR/bin-xcodegen" "$CACHE_DIR/bin/xcodegen"
  chmod +x "$CACHE_DIR/bin/xcodegen"
}

XCODEGEN="$(find_xcodegen)" || {
  install_xcodegen_to_cache
  XCODEGEN="$(find_xcodegen)"
}

echo "→ XcodeGen: $($XCODEGEN --version)"
echo "→ Gerando a partir de project.yml"
"$XCODEGEN" generate --spec "$SPEC"

echo ""
echo "Pronto: CrossfitPR.xcodeproj"
echo "  CI / push: commite project.yml + pbxproj (XCLocal relativePath .)"
echo "  Xcode 14.2 local: ./scripts/configure-spm-xcode14.sh antes de abrir (não commitar file URL)"
