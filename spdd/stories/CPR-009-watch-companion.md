# CPR-009 — Apple Watch companion

## Como atleta PRO

Quero sessão de treino no pulso com descanso, respiração leve e dicas contextuais,

para manter foco no box sem abrir o iPhone a todo momento.

## Critérios de aceite

- [x] Target watchOS companion (`CrossfitPRWatch` + `WatchCompanion`)
- [x] Sync com iPhone (WatchConnectivity — eventos compactos → `WatchSessionEventStore` → coach)
- [x] Timer de descanso + mensagem motivacional curta (`WatchRestTimerView`)
- [x] Respiração visual/haptic em treinos intensos (opt-in — toggle na tab Respiração)
- [x] Eventos compactos (série, RPE, descanso) → `CoachingContextBuilder.sessionEvents`
- [x] Sem spam de notificações push (companion não registra push — só WC + haptic opt-in)
- [x] HealthKit no iPhone: FC média, calorias, duração → Insights (mock em UITest) — CPR-011/012
- [x] Design final UI (canvas Design CPR-009) — hierarquia Fitness no pulso + tokens `WatchDesign`
- [ ] Comercial: add-on ou bundle PRO+Watch (canvas Feat)

## Fases

1. Read-only tips na sessão
2. Captura real-time + sync
3. HealthKit metrics → SessionBiometrics / Insights hub
4. Design final (UI polish + capturas README)
