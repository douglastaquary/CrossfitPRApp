#!/usr/bin/env bash
# Garante CrossfitPR.xcodeproj presente (gerado a partir de project.yml — não versionado no git).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PBX="$ROOT/CrossfitPR.xcodeproj/project.pbxproj"

if [[ ! -f "$PBX" ]]; then
  echo "→ CrossfitPR.xcodeproj não encontrado — gerando com XcodeGen…"
  bash "$ROOT/scripts/generate-xcodeproj.sh"
  exit 0
fi

if [[ "${REGENERATE_XCODEPROJ:-}" == "1" ]]; then
  bash "$ROOT/scripts/generate-xcodeproj.sh"
fi
