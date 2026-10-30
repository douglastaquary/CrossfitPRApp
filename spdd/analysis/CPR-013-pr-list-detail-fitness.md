# CPR-013 — Analysis

## Refs

`docs/screenshots/design-refs/01–06-*.png` (Apple Fitness dark).

## Dados novos

`PersonalRecord` ganha contexto opcional (`PRSessionContext`): local, calorias ativas/totais, duração exercício, FC média, temperatura, umidade, fonte (`manual` | `appleWatch` | `health`).

Persistência JSON já é Codable — campos novos com default não quebram arquivo antigo.

## Prêmios

Motor puro Domain (`PRAwardEvaluator`) a partir de histórico + tier. UI: cards na detail + sheet. Densidade: Free básica · PRO streaks · Elite marcos densos.

## Riscos

- Não copiar mapa Apple 1:1 (privacidade) — hero com gradiente/categoria ou placeholder de mapa mock.
- Accent lima Fitness vs brand verde CrossfitPR: token `activityAccent` para chips/ícones de atividade; CTAs seguem `brand`.
