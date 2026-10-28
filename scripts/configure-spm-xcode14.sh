#!/usr/bin/env bash
# Atualiza referência SPM local (file URL + revision) para Xcode 14.2 resolver o monorepo na raiz.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PBX="$ROOT/CrossfitPR.xcodeproj/project.pbxproj"
FILE_URL="file://${ROOT}/"

python3 <<PY
from pathlib import Path
import re
pbx = Path("$PBX").read_text()
file_url = "$FILE_URL"
pbx = re.sub(
    r'repositoryURL = "file://[^"]+";',
    f'repositoryURL = "{file_url}";',
    pbx,
    count=1,
)
Path("$PBX").write_text(pbx)
print(f"SPM file URL → {file_url}")
PY

echo "Abra o Xcode → File → Packages → Reset Package Caches → Resolve Package Versions"
