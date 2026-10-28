# Apple Watch — POC (CPR-009)

Companion read-only na sessão: dica contextual, timer de descanso e respiração 4-4. **Sem LLM no relógio** — eventos futuros alimentam o coach no iPhone (CPR-007).

## Código

| Peça | Caminho |
|------|---------|
| UI compartilhada | `Packages/WatchCompanion/` |
| Gate UI test / README | `UITEST_WATCH_SCREENSHOT_GALLERY=1` → `WatchPOCGalleryView` em `AppLaunchContainer` |

## Captura README

```bash
./scripts/configure-spm-xcode14.sh   # Xcode 14.2 local
./scripts/capture-readme-media-auto.sh
```

Gera `docs/screenshots/watch-*.png` e atualiza o GIF.

## Próximo

- Target watchOS + WatchConnectivity
- Canvas Design CPR-009 antes de UI final no device

Refs: [`spdd/prompt/CPR-009-20261028-[Feat]-watch-companion.md`](../spdd/prompt/CPR-009-20261028-[Feat]-watch-companion.md)
