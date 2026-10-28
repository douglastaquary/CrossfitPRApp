# CPR-008 — Tier Elite (atletas avançados)

**Personas:** Compete / Freedom ([skill crossfit-athlete-personas](../../.cursor/skills/crossfit-athlete-personas/SKILL.md))  
**Backlog:** Athlete Assessment (#6) + Limiting factor (#7) — CPR-010

## Como competidor / atleta avançado

Quero análises densas, assessment por domínio (força / Oly / ginástica / engine),
limiting factor claro e comparativos além do PRO,

para preparar competições e ciclos de treino longos — sem virar app de programming diário.

## Critérios de aceite

- [x] `SubscriptionTier.elite` + `ProFeature` elite-only + StoreKit IDs Elite
- [x] Paywall multi-plano em PROUpgrade (Free/PRO/Elite)
- [x] UI distinta “modo competidor” — Insights + Settings + tokens Design
- [x] `TokenBudgetPolicy` com limites Elite (window 180 no builder = wiring follow-up)
- [ ] Coach prompts Elite dedicados (budget Elite já em TokenBudgetPolicy)
- [x] **Athlete Assessment** — scores + cards UI
- [x] **Limiting factor** + teaser PRO → Elite
- [x] Free/PRO gating; `isPaid` inclui Elite

## Fora de escopo

- watchOS (CPR-009)
- Programming diário estilo Mayhem Athlete
- Season mode completo (P1 — story/canvas follow-up)
- Volume/readiness avançado (P2)
