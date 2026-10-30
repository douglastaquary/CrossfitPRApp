# CPR-014 — Design: Paywall — 3 variantes de conversão

Sheet de planos PRO/Elite com **mais respiro** (inspirado em hierarquia Fitness: hero curto + poucas decisões).

## Princípios

- Uma ideia por viewport: headline → escolha de plano → CTA
- Máximo 3 bullets de benefício (não lista longa + compare 3 colunas + 2 benefit cards)
- Tipografia clara; spacing 24–32 entre blocos
- Restore e legal discretos no rodapé
- Continua sheet (apresentação modal)

## Variantes

| ID | Nome | Layout |
|----|------|--------|
| **A** | Hero + 2 cards | Headline curta · cards PRO e Elite (preço) · CTA único · 3 bullets |
| **B** | Escolha em passos | Headline · picker PRO/Elite · Mensal/Anual · CTA · 1 linha de prova |
| **C** | Compare leve | Headline · 3 colunas só checkmarks (Free/PRO/Elite) · CTA · sem benefit rows |

Flag: `UITEST_PAYWALL_VARIANT=a|b|c` · **produção: B** (escolhida 2026-10-29).

## B — ajuste compare (2026-10-29)

Abaixo do subtítulo: chips Free / PRO / Elite (altura igual; checks em grid 2 colunas).
- Free: PRs, Teaser
- PRO: Coach, Engine
- Elite: Coach, Engine, Assessment, Limiting (mostra que Elite inclui o PRO)
- Ref visual: `docs/screenshots/design-refs/07-paywall-ref.png` (= paywall B)
