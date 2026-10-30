# CPR-011 — Analysis: Insights hub Fitness-like

## Problema

A aba Insights Free virou paywall; PRO mostra charts/coach mas **não renderiza** summary/trend/plateau do `WorkoutEngine`. Screenshots README ficam empty sem seed.

## Referências UX

- Beta “Percepções”: top ranking + bar charts por categoria
- Apple Fitness: métricas grandes (CAL, duração, FC), labels secundários, copy curta educativa

## Riscos

- Redesign visual exige Design canvas + preservação de brand verde
- HealthKit/WOD dependem de CPR-009 update + CPR-012
- CI sem entitlements HK → mock obrigatório

## Abordagem

1. Canvas Feat+Design → gerar UI Insights
2. Fixtures antes dos prints
3. Engine cards + Free teaser valor-first
4. Tipografia tokens; título Percepções/Insights
