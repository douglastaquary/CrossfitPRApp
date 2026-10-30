# CPR-016 — REASONS Canvas: Watch WOD timer + % load

**Story:** `spdd/stories/CPR-016-watch-wod-timer.md`  
**Design:** `spdd/prompt/CPR-016-20261030-[Design]-watch-wod-timer-ui.md`

## R — Requirements

- Timer AMRAP / EMOM / For Time na Sessão Watch.
- % load 1–3 lifts (context ou fixture).
- Eventos → WatchEventSink; sem LLM.

### DoD

- [ ] UI timer + % load
- [ ] Strings Watch en/pt-BR
- [ ] WATCH-HOMOLOGATION atualizado

## E — Entities

`WatchWODMode` · payload eventos timer · lift % snapshot

## A — Approach

1. Substituir tip-only por timer + tip compacta. 2. Tab/% section. 3. Bridge context no iPhone. 4. Fixture homologação.

## S — Structure

WatchCompanion · CrossfitPRWatch · Application bridge · docs

## N — Norms

WatchDesign tokens · WatchL10n · sem ViewModels

## S — Safeguards

Sem LLM; offline-first; fixture se WC falhar.
