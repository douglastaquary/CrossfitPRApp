# CPR-011 — Design: Insights hub UI

## Princípios (Apple Fitness × CrossfitPR)

- Large navigation title: **Percepções** (pt-BR) / **Insights** (en)
- Métricas: label `.caption` secondary + valor `rowValue` / large heavy monospacedDigit
- Cards com `AppDesign.Colors.cardBackground`; fundo `background`
- Seções: `AppDesign.Typography.sectionTitle`
- Brand verde preservado; PRO orange; Elite bronze
- Free: chart real limitado + blur/lock em análises PRO; CTA único borderedProminent

## Hierarquia PRO/Elite

1. Resumo da evolução  
2. Última sessão (CAL / duração / FC)  
3. Insights engine  
4. Elite assessment  
5. Coach  
6. Ranking + Charts (layout beta)

## Empty

`EmptyStateView` + CTA categorias — sem feature list marketing no pago.
