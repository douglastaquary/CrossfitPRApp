# CPR-011 — REASONS Canvas: Insights hub Fitness-like

**Story:** `spdd/stories/CPR-011-insights-hub-fitness.md`  
**Analysis:** `spdd/analysis/CPR-011-insights-hub-fitness.md`  
**Design:** `spdd/prompt/CPR-011-20261029-[Design]-insights-hub-ui.md`

## R — Requirements

- Hub Insights PRO/Elite: resumo → última sessão → engine cards → Elite → coach → ranking/charts
- Free: insight real + chart teaser + CTA upgrade (gostinho PRO/Elite)
- Empty limpo; tipografia Fitness; título Percepções/Insights
- Fixtures UITest por cenário

### DoD

- [ ] UI paga consome `WorkoutEngineClient.insights` (summary/trend/plateau/recommendation)
- [ ] Free teaser valor-first
- [ ] Screenshots seed Free/PRO/Elite

## E — Entities

Usa `PersonalRecord`, `WorkoutInsight`, `CrossFitWorkoutSession` (CPR-012), `SessionBiometrics` (HK).

## A — Approach

1. Design tokens tipografia/métricas
2. Subviews MV em Insights (sem ViewModels)
3. Wire engine + sessions + Elite
4. Free teaser redesign
5. Seed + screenshots

## S — Structure

| Pacote | Mudança |
|--------|---------|
| Insights | Hub + Free teaser |
| Localization | Strings + Typography |
| Application | seed / sessions / health |
| Domain | fixtures (CPR-012) |

## O — Operations

- `workoutEngineClient.analyze(records:)`
- `workoutSessionClient.fetchSessions()`
- `healthKitProvider.latestMetrics(...)`

## N — Norms

- MV; `AppDesign`; `Strings.*`; Free sem Elite full

## S — Safeguards

- Offline-first; HK denial não quebra UI; mock em UITest
