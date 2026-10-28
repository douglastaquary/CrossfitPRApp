# CPR-009 — REASONS Canvas: Apple Watch companion

**Story:** `spdd/stories/CPR-009-watch-companion.md`  
**Analysis:** `spdd/analysis/CPR-009-watch-companion.md`

## R — Requirements

- Companion watchOS alinhado a PRs e coach PRO no iPhone.
- UX respiração/descanso sem notification spam.
- Eventos compactos para snapshot CPR-007.

## A — Approach

1. POC watch app + connectivity.
2. Fase 1: tips read-only na sessão.
3. Fase 2: captura RPE/séries → iPhone.
4. StoreKit add-on (comercial no canvas).

## Safeguards

- Watch não chama LLM; iPhone permanece composition root do coach.
- SPDD Design para telas watch antes de implementação UI.
