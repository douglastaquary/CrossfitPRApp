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

if grep -q 'objectVersion = 56;' "$PBX"; then
  echo "xcodegen-postgen: projectFormat xcode14_0 (local Xcode 14.2)"
elif grep -qE 'objectVersion = (60|77);' "$PBX"; then
  echo "xcodegen-postgen: projectFormat moderno (CI / Xcode 15+)"
else
  echo "WARN: objectVersion inesperado no pbxproj"
fi

export PBX_PATH="$PBX"
python3 <<'PY'
from pathlib import Path
import re
import os

pbx_path = Path(os.environ["PBX_PATH"])
text = pbx_path.read_text()
hex_id = r"[A-Fa-f0-9]+"

# XcodeGen + projectFormat xcode14_0 omite package= em XCSwiftPackageProductDependency (quebra link SPM no Xcode 15+).
pkg = re.search(rf"\t\t({hex_id}) /\* XCLocalSwiftPackageReference", text)
if pkg:
    pkg_id = pkg.group(1)
    section = "Begin XCSwiftPackageProductDependency"
    if section in text and "package = " not in text[text.index(section) :]:
        needle = (
            "\t\t\tisa = XCSwiftPackageProductDependency;\n"
            "\t\t\tproductName = "
        )
        insert = (
            "\t\t\tisa = XCSwiftPackageProductDependency;\n"
            f"\t\t\tpackage = {pkg_id} /* XCLocalSwiftPackageReference \".\" */;\n"
            "\t\t\tproductName = "
        )
        if needle not in text:
            raise SystemExit("xcodegen-postgen: bloco XCSwiftPackageProductDependency inesperado")
        text = text.replace(needle, insert)

spm_begin = text.find("Begin XCSwiftPackageProductDependency")
if spm_begin == -1 or "package = " not in text[spm_begin:]:
    raise SystemExit("xcodegen-postgen: falha ao ligar produtos SPM ao pacote local")

text = re.sub(
    rf"\t\t{hex_id} /\* Products\.storekit in Resources \*/ = {{isa = PBXBuildFile; fileRef = {hex_id} /\* Products\.storekit \*/; }};\n",
    "",
    text,
)
text = re.sub(
    rf"\t\t\t\t{hex_id} /\* Products\.storekit in Resources \*/,\n",
    "",
    text,
)

# Referência espúria path = . no grupo Packages (conflita com monorepo SPM na raiz).
text = re.sub(
    rf"\t\t{hex_id} /\\* CrossfitPR \\*/ = {{isa = PBXFileReference; lastKnownFileType = folder; name = CrossfitPR; path = \\.; sourceTree = SOURCE_ROOT; }};\\n",
    "",
    text,
)
text = re.sub(
    rf"\t\t\t\t{hex_id} /\\* CrossfitPR \\*/,\\n",
    "",
    text,
)

pbx_path.write_text(text)
print("xcodegen-postgen: OK (SPM package links + StoreKit/scheme)")
PY

if [[ -f "$SCHEME" ]]; then
  export SCHEME_PATH="$SCHEME"
  python3 <<'PY'
from pathlib import Path
import re
import os

scheme_path = Path(os.environ["SCHEME_PATH"])
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
