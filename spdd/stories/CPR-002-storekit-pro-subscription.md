# CPR-002 — Assinatura PRO com StoreKit 2

## Background

O tier PRO hoje usa um placeholder que libera features sem cobrança real. Para monetizar o app, a assinatura PRO precisa integrar StoreKit 2 com compra, restauração e verificação de entitlements.

## Business Value

1. **Monetização real** — cobrança via App Store.
2. **Confiança do usuário** — restore purchases e status sincronizado com Apple.
3. **Base para CPR-003** — insights PRO só após pagamento verificado.

## Scope In

- Integrar StoreKit 2 no pacote `Subscription`.
- Product ID: `com.douglast.CrossfitPR.pro` (auto-renewable subscription).
- `SubscriptionClient`: load product, purchase, restore, refresh entitlements.
- `PROUpgradeView`: exibir preço, botão restaurar, estados de loading/erro.
- Listener de `Transaction.updates` no app launch.
- Arquivo `Products.storekit` para testes locais no Xcode.
- Mock store para testes unitários (sem App Store real).

## Scope Out

- Múltiplos planos (mensal/anual) — apenas um produto PRO.
- Paywall em outras telas além de Insights/PRO.
- Server-side receipt validation.
- Family Sharing configuration.

## Acceptance Criteria

### AC-1 — Carregar produto PRO

**Given** usuário abre `PROUpgradeView`  
**When** StoreKit retorna o produto  
**Then** UI exibe nome e preço localizado do produto.

### AC-2 — Compra bem-sucedida

**Given** usuário Free com produto carregado  
**When** completa compra PRO com sucesso  
**Then** `currentTier == .pro` e insights avançados ficam acessíveis.

### AC-3 — Cancelamento pelo usuário

**Given** usuário inicia compra  
**When** cancela o sheet da App Store  
**Then** tier permanece `.free` sem mensagem de erro.

### AC-4 — Restaurar compras

**Given** usuário PRO que reinstalou o app  
**When** toca "Restaurar compras"  
**Then** `currentTier == .pro` se entitlement ativo existir.

### AC-5 — Refresh no launch

**Given** usuário PRO com subscription ativa  
**When** app inicia  
**Then** `refreshStatus()` resolve tier PRO via `Transaction.currentEntitlements`.
