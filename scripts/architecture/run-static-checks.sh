#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

REPORT="${ARCHITECTURE_REPORT:-$ROOT/architecture-report.md}"
rm -f "$REPORT" "${ROOT}/architecture-report.partial.md"
: > "$REPORT"

echo "# Architecture static report" >> "$REPORT"
echo "" >> "$REPORT"
echo "Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> "$REPORT"
echo "" >> "$REPORT"

export ARCHITECTURE_REPORT="$REPORT"

ruby scripts/architecture/check-spm-graph.rb
bash scripts/architecture/check-mv-conventions.sh

if command -v swiftlint >/dev/null 2>&1; then
  echo "" >> "$REPORT"
  echo "## SwiftLint" >> "$REPORT"
  echo '```' >> "$REPORT"
  swiftlint lint --config "$ROOT/.swiftlint.yml" 2>&1 | tee -a "$REPORT" || true
  echo '```' >> "$REPORT"
else
  echo "" >> "$REPORT"
  echo "## SwiftLint" >> "$REPORT"
  echo "- swiftlint não instalado neste runner (skip)." >> "$REPORT"
fi

cat "$REPORT"
