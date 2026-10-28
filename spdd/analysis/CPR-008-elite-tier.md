# CPR-008 — Analysis: Tier Elite

## Monetização

- Produto StoreKit separado ou upgrade path PRO → Elite
- `ProFeature` estendido: periodização, comparativos, densidade de análise

## Token budget marginal (vs PRO)

| Parâmetro | PRO cloud | Elite (proposto) |
|-----------|-----------|------------------|
| windowDays | 90 | 180 |
| maxMovements | 8 | 14 |
| maxInputTokens | 1024 | 1536 |
| cache TTL | maior | menor (análises frescas) |

Quantificar custo marginal antes de preço App Store.

## Design

Canvas Design obrigatório: paleta/ hierarquia “competidor”, não reutilizar card PRO genérico.

## Dependência

CPR-007 MVP estável (adapters + cache + snapshot).
