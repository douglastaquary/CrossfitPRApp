# CPR-013 — Feat: Meus PRs Fitness + contexto + prêmios

**Story:** `spdd/stories/CPR-013-pr-list-detail-fitness.md`  
**Design:** `spdd/prompt/CPR-013-20261029-[Design]-pr-list-detail-fitness-ui.md`

## R — Requirements

- Lista sticky mês + filtros categoria + busca
- Detalhe hero + métricas + prêmios
- Contexto sessão opcional no PR
- Awards por tier
- Prints light/dark

## A — Approach

1. Domain: `PRSessionContext`, `PRAward`, `PRAwardEvaluator`
2. Seeds + NewPR preenche contexto mock Watch quando disponível
3. Redesign `PRHistoriesListView` / `RecordDetailView` / SharedUI rows
4. Sheet prêmio pós-save + seção na detail
5. UITest gallery dark+light

## N — Norms

MV; `Strings.*`; `AppDesign`; sem ViewModels

## Safeguards

- Codable backward compatible
- Free não vê awards Elite densos (só teaser / básicos)
