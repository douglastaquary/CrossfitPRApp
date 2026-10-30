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
| Meus PRs | Lista/detalhe estilo Fitness (contexto Watch + prêmios) — CPR-013 |
| Paywall | Sheet em passos (variante B) + tabela Free/PRO/Elite — CPR-014 |
| Watch | Companion sessão (tip / rest / breath) — homologação [`WATCH-HOMOLOGATION.md`](WATCH-HOMOLOGATION.md) |

## Coach IA (CPR-007) — shipped MVP

- Escada: on-device (iOS 26+) → OpenAI → resumo local; ver [`COACHING-INFERENCE.md`](COACHING-INFERENCE.md).
- Pendente validação em hardware real e tuning de prompts/custo.

## Elite (CPR-008) — shipped MVP (código)

- Tier Elite + assessment / limiting factor; paywall multi-plano; Insights + Settings.
- Pendente: produtos Elite no ASC ([`APP-STORE-CONNECT-ELITE.md`](APP-STORE-CONNECT-ELITE.md)); prompts coach Elite dedicados.
- UX pagamento: [`STOREKIT-PAYMENTS.md`](STOREKIT-PAYMENTS.md).

## Apple Watch (CPR-009) — homologação

- Target **CrossfitPRWatch** + `WatchCompanion` — resumo por tela: [`WATCH-HOMOLOGATION.md`](WATCH-HOMOLOGATION.md).
- Sync WC + eventos no coach; Design CPR-009 (rings Rest/Breath).
- Pendente: comercial PRO+Watch (add-on/bundle); validação em hardware.

## Próximos passos (dev)

1. **CI:** confirmar verde em [`ios.yml`](.github/workflows/ios.yml) na `main` pós-merge CPR-013/014; gate local: `./scripts/ci-modern.sh`.
2. **CPR-008 ASC:** criar/publicar produtos Elite no App Store Connect.
3. **CPR-009:** checklist homologação Watch em device + comercial bundle.
4. **CPR-007:** testar iOS 26+ on-device + `OPENAI_API_KEY`; tuning de prompts/custo.
5. **Personas / retenção:** [CPR-010](../spdd/analysis/CPR-010-crossfit-market-mayhem-personas.md) · skill personas.

## Como acompanhar

- Stories e canvas: `spdd/stories/`, `spdd/prompt/`
- Arquitetura: [`ARCHITECTURE.md`](ARCHITECTURE.md), [`APP-WIRING.md`](APP-WIRING.md)
- Pagamentos StoreKit (fluxo, erros, dual registration): [`STOREKIT-PAYMENTS.md`](STOREKIT-PAYMENTS.md)
