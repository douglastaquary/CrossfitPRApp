# CPR-009 — Design: Watch companion UI

**Story:** `spdd/stories/CPR-009-watch-companion.md`  
**Feat:** `spdd/prompt/CPR-009-20261028-[Feat]-watch-companion.md`

## Princípios (Fitness no pulso × CrossfitPR)

- Hierarquia: label `.caption` / secondary + valor grande **monospacedDigit** (timer / fase)
- Accent: brand verde (`WatchDesign.brand` ≈ `AppDesign.Colors.brand`) — sem `Color.green` solto nas views
- Densidade mínima: uma ideia por tab; sem cards de iPhone / rankings / coach
- Fundo padrão watchOS; progresso circular no Rest e anel na Breath
- Copy curta via `WatchL10n` / strings do módulo — nunca hardcode de UI

## Tabs

| Tab | Foco visual | CTA |
|-----|-------------|-----|
| Sessão | Ícone SF + título + tip 1–2 linhas | — (read-only) |
| Descanso | Timer dominante + ring de progresso + motivação caption | Start / Pause único |
| Respiração | Anel animado + fase inhale/exhale + toggle haptic compacto | Toggle haptics |

## Safeguards

- Sem LLM no Watch; sem push spam
- Haptics opt-in (AppStorage)
- Accessibility IDs estáveis: `watch.tab.*`, `watch.rest.timer`, `watch.rest.toggle`, `watch.breath.*`
- Screenshots README: `watch-session.png`, `watch-rest.png`, `watch-breath.png`
