# CPR-016 — Watch timer WOD + % load

**Personas:** Compete / Independence · companion no box  
**Backlog:** #12 Watch timer + % load — CPR-009 fase 2+

## Como atleta com Watch

Quero timer AMRAP / EMOM / For Time e % de carga no pulso,

para conduzir o WOD sem abrir o iPhone — sem LLM no relógio.

## Critérios de aceite

- [x] Modos AMRAP (count-up + cap), EMOM, For Time na Sessão
- [x] Start/pause/reset; eventos → `WatchEventSink`
- [x] % load (1–3 lifts) via applicationContext ou fixture; detalhe por PR
- [x] Rest próprio da Sessão (duração independente da tab Descanso; evento `wod_rest`)
- [x] Rest tab / cool-down preservados (duração configurável Descanso; Breath tap Start/Pause); docs WATCH-HOMOLOGATION

## Fora de escopo

- LLM / HealthKit no Watch
- Haptic PR (nice-to-have / follow-up)
