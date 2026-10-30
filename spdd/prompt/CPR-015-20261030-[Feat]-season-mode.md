# CPR-015 — REASONS Canvas: Season mode

**Story:** `spdd/stories/CPR-015-season-mode.md`  
**Analysis:** `spdd/analysis/CPR-015-season-mode.md`  
**Design:** `spdd/prompt/CPR-015-20261030-[Design]-season-mode-ui.md`

## R — Requirements

- `SeasonPhase` + `ProFeature.seasonMode` Elite-only.
- Settings picker Elite; PRO teaser.
- Insights Elite card + selo.
- Coach window 180d Elite + season tag no snapshot.
- Sem programming diário.

### DoD

- [ ] Domain + SettingsClient + UI Settings/Insights
- [ ] CoachingContextBuilder Elite 180d
- [ ] Strings en + pt-BR

## E — Entities

`SeasonPhase` · `ProFeature.seasonMode` · preferência Settings · insight/card Season

## A — Approach

1. Domain enum + ProFeature. 2. SettingsClient. 3. Settings/Insights UI. 4. Builder window + signals.

## S — Structure

Domain · Application · Settings · Insights · Coaching · Localization

## O — Operations

UserDefaults season; analyze/rebuild coach on tier/season change.

## N — Norms

MV · sem ViewModels · Strings.* · EliteSealBadge

## S — Safeguards

Não sugerir WOD diário; Free sem season; PRO só teaser.
