# CPR-016 — Analysis: Watch WOD timer + % load

## Problema

Companion só tip + rest 90s + breath — atleta Compete precisa de timer de metcon e % no pulso.

## Solução

Timer AMRAP/EMOM/FT na Sessão; % load via WC applicationContext (fixture fallback).

## Dependências

CPR-009 Watch · WatchEventSink · iPhoneWatchConnectivityBridge · PRPercentages (iPhone)

## Riscos

WatchConnectivity flaky em sim → fixture para homologação.
