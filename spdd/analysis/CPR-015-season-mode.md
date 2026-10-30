# CPR-015 — Analysis: Season mode

## Problema

Elite tem assessment/limiting, mas não há fase de temporada — peaking/deload ficam implícitos.

## Solução

Tag `SeasonPhase` persistida + card Insights + coach window 180d. Sem programming.

## Dependências

CPR-008 Elite · SettingsClient · CoachingContextBuilder

## Riscos

Copy que sugira WOD diário → salvaguardar explicitamente.
