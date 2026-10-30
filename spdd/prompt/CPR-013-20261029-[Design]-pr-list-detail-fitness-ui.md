# CPR-013 — Design: Meus PRs / Detalhe / Prêmios (Fitness)

**Refs:** `docs/screenshots/design-refs/`

## Lista

- Large title **Meus PRs**
- Busca nativa; abaixo chips horizontais: Todos · Barra · Ginásticos · Resistência
- Chip ativo: fundo `activityAccent` (lima); inativo: surface
- `LazyVStack(pinnedViews: .sectionHeaders)` — mês sticky (`setembro de 2026`)
- Row: leading ícone grupo + accent · título · valor secundário · trailing data
- Sem cards na lista (exceto eventual banner de prêmio recente Free teaser)

## Detalhe

1. Hero com respiro (spacing 24–32): local · título display · valor grande · intervalo data/hora · fonte Watch · clima (° / umidade)
2. Link/seção **Detalhes do exercício**
3. Grid 2 col: tempo exercício, duração, CAL ativas/total, FC média — labels caption, valores title2
4. Espaço generoso antes de charts/histórico
5. Seção **Prêmios** (cards)
6. Fundo dark-first + light validado; surfaces `cardBackground`

## Prêmio (sheet)

- Medalha/ícone grande centrado
- Título + body critério/contagem/data
- Dismiss

## Tokens

- `AppDesign.Colors.activityAccent` — chips / ícone atividade (lima Fitness)
- Brand verde permanece em CTAs globais
