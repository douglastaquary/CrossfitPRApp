# App Store Connect — Elite (CPR-008)

Checklist operacional para criar os produtos **Elite** reais. Os IDs no app já estão fixos — **não** invente novos IDs no ASC sem atualizar o código.

## Product IDs (fonte de verdade)

Código: [`Packages/Domain/.../SubscriptionCatalog.swift`](../Packages/Domain/Sources/Domain/Subscription/SubscriptionCatalog.swift)  
StoreKit local: [`CrossfitPR/Configuration/Products.storekit`](../CrossfitPR/Configuration/Products.storekit)

| Plano | Product ID |
|-------|------------|
| Elite mensal | `com.taquarylab.crossfitprapp.subscription.elite.monthly` |
| Elite anual | `com.taquarylab.crossfitprapp.subscription.elite.annual` |
| Elite legado (config local) | `com.douglast.CrossfitPR.elite` |

PRO (já existentes / espelhar no ASC se ainda não estiverem):

| Plano | Product ID |
|-------|------------|
| PRO mensal | `com.taquarylab.crossfitprapp.subscription.monthly` |
| PRO anual | `com.taquarylab.crossfitprapp.subscription.annual` |
| PRO legado | `com.douglast.CrossfitPR.pro` |

## No console ASC (default: grupo Elite separado)

1. App → **Subscriptions** → criar **Subscription Group** Elite (nome interno livre; no StoreKit local: `crossfitpr-elite-group`).
2. Adicionar assinatura **Elite Monthly** com product ID **exato** `…elite.monthly`.
3. Adicionar assinatura **Elite Annual** com product ID **exato** `…elite.annual`.
4. Preços / disponibilidade / localização (pt-BR + en).
5. Status **Ready to Submit**; anexar à versão do app em review.
6. Opcional: produto legado `com.douglast.CrossfitPR.elite` só se ainda houver compradores — senão deixe só no StoreKit de desenvolvimento.

## Validação no app (sandbox)

- [ ] Paywall carrega planos Free teaser / PRO / Elite (3 opções)
- [ ] Compra sandbox Elite mensal → Settings/Insights mostram tier Elite
- [ ] Restore em outro simulador/device restaura Elite
- [ ] Se houver entitlement Elite + PRO, app resolve **Elite** (prioridade no `StoreKitSubscriptionStore`)
- [ ] Review visual: `docs/screenshots/insights-elite.png`, `insights-elite-empty.png`, `pro-upgrade.png`

## Refs

- [`STOREKIT-PAYMENTS.md`](STOREKIT-PAYMENTS.md)
- Canvas Feat: `spdd/prompt/CPR-008-20261028-[Feat]-elite-tier.md`
