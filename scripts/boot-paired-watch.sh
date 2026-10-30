#!/usr/bin/env bash
# Sobe o Apple Watch já pareado com o iPhone Simulator bootado (ou o UDID passado).
# Xcode só lança o companion Watch quando o destino iPhone tem um Watch *pareado*.
set -euo pipefail

export DEVELOPER_DIR="${DEVELOPER_DIR:-/Applications/Xcode_14.2.app/Contents/Developer}"

IPHONE_UDID="${1:-}"
if [[ -z "$IPHONE_UDID" ]]; then
  IPHONE_UDID="$(xcrun simctl list devices | sed -n 's/.*iPhone.*(Booted).*(\([A-F0-9-]\{36\}\)).*/\1/p' | head -1)"
  # macOS sed variant — fallback awk
  if [[ -z "$IPHONE_UDID" ]]; then
    IPHONE_UDID="$(xcrun simctl list devices | awk '/iPhone/ && /\(Booted\)/ {
      if (match($0, /\([0-9A-F-]{36}\)/)) {
        id=substr($0, RSTART+1, RLENGTH-2); print id; exit
      }
    }')"
  fi
fi

if [[ -z "$IPHONE_UDID" ]]; then
  echo "Nenhum iPhone Booted. Abra o Simulator e escolha um iPhone."
  echo "Uso: $0 [IPHONE_UDID]"
  exit 1
fi

echo "→ iPhone: $IPHONE_UDID"

WATCH_UDID="$(xcrun simctl list pairs | awk -v p="$IPHONE_UDID" '
  /Watch:/ {
    line=$0
    if (match(line, /\([0-9A-F-]{36}\)/)) watch=substr(line, RSTART+1, RLENGTH-2)
  }
  /Phone:/ {
    line=$0
    if (match(line, /\([0-9A-F-]{36}\)/)) phone=substr(line, RSTART+1, RLENGTH-2)
    if (phone == p && watch != "") { print watch; exit }
  }
')"

if [[ -z "$WATCH_UDID" ]]; then
  echo "Este iPhone não tem Watch pareado."
  echo "Simulator → File → Open Simulator (Watch) e Device → Pair Watch com o iPhone."
  echo "Ou: xcrun simctl pair <WATCH_UDID> $IPHONE_UDID && xcrun simctl boot <WATCH_UDID>"
  exit 2
fi

echo "→ Watch pareado: $WATCH_UDID"

# Desliga outros Watches bootados (evita destino errado no Xcode)
xcrun simctl list devices | awk '/Watch/ && /\(Booted\)/ {
  if (match($0, /\([0-9A-F-]{36}\)/)) print substr($0, RSTART+1, RLENGTH-2)
}' | while read -r other; do
  [[ "$other" == "$WATCH_UDID" ]] && continue
  echo "  shutdown $other"
  xcrun simctl shutdown "$other" 2>/dev/null || true
done

xcrun simctl boot "$WATCH_UDID" 2>/dev/null || true
xcrun simctl bootstatus "$WATCH_UDID" -b
echo
echo "Pronto. No Xcode: scheme CrossfitPR → destino deste iPhone → Cmd+R."
xcrun simctl list devices | grep Booted || true
