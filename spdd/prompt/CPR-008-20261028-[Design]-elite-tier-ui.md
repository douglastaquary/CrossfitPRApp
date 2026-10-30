# CPR-008 — Design Canvas: Tier Elite (UI)

**Tipo:** Design (complementa [`CPR-008-20261028-[Feat]-elite-tier.md`](CPR-008-20261028-[Feat]-elite-tier.md))  
**Story:** `spdd/stories/CPR-008-elite-tier.md`  
**Skill:** `.cursor/skills/design/skill-design.md`

## Objetivo

Diferenciar **Elite** visualmente do PRO — “modo competidor” — sem quebrar baseline CPR-001 (4 tabs, navegação).

## Superfícies

| Superfície | Mudança Elite |
|------------|----------------|
| PROUpgrade paywall | Três colunas Free · PRO · Elite; pricing PRO + Elite; badge Elite |
| Insights (Elite) | Header “Competidor”; `EliteAssessmentCard` + `EliteLimitingFactorCard` |
| Insights (PRO) | Teaser Elite + CTA upsell |
| Settings | Linha Elite ativa / Upgrade to Elite / gerenciar plano |

## Tokens (aprovados)

| Token | Valor |
|-------|-------|
| `AppDesign.Colors.eliteAccent` | RGB(0.72, 0.53, 0.24) bronze-dourado |
| `AppDesign.Icon.eliteBadge` | `medal.fill` |
| Badge copy | `Strings.Elite.badge` |

**Regra:** não altera `brand` global; Elite é accent adicional.

## EliteSealBadge (2026-10-30)

Componente discreto SharedUI: ícone `medal.fill` + opcional `Strings.Elite.badge`, fonte caption, tint `eliteAccent`.

| Variante | Uso |
|----------|-----|
| `.unlocked` | Conteúdo Elite desbloqueado (assessment, limiting, award Elite) |
| `.lockedHint` | Teaser PRO — `medal` outlined, sem texto “Elite” ativo |

**Regra:** só `.unlocked` em features `isEliteOnly` / `minimumTier == .elite` com usuário Elite (ou card já gated Elite).

## Copy

- `Strings.Elite.*` + `Strings.Engine.*` (assessment) — en + pt-BR

## Componentes

- `PROUpgradePlanColumn` / `PROUpgradePlanColumnElite`
- `InsightsEliteSection` / `EliteAssessmentCard` / `EliteLimitingFactorCard`
- `EliteSealBadge` (SharedUI) — selo discreto Elite-only

## Fora de escopo Design

- watchOS (CPR-009)
- Season mode UI (P1)
- Programming / WOD do dia

## DoD Design

- [x] Tokens `eliteAccent` em `AppDesign`
- [x] Paywall 3 planos + assessment cards no código
- [ ] Checklist skill Design em PR Elite UI (revisão humana / screenshots)

## Safeguards

- Free/PRO inalterados quando usuário não é Elite
- PRO existente não perde cor `proAccent`
