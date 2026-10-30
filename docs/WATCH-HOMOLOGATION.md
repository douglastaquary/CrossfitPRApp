# Apple Watch — Homologação (CPR-009 / CPR-016)

Companion de **sessão pesada / WOD** no pulso: timer AMRAP/EMOM/For Time, % load com detalhe, descanso independente por tab e cool-down respiratório interativo. Sem LLM no relógio — eventos sincronizam com o coach no iPhone.

Status: **pronto para homologação**. Design: canvas CPR-009 + CPR-016 · capturas `docs/screenshots/watch-*.png`.

---

## Resumo por tela

| Tela Watch | O que faz | Dados exibidos | Relação com o iPhone |
|------------|-----------|----------------|----------------------|
| **Sessão** | Timer WOD (AMRAP / EMOM / For Time) + tip metcon + **rest próprio** entre rounds | mm:ss · modo · tip · duração rest | Eventos `amrap` / `emom_round` / `wod_rest` → WC → coach |
| **% load** | % de 1RM (70/80/90) para até 3 lifts + **detalhe por PR** | Nome · 1RM · `70% · 98 kg` | `applicationContext` do iPhone; fixture se offline |
| **Descanso** | Countdown configurável entre séries/rounds | `mm:ss` · ring · presets | Ao concluir → evento `rest` |
| **Cool-down** | Respiração 4–4; tap inicia/pausa + haptic opt-in | Fase · anel · hint | Preferência local |

---

## Detalhe das funcionalidades

### 1. Sessão (`WatchWODTimerView`)

- **Job:** conduzir metcon/bloco pesado no pulso (persona Compete / Mayhem).
- **Modos:** AMRAP (count-up + cap 12'), EMOM (clock 60s/round), For Time (count-up).
- **Rest da Sessão:** duração **independente** (`AppStorage watch.wod.restDurationSec`, presets 60/90/120/180); countdown manual entre rounds; evento `wod_rest` ao concluir. **Não** sincroniza com a tab Descanso.
- **IDs:** `watch.wod.rest.duration`, `watch.wod.rest.toggle`, `watch.wod.rest.timer`
- **Não faz:** LLM, gráficos, ranking, HealthKit no Watch.

### 2. % load (`WatchPercentLoadView`)

- **Job:** carga rápida sem abrir Record Detail no iPhone.
- **Lista:** título `Loads · 1RM` / `Cargas · 1RM`; chips `70% · 98 kg` (unidade sempre).
- **Detalhe:** tap no lift → 70/80/90 + microcopy “working weight from 1RM”.
- **Fonte:** top 3 PRs via WC; fallback fixture (Back Squat / Clean / Deadlift).
- **IDs:** `watch.load.row.*`, `watch.load.detail.*`

### 3. Descanso (`WatchRestTimerView`)

- Intervalo entre séries/rounds; duração **própria** (`AppStorage watch.rest.durationSec`, mesmos presets).
- Evento `rest` ao fim.
- **IDs:** `watch.rest.duration`, `watch.rest.timer`, `watch.rest.toggle`

### 4. Cool-down (`WatchBreathingView`)

- Abre **pausado**; tap em Inhale/Exhale (anel) inicia/pausa o ciclo 4–4.
- Hint “Tap to start” / “Toque para começar” quando pausado.
- Haptic opt-in.
- **ID:** `watch.breath.togglePhase`

**Follow-up:** haptic PR (backlog #12 restante).

---

## Dados: Watch × app iPhone

| Domínio | Watch | iPhone |
|---------|-------|--------|
| PRs / histórico | % load (contexto + detalhe) | Exercícios, Meus PRs, Record Detail |
| Insights / Coach / Elite | — | Hub + Season Elite |
| Assinatura | — | Settings + paywall |
| Sessão no box | Timer + rest (Sessão e Descanso) + cool-down | Eventos WC → `sessionEvents` no coach |

---

## Capturas

```bash
./scripts/capture-watch-readme-screenshots.sh
```

Gera: `watch-session.png`, `watch-load.png`, `watch-rest.png`, `watch-breath.png`.
