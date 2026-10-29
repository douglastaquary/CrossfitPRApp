# CPR-012 — Sessão CrossFit (WOD/metcon)

## Como atleta

Quero registrar (ou ter seed de) sessões de WOD com estilo, score e métricas opcionais,

para ver a última sessão e biometrics na aba Insights e enriquecer o coach.

## Critérios de aceite

- [ ] Entidade `CrossFitWorkoutSession` no Domain
- [ ] `SessionBiometrics` (avgHR, activeCalories, totalCalories, exerciseTime)
- [ ] Port `WorkoutSessionRepository` + SwiftData
- [ ] `WorkoutSessionClient` no Application
- [ ] Seed fixtures + seção Insights “Últimas sessões”
- [ ] Sessões entram no snapshot de coaching (sem programming)

## Fora de escopo

- Editor completo de WOD (follow-up)
- Benchmarks Girls/Heroes pack
