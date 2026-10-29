# Apple Watch companion (CPR-009)

Companion na sessão: dica contextual, timer de descanso e respiração. **Sem LLM no relógio** — eventos futuros alimentam o coach no iPhone (CPR-007).

## Código

| Peça | Caminho |
|------|---------|
| UI compartilhada | `Packages/WatchCompanion/` (`WatchCompanionRootView` + telas) |
| Target Xcode | `CrossfitPRWatch/` — compila os mesmos `.swift` + strings (embed no `CrossfitPR.app`) |
| SPM | produto `WatchCompanion` no monorepo (sem dep de `Localization`; strings em `Resources/`) |
| Sync | `WatchLinkBootstrap` (watch) + `iPhoneWatchConnectivityBridge` (iPhone) — handshake WCSession |
| Coach | `WatchSessionEvent` → `WatchSessionEventStore` → `CoachingContextBuilder.sessionEvents` |
| Timer | `WatchRestTimerView` — countdown 1:30, evento `rest` ao fim |
| Respiração | Animação 4-4 + toggle haptic (`watch.breath.hapticsEnabled`) |
| Notificações | Sem push no companion — só UI no pulso + eventos WC (haptic opt-in na respiração) |
| Próximo | Design CPR-009 (canvas UI final) |

## Build local

```bash
./scripts/configure-spm-xcode14.sh   # Xcode 14.2 local
open CrossfitPR.xcodeproj
# Scheme CrossfitPR — destino iPhone + Watch pareado no simulador
```

Build watch-only (CI / captura):

```bash
xcodebuild -scheme CrossfitPR \
  -destination 'platform=watchOS Simulator,name=Apple Watch Series 8 (45mm)' \
  build CODE_SIGNING_ALLOWED=NO
```

## Capturas README (watchOS)

Não usamos mais galeria UITest no iPhone. Use o simulador Watch:

```bash
chmod +x scripts/capture-watch-readme-screenshots.sh
./scripts/capture-watch-readme-screenshots.sh
```

iPhone (onboarding, Insights, paywall): `./scripts/capture-readme-media-auto.sh`

## Próximo

- Canvas Design CPR-009 para UI final + haptics
- Comercial add-on/bundle PRO+Watch (canvas)

Refs: [`spdd/prompt/CPR-009-20261028-[Feat]-watch-companion.md`](../spdd/prompt/CPR-009-20261028-[Feat]-watch-companion.md)
