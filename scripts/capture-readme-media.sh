#!/usr/bin/env bash
# Captura manual (legado). Preferir: ./scripts/capture-readme-media-auto.sh
# Galeria canônica: docs/screenshots/review/{free,pro,elite}/
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "Use a captura automática (UITests + mocks cheios):"
echo "  ./scripts/capture-readme-media-auto.sh"
echo ""
echo "Ou só a galeria de tiers:"
echo "  export CROSSFITPR_DOCS_ROOT=\"$ROOT/docs\""
echo "  xcodebuild test -scheme CrossfitPR -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \\"
echo "    -only-testing:CrossfitPRUITests/ReadmeScreenshotsUITests/testCaptureTierScreenGallery"
exit 0
