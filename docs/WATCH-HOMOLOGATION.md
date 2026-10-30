# Apple Watch — Homologação (CPR-009 / CPR-016)

Companion de **sessão pesada / WOD** no pulso: timer AMRAP/EMOM/For Time, % load, descanso entre rounds e cool-down respiratório. Sem LLM no relógio — eventos sincronizam com o coach no iPhone.

Status: **pronto para homologação**. Design: canvas CPR-009 + CPR-016 · capturas `docs/screenshots/watch-*.png`.

---

## Resumo por tela

| Tela Watch | O que faz | Dados exibidos | Relação com o iPhone |
|------------|-----------|----------------|----------------------|
| **Sessão** | Timer WOD (AMRAP / EMOM / For Time) + tip metcon | mm:ss · modo · tip | Eventos `amrap` / `emom_round` → WC → coach |
| **% load** | % de 1RM (70/80/90) para até 3 lifts | Nome · % · valor | `applicationContext` do iPhone; fixture se offline |
| **Descanso** | Countdown 1:30 entre séries/rounds | `mm:ss` · ring · microcopy | Ao concluir → evento `rest` |
| **Cool-down** | Respiração 4–4 pós-esforço + haptic opt-in | Fase · anel · toggle | Preferência local |

---

## Detalhe das funcionalidades

### 1. Sessão (`WatchWODTimerView`)

- **Job:** conduzir metcon/bloco pesado no pulso (persona Compete / Mayhem).
- **Modos:** AMRAP (count-up + cap 12'), EMOM (clock 60s/round), For Time (count-up).
- **Não faz:** LLM, gráficos, ranking, HealthKit no Watch.

### 2. % load (`WatchPercentLoadView`)

- **Job:** carga rápida sem abrir Record Detail.
- **Fonte:** top 3 PRs via WC; fallback fixture (Back Squat / Clean / Deadlift).

### 3. Descanso (`WatchRestTimerView`)

- Intervalo entre séries/rounds; evento `rest` ao fim.

### 4. Cool-down (`WatchBreathingView`)

- Reset 4/4 pós-esforço.

**Follow-up:** haptic PR (backlog #12 restante).

---

## Dados: Watch × app iPhone

| Domínio | Watch | iPhone |
|---------|-------|--------|
| PRs / histórico | % load (contexto) | Exercícios, Meus PRs, Record Detail |
| Insights / Coach / Elite | — | Hub + Season Elite |
| Assinatura | — | Settings + paywall |
| Sessão no box | Timer + rest + cool-down | Eventos WC → `sessionEvents` no coach |

---

## Capturas

```bash
./scripts/capture-watch-readme-screenshots.sh
```

Gera: `watch-session.png`, `watch-load.png`, `watch-rest.png`, `watch-breath.png`.
