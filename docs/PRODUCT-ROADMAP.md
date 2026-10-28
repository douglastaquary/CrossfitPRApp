# Roadmap de produto — CrossfitPR

Visão pública do que já está no app versus o que está **planejado** (SPDD `CPR-007+`). Nada aqui promete datas de App Store.

## Shipped (hoje)

| Área | O que o atleta recebe |
|------|------------------------|
| PRs | Registro por categoria, histórico, detalhe com percentuais |
| Free | WorkoutEngine — heurísticas locais (tendências, teaser PRO) |
| PRO | Gráficos, rankings, WorkoutEngine, card **Coach** (on-device / cloud / resumo), cache local, export |
| Dados | Offline-first + sync iCloud (best-effort) |
| Idiomas | pt-BR e en com QA automatizado no CI |

## Coach IA (CPR-007) — shipped MVP

- Escada: on-device (iOS 26+) → OpenAI → resumo local; ver [`COACHING-INFERENCE.md`](COACHING-INFERENCE.md).
- Pendente validação em hardware real e tuning de prompts/custo.

## Planned — Elite (CPR-008)

- Tier acima do PRO para atletas avançados: periodização, comparativos, análises mais densas.
- UI distinta (“modo competidor”) e paywall multi-plano (StoreKit).
- Orçamento de tokens maior que PRO (janela temporal e top-K de movimentos ampliados).

## Planned — Apple Watch (CPR-009)

- Companion watchOS: sessão de treino, timer de descanso, respiração leve em WODs intensos.
- Dicas **contextuais na sessão** — sem spam de push.
- Eventos compactos (série, RPE, descanso) alimentam o snapshot do coach no iPhone (PRO).
- Comercial: add-on ou bundle PRO + Watch (definido no canvas CPR-009).

## Próximos passos (dev)

1. **CPR-007:** testar iOS 26+ on-device + `OPENAI_API_KEY` em device; revisar logs `Coaching` no Console.
2. **Mídia README:** `./scripts/capture-readme-media-auto.sh` → commit PNG/GIF.
3. **CPR-008:** aprovar [`CPR-008 Design canvas`](spdd/prompt/CPR-008-20261028-[Design]-elite-tier-ui.md) → StoreKit + `SubscriptionTier.elite`.
4. **CPR-009:** story/analysis → POC watchOS.

## Como acompanhar

- Stories e canvas: `spdd/stories/`, `spdd/prompt/`
- Arquitetura: [`ARCHITECTURE.md`](ARCHITECTURE.md), [`APP-WIRING.md`](APP-WIRING.md)
