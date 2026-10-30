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
| Percepções | Hub Insights estilo Fitness (Free teaser + PRO/Elite) — CPR-011 |
| Sessão / HealthKit | WOD + biometrics (mock em sim/UITest) — CPR-012 / CPR-009 |

## Coach IA (CPR-007) — shipped MVP

- Escada: on-device (iOS 26+) → OpenAI → resumo local; ver [`COACHING-INFERENCE.md`](COACHING-INFERENCE.md).
- Pendente validação em hardware real e tuning de prompts/custo.

## In progress — Elite (CPR-008)

- Tier Elite + assessment / limiting factor (Domain + WorkoutEngine).
- UI modo competidor: paywall 3 planos, Insights cards, Settings Elite.
- StoreKit: IDs Elite em `SubscriptionCatalog` + `Products.storekit`.
- Pendente: prompts coach Elite dedicados; App Store Connect produtos reais; screenshots Design.
- UX pagamento: feedback por etapa + restore — ver [`STOREKIT-PAYMENTS.md`](STOREKIT-PAYMENTS.md).

## In progress — Apple Watch (CPR-009)

- Target **CrossfitPRWatch** + pacote `WatchCompanion` ([`WATCH-POC.md`](WATCH-POC.md)).
- Sync WC + eventos no coach PRO; timer descanso + respiração/haptic no relógio.
- CI compila watchOS no gate moderno; capturas README via `./scripts/capture-watch-readme-screenshots.sh`.
- Próximo: Design final (CPR-009 canvas).
- Dicas **contextuais na sessão** — sem spam de push.
- Eventos compactos (série, RPE, descanso) alimentam o snapshot do coach no iPhone (PRO).
- Comercial: add-on ou bundle PRO + Watch (definido no canvas CPR-009).

## Próximos passos (dev)

1. **CI:** confirmar verde em [`ios.yml`](.github/workflows/ios.yml) na `main` (rerun se fila macOS); gate local Xcode 15+: `./scripts/ci-modern.sh`.
2. **Mídia README:** `./scripts/capture-readme-media-auto.sh` → commit PNG/GIF Insights Free/PRO/Elite (empty + rich) + paywall Elite quando estável.
3. **CPR-007:** testar iOS 26+ on-device + `OPENAI_API_KEY` em device; revisar logs `Coaching` no Console.
4. **CPR-008:** App Store Connect (produtos Elite reais) + screenshots Design; prompts coach Elite dedicados (canvas Feat).
5. **CPR-009:** canvas Design final + comercial PRO+Watch (`watch-*.png` já na `main`).
6. **Personas:** skill [`.cursor/skills/crossfit-athlete-personas`](../.cursor/skills/crossfit-athlete-personas/SKILL.md) · [CPR-010](../spdd/analysis/CPR-010-crossfit-market-mayhem-personas.md).

## Como acompanhar

- Stories e canvas: `spdd/stories/`, `spdd/prompt/`
- Arquitetura: [`ARCHITECTURE.md`](ARCHITECTURE.md), [`APP-WIRING.md`](APP-WIRING.md)
- Pagamentos StoreKit (fluxo, erros, dual registration): [`STOREKIT-PAYMENTS.md`](STOREKIT-PAYMENTS.md)
