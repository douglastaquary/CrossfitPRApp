# Coach PRO — inferência (CPR-007)

## Visão unificada

| Etapa | O quê |
|-------|--------|
| **Free** | Só WorkoutEngine — sem LLM |
| **PRO preferencial** | Apple Intelligence on-device (Foundation Models, iOS 26+) |
| **PRO fallback cloud** | **API OpenAI Chat Completions** — não há backend CrossfitPR; o app envia o snapshot compacto direto à API |
| **Degradação** | Análise resumida local (sem LLM) |

O custo PRO cobre inferência (tokens on-device ou OpenAI). O app **nunca** envia histórico bruto de PRs — apenas `CoachingContextSnapshot` agregado.

## Fluxo técnico

1. `CoachingContextBuilder` + `TokenBudgetPolicy`
2. Cache `UserDefaults` por `contextHash`
3. `CoachingInferenceOrchestrator`: on-device → OpenAI → resumo

## On-device (Apple Intelligence)

- iOS **26+**, `FoundationModels`, `SystemLanguageModel.default.isAvailable`
- Guided generation (`@Generable`) ou parse JSON da resposta
- SDK/Xcode antigos: caminho omitido na compilação → cai na OpenAI ou resumo

## Cloud — OpenAI Chat Completions

Sem API key configurada → `cloudNotConfigured` → resumo local (CI e simulador).

### Configuração (não commitar segredos)

| Fonte | Chave | Uso |
|-------|--------|-----|
| Ambiente | `OPENAI_API_KEY` | Bearer token (obrigatório para cloud) |
| Ambiente | `OPENAI_CHAT_MODEL` | Default `gpt-4o-mini` |
| Ambiente | `OPENAI_BASE_URL` | Opcional; default `https://api.openai.com/v1/chat/completions` |
| Info.plist | `OpenAIAPIKey`, `OpenAIChatModel`, `OpenAIBaseURL` | Dev local apenas |

Legado: `COACHING_CLOUD_BEARER` / `CoachingCloudBearerToken` ainda mapeiam para a API key.

### Request (implementado)

- **POST** `https://api.openai.com/v1/chat/completions`
- `response_format: json_object`
- System: instruções fixas do coach CrossFit
- User: snapshot JSON (movimentos, platôs, tags WorkoutEngine)
- Resposta: `choices[0].message.content` → JSON `workoutSuggestion`, `focusLifts`, `repScheme`, `rationale`

`max_tokens` alinhado ao budget cloud (320 default).

### Produção e privacidade

- Preferir **on-device** quando disponível (menor latência, sem enviar dados).
- OpenAI: revisar [políticas de uso](https://openai.com/policies) e desativar treino nos dados da API (config da conta).
- Alternativa futura: proxy server-side (fora do escopo CPR-007 MVP) para esconder a key — hoje o canvas assume **chave no app** ou variável de ambiente em builds internos.

UI tests (`UITEST_SKIP_SPLASH=1`) **bloqueiam** chamadas cloud.

## CI

Sem `OPENAI_API_KEY` → cloud indisponível → resumo local. Testes unitários não usam rede real.

## Referências

- `spdd/analysis/CPR-007-ai-crossfit-coach-pro.md`
- Pacotes: `Packages/Coaching/`, `CoachingOpenAIConfiguration.swift`
