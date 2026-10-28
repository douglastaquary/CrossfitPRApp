#!/usr/bin/env bash
# Legado Xcode 14.2: converte pacote local (relativePath) em file URL absoluta do monorepo.
# Xcode 15+ e CI usam XCLocalSwiftPackageReference com relativePath "." (sem rodar este script).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PBX="$ROOT/CrossfitPR.xcodeproj/project.pbxproj"
FILE_URL="file://${ROOT}/"
SPM_BRANCH="$(git -C "$ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)"
SPM_REVISION="$(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo main)"

python3 <<PY
from pathlib import Path
import re

pbx_path = Path("$PBX")
pbx = pbx_path.read_text()
file_url = "$FILE_URL"
spm_revision = "$SPM_REVISION"

local_pattern = re.compile(
    r"/\\* Begin XCLocalSwiftPackageReference section \\*/.*?/\\* End XCLocalSwiftPackageReference section \\*/",
    re.DOTALL,
)
remote_block = f'''/* Begin XCRemoteSwiftPackageReference section */
\t\t4E58062127F3C5B100F16219 /* XCRemoteSwiftPackageReference "CrossfitPRPackages" */ = {{
\t\t\tisa = XCRemoteSwiftPackageReference;
\t\t\trepositoryURL = "{file_url}";
\t\t\trequirement = {{
\t\t\t\tkind = revision;
\t\t\t\trevision = {spm_revision};
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
    pbx = re.sub(
        r"requirement = \\{[^}]+\\};",
        f'''requirement = {{
\t\t\t\tkind = revision;
\t\t\t\trevision = {spm_revision};
\t\t\t}};''',
        pbx,
        count=1,
    )
    print(f"Atualizado file URL → {file_url} (revision {spm_revision[:8]})")

pbx_path.write_text(pbx)
PY

echo "Abra o Xcode → File → Packages → Reset Package Caches → Resolve Package Versions"
