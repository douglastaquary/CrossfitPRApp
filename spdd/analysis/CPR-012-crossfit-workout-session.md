# CPR-012 — Analysis: CrossFit workout session (WOD)

## Problema

Só existem PRs por movimento. Atletas CrossFit pensam em **sessões** (AMRAP/EMOM/For Time). Insights e coach precisam de contexto de WOD + biometrics.

## Riscos

- Escopo de UI de log completo vs seed+consumo
- Persistência SwiftData + CloudKit sync futuro
- Não virar SugarWOD/programming

## Abordagem

1. Domain `CrossFitWorkoutSession` + `SessionBiometrics`
2. Port + SwiftData Persistence
3. Client Application
4. Insights “Últimas sessões” + fixtures
5. Formulário de criação = follow-up se necessário
