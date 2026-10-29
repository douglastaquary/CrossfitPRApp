#!/usr/bin/env bash
# Regenera CrossfitPR.xcodeproj a partir de project.yml (fonte de verdade).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
SOURCE_SPEC="${ROOT}/project.yml"
SPEC="${SOURCE_SPEC}"
SPEC_TMP=""
XCODEGEN_VERSION="${XCODEGEN_VERSION:-2.46.0}"

# GitHub Actions (Xcode 26): projectFormat moderno — SPM injeta -I/-F no SwiftDriver.
# Local Xcode 14.2: mantém xcode14_0 do project.yml (objectVersion 56).
if [[ "${GITHUB_ACTIONS:-}" == "true" ]]; then
  SPEC_TMP="$(mktemp -t crossfitpr-project.XXXXXX.yml)"
  sed \
    -e 's/projectFormat: xcode14_0/projectFormat: xcode16_0/' \
    -e 's/xcodeVersion: "14.2"/xcodeVersion: "16.0"/' \
    "$SOURCE_SPEC" > "$SPEC_TMP"
  SPEC="$SPEC_TMP"
  echo "→ CI: projectFormat xcode16_0 (SPM compatível com Xcode recente)"
fi

cleanup() {
  [[ -n "$SPEC_TMP" && -f "$SPEC_TMP" ]] && rm -f "$SPEC_TMP"
}
trap cleanup EXIT
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
echo "→ Gerando a partir de ${SPEC##*/}"
# --project-root: spec em /tmp (CI) ainda resolve CrossfitPR/, Packages/, etc. na raiz do repo.
"$XCODEGEN" generate --spec "$SPEC" --project-root "$ROOT" --project "$ROOT"
bash "$ROOT/scripts/xcodegen-postgen.sh"

echo ""
echo "Pronto: CrossfitPR.xcodeproj (local/CI — não versionado; fonte: project.yml)"
echo "  Xcode 14.2: ./scripts/configure-spm-xcode14.sh após gerar (file URL só na máquina)"
