# CPR-002-20260520-[Analysis]-storekit-pro-subscription

> Story: [`CPR-002-storekit-pro-subscription.md`](../stories/CPR-002-storekit-pro-subscription.md)  
> Baseline: CPR-001 canvas

## Entities (REASONS E) — existing vs new

| Conceito | Status | Localização |
|----------|--------|-------------|
| `SubscriptionTier` | Existente | `Domain/Subscription/SubscriptionTier.swift` |
| `SubscriptionError` | **Estender** | `Domain/Subscription/SubscriptionStatusProviding.swift` |
| `SubscriptionCatalog` | **Novo** | `Domain/Subscription/SubscriptionCatalog.swift` |
| `SubscriptionProductInfo` | **Novo** | `Domain/Subscription/SubscriptionProductInfo.swift` |
| `SubscriptionStoreProviding` | **Novo port** | `Domain/Subscription/SubscriptionStoreProviding.swift` |
| `StoreKitSubscriptionStore` | **Novo** | `Subscription/StoreKitSubscriptionStore.swift` |
| `MockSubscriptionStore` | **Novo** | `Subscription/MockSubscriptionStore.swift` |
| `SubscriptionClient` | **Refatorar** | `Subscription/SubscriptionClient.swift` |

## Strategic Direction

1. **Port/Adapter** — `SubscriptionStoreProviding` isolates StoreKit; tests use `MockSubscriptionStore`.
2. **SubscriptionClient unchanged API surface** — `purchasePro()`, `refreshStatus()`, `restorePurchases()`; add `loadProProduct()` and `proProduct` for UI.
3. **Transaction.updates** — listener started from app; client refreshes tier on update.
4. **StoreKit Configuration file** — local testing without App Store Connect setup.

## Risks & Gaps

| Risco | Mitigação |
|-------|-----------|
| Produto não configurado no App Store Connect | `.storekit` file + clear error in UI |
| Sandbox testing complexity | Document in skill/reference |
| StoreKit not available in `swift test` on Linux | Mock-only unit tests |

## AC Coverage

| AC | Componente |
|----|------------|
| AC-1 | `loadProProduct()` + `PROUpgradeView` |
| AC-2 | `StoreKitSubscriptionStore.purchase` + client |
| AC-3 | `SubscriptionError.userCancelled` — no error UI |
| AC-4 | `restorePurchases()` → `resolveCurrentTier()` |
| AC-5 | `CrossfitPRApp.task` → `refreshStatus()` |

## Decision

Proceed with port/adapter pattern; no changes to WorkoutEngine gating logic.
