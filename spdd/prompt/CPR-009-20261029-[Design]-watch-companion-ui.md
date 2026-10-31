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
| Sessão | Timer WOD + tip metcon (CPR-016) | Start / Pause / Reset (+ rest próprio da Sessão) |
| Descanso | Timer dominante + ring; picker de duração; microcopy **entre séries / rounds** | Start / Pause + presets 60/90/120/180 |
| Respiração | Anel + fase; copy **cool-down pós-esforço** + toggle haptic | Tap na fase Inhale/Exhale = Start/Pause; toggle haptics |

### Narrativa WOD (2026-10-30)

- Sessão = foco do metcon/bloco sem abrir o iPhone.
- Rest (tab Descanso) = intervalo de treino pesado (não “pausa genérica”); duração **própria** desta tab.
- Breath = reset após esforço; abre pausado; tap inicia/pausa o ciclo 4–4; haptic opt-in.

### Rest / Breath UX (2026-10-30)

- Descanso: `watch.rest.durationSec` — picker só quando pausado; IDs `watch.rest.duration`, `watch.rest.timer`, `watch.rest.toggle`.
- Breath: hint “toque para começar” quando pausado; ID `watch.breath.togglePhase`.

## Safeguards

- Sem LLM no Watch; sem push spam
- Haptics opt-in (AppStorage)
- Accessibility IDs estáveis: `watch.tab.*`, `watch.rest.timer`, `watch.rest.toggle`, `watch.rest.duration`, `watch.breath.*`
- Screenshots README: `watch-session.png`, `watch-rest.png`, `watch-breath.png`
