# CPR-010 — Analysis: Mercado CrossFit, Mayhem Nation e personas

**Tipo:** Analysis (conhecimento de produto) — sem Canvas Feat nesta rodada.  
**Skill canônica:** [`.cursor/skills/crossfit-athlete-personas/`](../../.cursor/skills/crossfit-athlete-personas/SKILL.md)

## Problema

CrossfitPR precisa ancorar Free/PRO/Elite + Watch em perfis reais de praticantes e no mindset de atletas competitivos (referência Mayhem Nation), sem virar app de programming diário.

## Achados (resumo)

1. **Mercado:** ~4M praticantes; Open ~344k; idade ~33; maioria mulher; retenção por comunidade; ~3% profissionais.  
2. **Níveis Mayhem:** Liberty → Independence → Freedom (Rx) → Compete (Rx+) — âncoras, não silos rígidos.  
3. **Cabeças:** Froning, Hunsucker, Malleolo, McKernan, MDV; Freedom teams como persona Compete.  
4. **Treino Compete:** activation → prep → metcon (stimulus/targets) → strength %/RPE → cool-down; missed day sem culpa.  
5. **Diferenciação:** PR intelligence, %, gaps, feedback pós-WOD, Watch — segundo cérebro ao lado do box/Mayhem.

## Tese de produto

- UI Free/PRO → Liberty/Independence.  
- Engine calibra contra padrões Elite; densidade por `SubscriptionTier`.  
- Elite (CPR-008) + Watch (CPR-009) = valor "viciante" para Compete.

## Artefatos da skill

| Path | Uso |
|------|-----|
| `SKILL.md` | Triggers, norms, checklist |
| `references/user-personas.md` | Personas + JTBD |
| `references/mayhem-nation.md` | Pessoas, tracks, princípios |
| `references/feature-backlog.md` | Backlog → CPR-007/008/009 |
| `examples.md` | Decisões de densidade/copy |

## Relação SPDD

| ID | Papel |
|----|-------|
| CPR-001 | Baseline PR + Insights |
| CPR-007 | Coach IA PRO |
| CPR-008 | Tier Elite |
| CPR-009 | Watch companion |
| **CPR-010** | Este analysis + skill de personas |

## Próximos passos

1. ~~Escolher linha do backlog~~ → Athlete Assessment + Limiting factor (P0 #6/#7).  
2. ~~Prompt-update CPR-008~~ → story/analysis/Feat/Design.  
3. ~~Generate Domain+Engine~~ → assessment + budget.  
4. ~~UI Design + StoreKit Elite~~ → paywall, Insights, Settings, Products.storekit.  
5. ~~Selo Elite discreto + ênfase Watch WOD~~ (2026-10-30 — CPR-008/009 Design).  
6. **App Store Connect** (produtos Elite) + screenshots Design.  
7. P1: Season mode · Watch timer AMRAP/% load (#12) · Share Card · Benchmarks.

## Fora de escopo deste analysis

- Código Swift / target watchOS.  
- Edição dos canvases CPR-008/009 (usar `/spdd-prompt-update`).  
- Parceria comercial Mayhem Nation.
