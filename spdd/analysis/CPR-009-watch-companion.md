# CPR-009 — Analysis: watchOS companion

## Riscos

- Target watchOS + provisioning
- WatchConnectivity vs shared container
- HealthKit / workout session (opcional fase 2)

## Dados → Coach

Eventos compactos por sessão — **não** transcript bruto:

```json
{ "phase": "rest", "rpe": 8, "movement": "thruster", "durationSec": 90 }
```

`CoachingContextBuilder` agrega sessão Watch no snapshot (campo futuro `sessionEvents[]` truncado).

## UX

- Dicas in-session only
- Respiração: cadência 4-4 ou box breathing — haptic leve
- Descanso: timer + uma linha motivacional; retomada explícita

## Dependências

CPR-007 coach no iPhone consome snapshot enriquecido.
