# CPR-008 — REASONS Canvas: Tier Elite

**Story:** `spdd/stories/CPR-008-elite-tier.md`  
**Analysis:** `spdd/analysis/CPR-008-elite-tier.md`

## R — Requirements

- Tier acima de PRO para atletas avançados.
- Paywall e entitlement StoreKit documentados.
- Budget de tokens Elite separado em `TokenBudgetPolicy`.
- UI premium distinta (Design skill).

## E — Entities

- `SubscriptionTier.elite`, produtos StoreKit Elite
- Extensões de `CoachingInsight` / prompts (mesmo schema, maior profundidade)

## A — Approach

1. Domain + Subscription: tier e catálogo.
2. Design canvas → PROUpgrade multi-plano.
3. Estender `TokenBudgetPolicy.limits(for: .elite, ...)`.
4. Copy e telas Insights Elite.

## N — Norms

- Não shippar Elite sem canvas Design aprovado.
- Não quebrar PRO existente (backward compatible entitlements).
