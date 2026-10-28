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

## Planned — Coach IA (CPR-007)

- **Free:** continua só WorkoutEngine (sem LLM).
- **PRO:** coach CrossFit com **inferência on-device** quando o aparelho suportar; **fallback OpenAI Chat Completions** (API direta, sem backend próprio) quando não houver Apple Intelligence.
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

## Próximos passos (dev)

1. **CPR-007 fase 3:** validar on-device iOS 26+; configurar `OPENAI_API_KEY` em builds de teste (ver [`COACHING-INFERENCE.md`](COACHING-INFERENCE.md)).
2. **Mídia README:** `./scripts/capture-readme-media-auto.sh` (Mac + Xcode) → commit em `docs/screenshots/` e `docs/media/`.
3. **CPR-008:** canvas Design Elite → `SubscriptionTier.elite` + paywall multi-plano.
4. **CPR-009:** POC watchOS + eventos compactos no snapshot do coach.

## Como acompanhar

- Stories e canvas: `spdd/stories/`, `spdd/prompt/`
- Arquitetura: [`ARCHITECTURE.md`](ARCHITECTURE.md), [`APP-WIRING.md`](APP-WIRING.md)
