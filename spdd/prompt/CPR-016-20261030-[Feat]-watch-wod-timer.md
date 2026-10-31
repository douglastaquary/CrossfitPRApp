# CPR-016 — REASONS Canvas: Watch WOD timer + % load

**Story:** `spdd/stories/CPR-016-watch-wod-timer.md`  
**Design:** `spdd/prompt/CPR-016-20261030-[Design]-watch-wod-timer-ui.md`

## R — Requirements

- Timer AMRAP / EMOM / For Time na Sessão Watch.
- % load 1–3 lifts (context ou fixture); títulos claros + detalhe por PR (70/80/90 com unidade).
- Eventos → WatchEventSink; sem LLM.
- **Rest da Sessão (2026-10-30):** duração **independente** da tab Descanso (`AppStorage watch.wod.restDurationSec`, presets 60/90/120/180); countdown manual entre rounds; evento `wod_rest` ao concluir. Não sincroniza com `watch.rest.durationSec`.

### DoD

- [x] UI timer + % load
- [x] Rest próprio da Sessão (duração + countdown)
- [x] % load detalhe por lift
- [x] Strings Watch en/pt-BR
- [x] WATCH-HOMOLOGATION atualizado


## E — Entities

`WatchWODMode` · payload eventos timer · lift % snapshot · `wod_rest` duration

## A — Approach

1. Substituir tip-only por timer + tip compacta. 2. Tab/% section. 3. Bridge context no iPhone. 4. Fixture homologação.
5. Rest local na Sessão (picker + countdown) desacoplado da tab Descanso.
6. NavigationLink para detalhe de % load por lift.

## S — Structure

WatchCompanion · CrossfitPRWatch · Application bridge · docs

## N — Norms

WatchDesign tokens · WatchL10n · sem ViewModels

## S — Safeguards

Sem LLM; offline-first; fixture se WC falhar.
