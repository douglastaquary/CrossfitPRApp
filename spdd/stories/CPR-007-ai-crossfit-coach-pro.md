# CPR-007 — Coach IA CrossFit (PRO)

## Como atleta intermediário CrossFit

Quero recomendações de movimento, rep schemes e foco na evolução dos meus PRs,

para destravar platôs sem planilha ou coach presencial todo dia.

## Critérios de aceite

- [x] Free continua só WorkoutEngine — nunca chama LLM
- [x] PRO: inferência on-device (Foundation Models / iOS 26+) quando disponível; fallback cloud HTTP + resumo local *(validar em hardware real; CI sem rede)*
- [x] Contexto compacto (`CoachingContextSnapshot`) + `TokenBudgetPolicy` antes de qualquer adapter
- [x] Cache local por `contextHash`; botão “Atualizar análise” força refresh *(UserDefaults + in-memory em testes)*
- [x] Resposta JSON/schema fixo (`CoachingInsight`) — rationale limitado por tier/runtime
- [x] Testes unitários: builder, budget, cache, adapters mock — sem LLM real no CI
- [x] Copy PRO na aba Evolução alinhada ao canvas Design *(card coach; Design fino em PR futuro)*

## Fora de escopo (CPR-007)

- Tier Elite (CPR-008)
- Apple Watch (CPR-009)
- StoreKit multi-plano Elite
