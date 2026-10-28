# Roadmap de produto — CrossfitPR

Visão pública do que já está no app versus o que está **planejado** (SPDD `CPR-007+`). Nada aqui promete datas de App Store.

## Shipped (hoje)

| Área | O que o atleta recebe |
|------|------------------------|
| PRs | Registro por categoria, histórico, detalhe com percentuais |
| Free | WorkoutEngine — heurísticas locais (tendências, teaser PRO) |
| PRO | Gráficos, rankings, análises WorkoutEngine completas na UI, export |
| Dados | Offline-first + sync iCloud (best-effort) |
| Idiomas | pt-BR e en com QA automatizado no CI |

## Planned — Coach IA (CPR-007)

- **Free:** continua só WorkoutEngine (sem LLM).
- **PRO:** coach CrossFit com **inferência on-device** quando o aparelho suportar; **fallback em nuvem** quando não houver suporte local.
- **Token budget:** contexto compacto (snapshot estruturado + sinais do WorkoutEngine), cache por hash, refresh manual.
- Copy de engajamento na aba Evolução — foco em atleta intermediário (platôs, rep schemes, movimentos prioritários).

## Planned — Elite (CPR-008)

- Tier acima do PRO para atletas avançados: periodização, comparativos, análises mais densas.
- UI distinta (“modo competidor”) e paywall multi-plano (StoreKit).
- Orçamento de tokens maior que PRO (janela temporal e top-K de movimentos ampliados).

## Planned — Apple Watch (CPR-009)

- Companion watchOS: sessão de treino, timer de descanso, respiração leve em WODs intensos.
- Dicas **contextuais na sessão** — sem spam de push.
- Eventos compactos (série, RPE, descanso) alimentam o snapshot do coach no iPhone (PRO).
- Comercial: add-on ou bundle PRO + Watch (definido no canvas CPR-009).

## Como acompanhar

- Stories e canvas: `spdd/stories/`, `spdd/prompt/`
- Arquitetura: [`ARCHITECTURE.md`](ARCHITECTURE.md), [`APP-WIRING.md`](APP-WIRING.md)
