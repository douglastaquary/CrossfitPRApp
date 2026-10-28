# CPR-007 — Analysis: Coach IA CrossFit (PRO)

## Problema

Atletas intermediários precisam interpretação além das heurísticas do WorkoutEngine. LLM tem custo (tokens) e risco de privacidade se enviarmos histórico bruto.

## Privacidade

- Payload: agregados por movimento (último valor, delta %, data ISO) — **sem** comentários livres de PRs
- Sem PII; logs locais anonimizados: `estimatedInputTokens`, `cacheHit`, `runtime`

## Matriz runtime

| Tier | On-device | Cloud | Degradação |
|------|-----------|-------|------------|
| Free | — | — | WorkoutEngine only |
| PRO | Preferencial (Foundation Models) | Fallback **OpenAI Chat Completions** (sem backend próprio) | `SummarizedLocalCoachAdapter` |

## Token budget (PRO)

| Runtime | maxInput | maxOutput | Top-K mov. | rationale chars |
|---------|----------|-----------|------------|-----------------|
| onDeviceApple | 2048 | 512 | 12 | 280 |
| cloud | 1024 | 320 | 8 | 200 |
| summarizedLocal | 512 | 160 | 6 | 160 |

Degradação: reduzir K → encurtar tags → adapter resumido sem LLM.

## Módulos

| Camada | Artefato |
|--------|----------|
| Domain | Ports `CrossFitCoachingProviding`, `CoachingInsightCaching`; DTOs snapshot/insight |
| Coaching SPM | `CoachingContextBuilder`, `TokenBudgetPolicy`, adapters mock + router |
| Application | `CoachingClient` orquestra builder → budget → cache → adapter |
| Insights | `InsightsCoachSection` (PRO) |

## Métricas

- Taxa de cache hit
- Tokens estimados por refresh (calibrar preço PRO)
- Fallback rate cloud vs on-device

## Cloud (OpenAI)

- Endpoint padrão: `POST /v1/chat/completions`
- Credencial: `OPENAI_API_KEY` (env ou plist dev) — **não** versionar
- Modelo default: `gpt-4o-mini` (custo/latência alinhados ao tier PRO)
- Payload: system + user (snapshot JSON); `response_format: json_object`
- Sem key: orchestrator cai no resumo local (CI)

## Testes

- Golden JSON de snapshot (tamanho máximo)
- Budget trunca K quando estimate > limit
- CI: sem rede; OpenAI mockado via `URLProtocol` ou adapters que falham
