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
- [ ] Comercial: add-on ou bundle PRO+Watch (canvas)
- [ ] HealthKit no iPhone: FC média, calorias, duração → Insights (mock em UITest)

## Fases

1. Read-only tips na sessão
2. Captura real-time + sync
3. HealthKit metrics → SessionBiometrics / Insights hub
