# CPR-007 — REASONS Canvas: Coach IA CrossFit (PRO)

**Tipo:** Feat  
**Story:** `spdd/stories/CPR-007-ai-crossfit-coach-pro.md`  
**Analysis:** `spdd/analysis/CPR-007-ai-crossfit-coach-pro.md`

## R — Requirements

- Coach PRO especialista CrossFit: evolução de PRs, platôs, rep schemes, foco em movimentos.
- Free: WorkoutEngine apenas.
- PRO: Apple Intelligence on-device quando suportado; senão cloud com mesmo snapshot comprimido.
- Transparência de custo inferência (README + observabilidade local).
- Refresh manual; cache incremental por hash de contexto.

## E — Entities

- `CoachingContextSnapshot`, `CoachingSignals`, `CoachingInsight`, `CoachingRuntime`
- Ports: `CrossFitCoachingProviding`, `CoachingInsightCaching`

## A — Approach

1. `CoachingContextBuilder` agrega PRs + tags WorkoutEngine.
2. `TokenBudgetPolicy.apply` trunca snapshot por tier/runtime.
3. Cache hit → UI sem adapter.
4. Miss → `CoachingAdapterRouter` (on-device → cloud → summarized).
5. UI: card PRO em Insights via `CoachingClient` (@EnvironmentObject).

## S — Structure

```
Packages/Coaching/
Packages/Domain/.../Coaching/
Packages/Application/CoachingClient.swift
Packages/Insights/InsightsCoachSection.swift
```

## O — Operations

- Adapters reais Apple/cloud substituem mocks em PRs futuros pós-validação dispositivo.
- `/spdd-sync` ao alterar budget ou schema de saída.

## N — Norms

| Norm | Regra |
|------|--------|
| N-token-01 | Nunca enviar lista completa de histórico ao LLM |
| N-token-02 | WorkoutEngine calcula estatística; LLM interpreta tags |
| N-token-03 | Saída schema fixo JSON — campos obrigatórios |
| N-token-04 | Free nunca invoca adapter de coaching |
| N-token-05 | CI sem chamadas de rede para LLM |

## S — Safeguards

- Fallback summarized preserva UX PRO sem expor dados extras.
- Domain sem SwiftUI; MV mantido (sem ViewModel de coach).
