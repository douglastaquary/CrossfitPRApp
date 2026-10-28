#!/usr/bin/env bash
# Legado Xcode 14.2: converte pacote local (relativePath) em file URL absoluta do monorepo.
# Xcode 15+ e CI usam XCLocalSwiftPackageReference com relativePath "." (sem rodar este script).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PBX="$ROOT/CrossfitPR.xcodeproj/project.pbxproj"
FILE_URL="file://${ROOT}/"

python3 <<PY
from pathlib import Path
import re

pbx_path = Path("$PBX")
pbx = pbx_path.read_text()
file_url = "$FILE_URL"

local_pattern = re.compile(
    r"/\\* Begin XCLocalSwiftPackageReference section \\*/.*?/\\* End XCLocalSwiftPackageReference section \\*/",
    re.DOTALL,
)
remote_block = f'''/* Begin XCRemoteSwiftPackageReference section */
\t\t4E58062127F3C5B100F16219 /* XCRemoteSwiftPackageReference "CrossfitPRPackages" */ = {{
\t\t\tisa = XCRemoteSwiftPackageReference;
\t\t\trepositoryURL = "{file_url}";
\t\t\trequirement = {{
\t\t\t\tkind = branch;
\t\t\t\tbranch = main;
\t\t\t}};
\t\t}};
/* End XCRemoteSwiftPackageReference section */'''

if local_pattern.search(pbx):
    pbx = local_pattern.sub(remote_block, pbx, count=1)
    pbx = pbx.replace(
        "XCLocalSwiftPackageReference",
        "XCRemoteSwiftPackageReference",
    )
    print(f"Xcode 14: convertido para file URL → {file_url}")
else:
    pbx = re.sub(
        r'repositoryURL = "file://[^"]+";',
        f'repositoryURL = "{file_url}";',
        pbx,
        count=1,
    )
    print(f"Atualizado file URL → {file_url}")

pbx_path.write_text(pbx)
PY

echo "Abra o Xcode → File → Packages → Reset Package Caches → Resolve Package Versions"
