# CPR-008 — Analysis: Tier Elite

**Skill de produto:** `.cursor/skills/crossfit-athlete-personas/` (CPR-010)  
**Dependência:** CPR-007 MVP estável (adapters + cache + snapshot)

## Monetização

- Produto StoreKit separado ou upgrade path PRO → Elite
- `ProFeature` elite-only: `athleteAssessment`, `limitingFactorAnalysis` (+ densidades futuras)
- PRO continua com features atuais; **não** acessa elite-only
- Teaser Elite em Insights PRO (mesma lógica do teaser PRO no Free)

## Token budget marginal (vs PRO)

| Parâmetro | PRO cloud | Elite (proposto) |
|-----------|-----------|------------------|
| windowDays | 90 | 180 |
| maxMovements | 8 | 14 |
| maxInputTokens | 1024 | 1536 |
| maxOutputTokens | 320 | 480 |
| cache TTL | maior | menor (análises frescas) |

Quantificar custo marginal antes de preço App Store.

## Athlete Assessment (produto Mayhem-inspired)

Espelho leve do Mayhem Performance Coaching: assessment vs field → limiting factors — **sem** coaching humano nem programming.

| Domínio | Fonte de PRs | Baseline (heurística v1) |
|---------|--------------|---------------------------|
| Strength | Barbell (squat, DL, press, bench) | Cobertura + progresso recente |
| Olympic | Clean / snatch / jerk (nome) | Cobertura relativa à strength |
| Gymnastics | RecordGroup.gymnastic | Cobertura + max reps trend |
| Engine | RecordGroup.endurance | Cobertura (tempo/distância) |

- Engine Domain puro calcula scores 0…1 e escolhe **limiting factor** = domínio com menor score entre os que têm dados; se um domínio crítico está vazio e outros fortes → esse é o teto.
- UI Elite mostra cards; PRO vê teaser; Free não vê assessment.

## Design

Canvas Design obrigatório: paleta/hierarquia “competidor”, cards Assessment + Limiting Factor.
Não reutilizar card PRO genérico.

## Fases de generate

1. **Domain + Engine** — tier, ProFeatures, assessment, insights Elite/teaser (esta rodada)
2. **Coaching budget Elite** — `TokenBudgetPolicy` + window 180 no builder quando Elite
3. **UI** — só após tokens `eliteAccent` aprovados no Design canvas
4. **StoreKit** — produto Elite + paywall 3 planos
