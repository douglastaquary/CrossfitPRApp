#!/usr/bin/env bash
# Regenera CrossfitPR.xcodeproj a partir de project.yml (fonte de verdade).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
SPEC="${ROOT}/project.yml"
XCODEGEN_VERSION="${XCODEGEN_VERSION:-2.46.0}"
CACHE_DIR="${ROOT}/.tools/xcodegen"

pinned_xcodegen_path() {
  echo "$CACHE_DIR/bin/xcodegen"
}

pinned_xcodegen_ready() {
  local bin
  bin="$(pinned_xcodegen_path)"
  [[ -x "$bin" ]] || return 1
  local ver
  ver="$("$bin" --version 2>/dev/null | awk '{print $NF}')"
  [[ "$ver" == "$XCODEGEN_VERSION" ]]
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

if ! pinned_xcodegen_ready; then
  install_xcodegen_to_cache
fi
XCODEGEN="$(pinned_xcodegen_path)"
if ! pinned_xcodegen_ready; then
  echo "ERROR: não foi possível instalar XcodeGen ${XCODEGEN_VERSION} em ${CACHE_DIR}"
  exit 1
fi

echo "→ XcodeGen: $($XCODEGEN --version) (${CACHE_DIR})"
echo "→ Gerando a partir de project.yml"
"$XCODEGEN" generate --spec "$SPEC"
bash "$ROOT/scripts/xcodegen-postgen.sh"

echo ""
echo "Pronto: CrossfitPR.xcodeproj"
echo "  CI / push: commite project.yml + pbxproj (XCLocal relativePath .)"
echo "  Xcode 14.2 local: ./scripts/configure-spm-xcode14.sh antes de abrir (não commitar file URL)"
