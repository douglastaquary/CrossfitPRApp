# CPR-009 — REASONS Canvas: Apple Watch companion

**Story:** `spdd/stories/CPR-009-watch-companion.md`  
**Analysis:** `spdd/analysis/CPR-009-watch-companion.md`

## R — Requirements

- Companion watchOS alinhado a PRs e coach PRO no iPhone.
- UX respiração/descanso sem notification spam.
- Eventos compactos para snapshot CPR-007.
- **Ênfase sessão pesada / WOD (Compete / Mayhem):** tip de bloco/metcon; rest entre séries/rounds; breath como cool-down pós-esforço — sem LLM no Watch; sem timer AMRAP completo nesta fase (backlog #12 = P1).
- **Rest tab (2026-10-30):** duração configurável na tab Descanso (`AppStorage watch.rest.durationSec`, presets 60/90/120/180); independente do rest da Sessão (CPR-016).
- **Breath (2026-10-30):** ciclo 4–4 inicia/pausa com tap na fase Inhale/Exhale; abre pausado; toggle haptic permanece.

## A — Approach

1. POC watch app + connectivity.
2. Fase 1: tips read-only na sessão.
3. Fase 2: captura RPE/séries → iPhone.
4. StoreKit add-on (comercial no canvas).
5. **Fase HealthKit (2026-10-29):** no iPhone, `HealthKitSessionMetricsProviding` lê FC média, calorias ativas/totais e duração de workouts; popula `SessionBiometrics` (CPR-012) e cards Insights. Watch POC continua com respiração/rest; Insights mostra “Recuperação” se houver eventos breath/rest. UITest/simulador: `MockHealthKitMetricsProvider` + seed `watchLinked`. Negação de permissão → card discreto, sem quebrar hub.

## Safeguards

- Watch não chama LLM; iPhone permanece composition root do coach.
- SPDD Design para telas watch antes de implementação UI — ver `CPR-009-20261029-[Design]-watch-companion-ui.md`.
- HealthKit opcional: falha/negação não bloqueia Insights; CI usa mock.
