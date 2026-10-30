# Apple Watch — Homologação (CPR-009)

Companion de **sessão pesada / WOD** no pulso: tip de metcon, timer de descanso entre rounds e cool-down respiratório. Sem LLM no relógio — eventos sincronizam com o coach no iPhone.

Status: **pronto para homologação**. Design: canvas CPR-009 · capturas `docs/screenshots/watch-*.png`.

---

## Resumo por tela

| Tela Watch | O que faz | Dados exibidos | Relação com o iPhone |
|------------|-----------|----------------|----------------------|
| **Sessão** | Tip do bloco / metcon em andamento | Ícone · título · tip WOD (string local) | Não lista PRs. Eventos futuros → `WatchSessionEvent` → coach |
| **Descanso** | Countdown 1:30 entre séries/rounds | `mm:ss` · ring · microcopy entre rounds | Ao concluir → evento `rest` (WC) → `WatchSessionEventStore` |
| **Cool-down** | Respiração 4–4 pós-esforço + haptic opt-in | Fase inspire/expire · anel · toggle háptico | Preferência local; recovery no iPhone quando houver eventos breath/rest |

---

## Detalhe das funcionalidades

### 1. Sessão (`WatchSessionTipView`)

- **Job:** foco do metcon/bloco pesado sem abrir o iPhone (persona Compete / Mayhem).
- **Exibe:** tip localizada `watch.session.tip` — estímulo/qualidade de reps.
- **Não faz:** LLM, gráficos, ranking, HealthKit no Watch.

### 2. Descanso (`WatchRestTimerView`)

- **Job:** intervalo entre séries ou rounds do WOD.
- **Exibe:** ring + timer + “entre rounds”.
- **Dado ao iPhone:** evento `rest` ao fim → contexto do coach.

### 3. Cool-down / Respiração (`WatchBreathingView`)

- **Job:** reset após esforço (4s / 4s).
- **Exibe:** anel + fase; toggle `watch.breath.hapticsEnabled`.
- **Dado:** preferência local de háptico.

**P1 (fora desta rodada):** timer AMRAP/EMOM, % load no pulso, haptic de PR (backlog #12).

---

## Dados: Watch × app iPhone

| Domínio | Watch | iPhone |
|---------|-------|--------|
| PRs / histórico | — | Exercícios, Meus PRs, Record Detail |
| Insights / Coach / Elite | — | Hub (teaser Free · coach PRO · assessment Elite + selo) |
| Assinatura | — | Settings + paywall |
| Sessão no box | Tip WOD + rest + cool-down | Eventos WC → `sessionEvents` no coach |
| Health / CAL / FC | — | Insights hub (quando autorizado) |

**Prioridade:** iPhone = centro de valor. Watch = companion de sessão pesada — não substitui Insights.

---

## Build e capturas

```bash
./scripts/generate-xcodeproj.sh
./scripts/boot-paired-watch.sh
./scripts/capture-watch-readme-screenshots.sh
```

Código: `Packages/WatchCompanion/` · target `CrossfitPRWatch/`.  
Doc legado: [`WATCH-POC.md`](WATCH-POC.md).
