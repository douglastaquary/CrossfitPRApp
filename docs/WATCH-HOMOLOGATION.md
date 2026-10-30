# Apple Watch — Homologação (CPR-009)

Companion de sessão no pulso: **dica contextual**, **timer de descanso** e **respiração**. Sem LLM no relógio — eventos sincronizam com o coach no iPhone.

Status: **pronto para homologação** (fora do estágio POC de UI). Design: canvas CPR-009 · capturas `docs/screenshots/watch-*.png`.

---

## Resumo por tela

| Tela Watch | O que faz | Dados exibidos | Relação com o iPhone |
|------------|-----------|----------------|----------------------|
| **Sessão** | Tip curta para o WOD em andamento | Ícone · título · 1 tip motivacional (string local) | Não lista PRs. Eventos futuros alimentam `WatchSessionEvent` → coach no iPhone |
| **Descanso** | Countdown 1:30 com ring; pause/start | Tempo restante `mm:ss` · progresso do anel · frase curta | Ao concluir → evento `rest` via WatchConnectivity → `WatchSessionEventStore` no iPhone |
| **Respiração** | Ciclo 4–4 (inspire/expire) + haptic opt-in | Fase (inspire/expire) · anel animado · toggle háptico · padrão `4-4` | Local no Watch; sem payload de PR. Háptico só no device |

---

## Detalhe das funcionalidades

### 1. Sessão (`WatchSessionTipView`)

- **Job:** lembrar o atleta do foco do bloco sem abrir o iPhone.
- **Exibe:** tip estática localizada (`watch.session.*`) — não puxa histórico de PRs nem Insights.
- **Não faz:** LLM, gráficos, ranking, HealthKit no Watch.

### 2. Descanso (`WatchRestTimerView`)

- **Job:** controlar intervalo entre séries no pulso.
- **Exibe:** ring de progresso, timer monoespaçado, CTA iniciar/pausar.
- **Dado enviado ao iPhone:** evento tipado `rest` (fim do countdown) para contexto de coach / sessão.

### 3. Respiração (`WatchBreathingView`)

- **Job:** reset rápido entre esforços (padrão 4s / 4s).
- **Exibe:** anel + label de fase; toggle `watch.breath.hapticsEnabled`.
- **Dado:** preferência local de háptico; sem sync de métricas fisiológicas nesta versão.

---

## Dados: Watch vs app iPhone

| Domínio | Watch | iPhone |
|---------|-------|--------|
| PRs / histórico | — | Categories, Meus PRs, Record Detail (kg/lb, datas, evolução) |
| Insights / Coach / Elite | — | Hub Percepções (Free teaser · PRO coach · Elite assessment) |
| Assinatura PRO/Elite | — | Settings + sheet PROUpgrade |
| Sessão no box | Tip + rest + breath | Consome eventos WC para coaching (`CoachingContextBuilder.sessionEvents`) |
| Health / CAL / FC | — | Insights hub (quando autorizado) |

**Prioridade de produto:** o iPhone continua o centro de valor (PRs + Insights + planos). O Watch é **companion de sessão** — homologar UX de 3 tabs, sync WC e design CPR-009; não compete com o hub de Insights.

---

## Build e capturas

```bash
./scripts/generate-xcodeproj.sh
./scripts/boot-paired-watch.sh
./scripts/capture-watch-readme-screenshots.sh
```

Código: `Packages/WatchCompanion/` · target `CrossfitPRWatch/`.  
Doc legado (histórico POC): [`WATCH-POC.md`](WATCH-POC.md).
