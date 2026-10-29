#!/usr/bin/env bash
# Ajustes pós-`xcodegen generate` — StoreKit só no scheme, não no bundle.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PBX="$ROOT/CrossfitPR.xcodeproj/project.pbxproj"
SCHEME="$ROOT/CrossfitPR.xcodeproj/xcshareddata/xcschemes/CrossfitPR.xcscheme"

if [[ ! -f "$PBX" ]]; then
  echo "xcodegen-postgen: project.pbxproj não encontrado"
  exit 1
fi

if ! grep -q 'objectVersion = 56;' "$PBX"; then
  echo "WARN: esperado objectVersion 56 (projectFormat xcode14_0) — verifique XcodeGen ≥ 2.45"
fi

python3 <<PY
from pathlib import Path
import re

pbx_path = Path("$PBX")
text = pbx_path.read_text()
hex_id = r"[A-Fa-f0-9]+"

text = re.sub(
    rf"\t\t{hex_id} /\\* Products\\.storekit in Resources \\*/ = {{isa = PBXBuildFile; fileRef = {hex_id} /\\* Products\\.storekit \\*/; }};\\n",
    "",
    text,
)
text = re.sub(
    rf"\t\t\t\t{hex_id} /\\* Products\\.storekit in Resources \\*/,\\n",
    "",
    text,
)

pbx_path.write_text(text)
print("xcodegen-postgen: OK (StoreKit fora de Copy Bundle Resources)")
PY

if [[ -f "$SCHEME" ]]; then
  python3 <<PY
from pathlib import Path
import re

scheme_path = Path("$SCHEME")
text = scheme_path.read_text()

def product_for_blueprint(name: str) -> str:
    if name.endswith("UITests"):
        return f"{name}.xctest"
    return f"{name}.app"

def fix_block(block: str) -> str:
    m = re.search(r'BlueprintName = "([^"]+)"', block)
    if not m:
        return block
    product = product_for_blueprint(m.group(1))
    return re.sub(r'BuildableName = "[^"]*"', f'BuildableName = "{product}"', block, count=1)

text = re.sub(
    r"<BuildableReference\\s[^>]*>.*?</BuildableReference>",
    lambda m: fix_block(m.group(0)),
    text,
    flags=re.DOTALL,
)
text = text.replace(
    'identifier = "../../Configuration/Products.storekit"',
    'identifier = "../Configuration/Products.storekit"',
)
scheme_path.write_text(text)
PY
fi
