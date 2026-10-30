#!/usr/bin/env bash
# Captura screenshots e GIF para o README (docs/screenshots + docs/media).
# Requer: Xcode, Simulator bootado, ffmpeg (opcional, para GIF a partir do vídeo).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
bash "$ROOT/scripts/ensure-xcodeproj.sh"
BUNDLE_ID="com.douglast.CrossfitPR"
SIM_NAME="${SIM_NAME:-iPhone 14 Pro}"
DOCS_SCREEN="$ROOT/docs/screenshots"
DOCS_MEDIA="$ROOT/docs/media"
VIDEO="$DOCS_MEDIA/crossfitpr-demo.mov"
GIF="$DOCS_MEDIA/crossfitpr-demo.gif"

mkdir -p "$DOCS_SCREEN" "$DOCS_MEDIA"

UDID="$(xcrun simctl list devices available | grep "$SIM_NAME (" | head -1 | sed -E 's/.*\(([A-F0-9-]+)\).*/\1/')"
if [[ -z "$UDID" ]]; then
  echo "Simulador não encontrado: $SIM_NAME"
  exit 1
fi

echo "→ Boot $SIM_NAME ($UDID)"
xcrun simctl boot "$UDID" 2>/dev/null || true
open -a Simulator

echo "→ Build"
xcodebuild -scheme CrossfitPR -project "$ROOT/CrossfitPR.xcodeproj" \
  -destination "platform=iOS Simulator,id=$UDID" \
  -quiet build

APP="$(find ~/Library/Developer/Xcode/DerivedData/CrossfitPR-*/Build/Products/Debug-iphonesimulator -name CrossfitPR.app -type d 2>/dev/null | head -1)"
if [[ -z "$APP" ]]; then
  echo "CrossfitPR.app não encontrado em DerivedData. Rode o build no Xcode uma vez."
  exit 1
fi

echo "→ Reinstalar app (onboarding limpo)"
xcrun simctl uninstall booted "$BUNDLE_ID" 2>/dev/null || true
xcrun simctl install booted "$APP"
xcrun simctl launch booted "$BUNDLE_ID" >/dev/null

shot() {
  local file="$1"
  local hint="$2"
  echo ""
  echo "📸 $hint"
  echo "   Salvar como: docs/screenshots/$file"
  read -r -p "   Enter quando a tela estiver pronta…"
  xcrun simctl io booted screenshot "$DOCS_SCREEN/$file"
  echo "   OK → $DOCS_SCREEN/$file"
}

sleep 3
shot "onboarding.png" "Onboarding (antes de tocar em continuar)"
shot "categories.png" "Tab Categorias"
shot "records-empty.png" "Tab Meus PRs (vazio ou com lista)"
shot "insights-free.png" "Tab Insights (plano Free — teaser PRO)"
shot "pro-upgrade.png" "Sheet CrossfitPR PRO (abrir em Insights ou Ajustes)"
shot "settings.png" "Tab Ajustes"

echo ""
echo "🎬 Gravando vídeo (~18s). Navegue pelas 4 tabs com calma."
read -r -p "   Enter para iniciar gravação…"
xcrun simctl io booted recordVideo "$VIDEO" --time-limit=18 || true

if command -v ffmpeg >/dev/null 2>&1; then
  echo "→ Gerando GIF"
  ffmpeg -y -i "$VIDEO" -vf "fps=8,scale=390:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    -loop 0 "$GIF"
  echo "   OK → $GIF"
else
  echo "⚠️  Instale ffmpeg (brew install ffmpeg) e rode:"
  echo "   ffmpeg -y -i \"$VIDEO\" -vf \"fps=8,scale=390:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse\" -loop 0 \"$GIF\""
fi

echo ""
echo "Pronto. Confira o README e faça commit de docs/screenshots e docs/media."
