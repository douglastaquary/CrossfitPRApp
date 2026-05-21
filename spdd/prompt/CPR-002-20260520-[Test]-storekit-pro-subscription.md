# CPR-002-20260520-[Test]-storekit-pro-subscription

> Feat: [`CPR-002-20260520-[Feat]-storekit-pro-subscription.md`](CPR-002-20260520-%5BFeat%5D-storekit-pro-subscription.md)

## Requirements

Cobrir StoreKit integration via MockSubscriptionStore — sem App Store real.

## Test Scenarios

### SubscriptionTests

| ID | Suite | Cenário | Expected |
|----|-------|---------|----------|
| S-03 | SubscriptionClient | Free gating | não acessa detailedAIAnalysis |
| S-04 | SubscriptionClient | purchasePro sucesso | tier == .pro |
| S-05 | SubscriptionClient | userCancelled | tier permanece .free |
| S-06 | SubscriptionClient | restorePurchases com entitlement | tier == .pro |
| S-07 | SubscriptionClient | loadProProduct | proProduct.id == catalog ID |
| S-08 | MockSubscriptionStore | purchaseFailed | tier == .free, throws |

## Safeguards

- Nenhum teste chama StoreKit real.
- MockSubscriptionStore para todos os cenários de client.
