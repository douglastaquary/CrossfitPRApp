# CPR-016 — Design: Watch timer / % load

## Sessão

- Picker compacto AMRAP | EMOM | FT
- Timer dominante (mm:ss); tip WOD em caption
- Controles start / pause / reset
- **Rest entre rounds (próprio da Sessão):** picker presets 60/90/120/180 (`watch.wod.restDurationSec`); countdown Start/Pause compacto; independente da tab Descanso
- IDs: `watch.wod.rest.duration`, `watch.wod.rest.toggle`

## % load

- Tab: título “Loads · 1RM” / “Cargas · 1RM”
- Lista: nome + 1RM; chips `70% · 98 kg` (unidade sempre)
- Tap no lift → detalhe: 70/80/90 formatados + microcopy “working weight from 1RM”
- Tipografia monospacedDigit; brand tint
- IDs: `watch.load.detail.*`

## Rest tab / Breath

Hierarquia CPR-009; durações **não** compartilhadas entre Descanso e Sessão.
