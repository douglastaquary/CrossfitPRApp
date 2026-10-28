# CPR-008 — Design Canvas: Tier Elite (UI)

**Tipo:** Design (complementa [`CPR-008-20261028-[Feat]-elite-tier.md`](CPR-008-20261028-[Feat]-elite-tier.md))  
**Story:** `spdd/stories/CPR-008-elite-tier.md`  
**Skill:** `.cursor/skills/design/skill-design.md`

## Objetivo

Diferenciar **Elite** visualmente do PRO — “modo competidor” — sem quebrar baseline CPR-001 (4 tabs, navegação).

## Superfícies

| Superfície | Mudança Elite |
|------------|----------------|
| PROUpgrade paywall | Três colunas/planos: Free · PRO · Elite; badge Elite distinto de `proAccent` |
| Insights (Elite) | Header compacto “Competidor”; densidade maior de cards (periodização placeholder) |
| Settings | Linha de assinatura Elite + gerenciar plano |

## Tokens (proposta — aprovar antes de implementar)

| Token | PRO hoje | Elite (proposto) |
|-------|----------|------------------|
| Accent secundário | `AppDesign.Colors.proAccent` | **Novo** `AppDesign.Colors.eliteAccent` (canvas aprova hex via AppDesign — ex. bronze/dourado escuro, contraste WCAG) |
| Badge | “PRO” | “Elite” com ícone `medal.fill` |
| Tipografia título paywall | `.title2.bold()` | `.title.bold()` + subtítulo “Modo competidor” |

**Regra:** não alterar `brand` global; Elite usa accent **adicional**, não substitui tabs.

## Copy (pt-BR / en)

- Tom: competidor, periodização, comparativos — **sem** hype genérico de gym app.
- Strings via `Strings.Elite.*` + `Localizable.strings` (en + pt-BR).

## Componentes

- Reutilizar `FilledButtonStyle`, cards estilo `RankingCardView`.
- Novo subview `PROUpgradePlanColumnElite` (MV — struct, sem ViewModel).

## Fora de escopo Design

- watchOS (CPR-009)
- Gráficos novos (engine) — placeholder até canvas Feat

## DoD Design

- [ ] Tokens `eliteAccent` em `AppDesign` aprovados
- [ ] Mock screenshots paywall 3 planos (Figma ou SwiftUI preview documentado)
- [ ] Checklist skill Design em PR Elite UI

## Safeguards

- Free/PRO inalterados quando usuário não é Elite
- PRO existente não perde cor `proAccent`
