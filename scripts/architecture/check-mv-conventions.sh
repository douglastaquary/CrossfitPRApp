#!/usr/bin/env bash
# Heurísticas MV / camadas (advisory por default).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
REPORT="${ARCHITECTURE_REPORT:-$ROOT/architecture-report.partial.md}"

append() {
  echo "$1" >> "$REPORT"
}

if [[ ! -f "$REPORT" ]]; then
  echo "## MV conventions check" >> "$REPORT"
  echo "" >> "$REPORT"
fi

append "### MV / layer conventions"
FINDINGS=0

while IFS= read -r line; do
  append "- $line"
  FINDINGS=$((FINDINGS + 1))
done < <(rg -n '(class|struct|actor)\s+\w*ViewModel\b' "$ROOT/Packages" "$ROOT/CrossfitPR" 2>/dev/null || true)

while IFS= read -r line; do
  append "- [domain] SwiftUI import: $line"
  FINDINGS=$((FINDINGS + 1))
done < <(rg -l 'import SwiftUI' "$ROOT/Packages/Domain" 2>/dev/null || true)

# Feature packages must not import Persistence directly
FEATURE_DIRS=(
  "Packages/Categories"
  "Packages/PRHistory"
  "Packages/Insights"
  "Packages/Settings"
  "Packages/Launch"
  "Packages/Onboarding"
  "Packages/RecordDetail"
)
for dir in "${FEATURE_DIRS[@]}"; do
  [[ -d "$ROOT/$dir" ]] || continue
  while IFS= read -r line; do
    append "- [import] Persistence em feature: $line"
    FINDINGS=$((FINDINGS + 1))
  done < <(rg -n 'import Persistence' "$ROOT/$dir" 2>/dev/null || true)
done

while IFS= read -r line; do
  append "- [wiring] AppEnvironment.make fora do app: $line"
  FINDINGS=$((FINDINGS + 1))
done < <(rg -n 'AppEnvironment\.make\s*\(' "$ROOT/Packages" 2>/dev/null || true)

if [[ "$FINDINGS" -eq 0 ]]; then
  append "- Nenhuma violação heurística."
fi

if [[ "$FINDINGS" -gt 0 && "${STRICT:-0}" == "1" ]]; then
  exit 1
fi

exit 0
