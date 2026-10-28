# CPR-007 — Coach IA CrossFit (PRO)

## Como atleta intermediário CrossFit

Quero recomendações de movimento, rep schemes e foco na evolução dos meus PRs,

para destravar platôs sem planilha ou coach presencial todo dia.

## Critérios de aceite

- [ ] Free continua só WorkoutEngine — nunca chama LLM
- [ ] PRO: inferência on-device (Apple Intelligence) quando disponível; fallback cloud caso contrário
- [ ] Contexto compacto (`CoachingContextSnapshot`) + `TokenBudgetPolicy` antes de qualquer adapter
- [ ] Cache local por `contextHash`; botão “Atualizar análise” força refresh
- [ ] Resposta JSON/schema fixo (`CoachingInsight`) — rationale limitado por tier/runtime
- [ ] Testes unitários: builder, budget, cache, adapters mock — sem LLM real no CI
- [ ] Copy PRO na aba Evolução alinhada ao canvas Design

## Fora de escopo (CPR-007)

- Tier Elite (CPR-008)
- Apple Watch (CPR-009)
- StoreKit multi-plano Elite
