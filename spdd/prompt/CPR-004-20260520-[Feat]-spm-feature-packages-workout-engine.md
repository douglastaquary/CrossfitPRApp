# CPR-004 — Feature packages SPM + WorkoutEngine

> Sincronizado via `/spdd-sync` retroativo em 2026-05-20.  
> Story: [`CPR-004-spm-feature-packages-workout-engine.md`](../stories/CPR-004-spm-feature-packages-workout-engine.md)

## Requirements

Extrair views para pacotes SPM por feature e renomear `WorkoutAnalysis` → `WorkoutEngine` (terminologia e código) — mantendo layout e fluxos idênticos ao baseline.

DoD: ACs da story CPR-004.

## Entities

Renomeações de domínio:

| Antes | Depois |
|-------|--------|
| `WorkoutAnalysis` (pacote) | `WorkoutEngine` |
| `WorkoutAnalysisEngine` | `WorkoutEngine` |
| `WorkoutAnalysisClient` | `WorkoutEngineClient` |
| `WorkoutInsight.Category.plateau` | `.workoutEngine` |
| `ProFeature.plateauDetection` | `.workoutEngineAnalysis` |
| Termo "platô" (UI/strings) | "WorkoutEngine" |

## Approach

1. Criar pacotes feature com views `public`.
2. App target retém apenas `CrossfitPRApp` + `RootView`.
3. Renomear pacote engine e atualizar Application + Domain.
4. Atualizar `project.pbxproj` — remover sources de views, linkar packages.

## Structure

```
Packages/
├── PRHistory/       → PRHistoriesListView, NewPRRecordView
├── Insights/        → WorkoutInsightsView (importa PROUpgrade)
├── PROUpgrade/      → PROUpgradeView
├── Onboarding/      → OnboardingView
└── WorkoutEngine/   → WorkoutEngine (substitui WorkoutAnalysis)

CrossfitPR/
├── CrossfitPRApp.swift
└── RootView.swift   → import PRHistory, Insights, Onboarding
```

### Grafo final

```
Domain → Persistence | Subscription | WorkoutEngine
              ↓
         Application
              ↓
PRHistory | Insights | PROUpgrade | Onboarding
              ↓
         CrossfitPR (shell)
```

## Operations

### Rename WorkoutAnalysis → WorkoutEngine
1. Novo pacote `Packages/WorkoutEngine/`.
2. Struct `WorkoutEngine: WorkoutInsightsProviding`.
3. Deletar `Packages/WorkoutAnalysis/`.
4. `Application` importa WorkoutEngine; `WorkoutEngineClient` substitui client anterior.

### Domain updates
1. `WorkoutInsight` em arquivo próprio; categoria `.workoutEngine`.
2. `ProFeature.workoutEngineAnalysis` — marketing "Análise WorkoutEngine".

### Feature packages
1. **PRHistory** — deps: Domain, Application.
2. **PROUpgrade** — deps: Domain, Subscription.
3. **Insights** — deps: Domain, Application, Subscription, PROUpgrade.
4. **Onboarding** — sem deps externas.

### App shell
1. `RootView` importa feature packages.
2. `CrossfitPRApp` injecta `workoutEngineClient`.
3. Remover `CrossfitPR/Features/`.

### project.pbxproj
1. Remover view sources do target CrossfitPR.
2. Adicionar package refs: PRHistory, Insights, PROUpgrade, Onboarding, WorkoutEngine.

## Norms

1. Views `public`; layout/fluxos inalterados.
2. Feature packages importam Application, não Persistence.
3. Linguagem de negócio: WorkoutEngine (não "platô").

## Safeguards

1. Não alterar strings de layout além da renomeação WorkoutEngine.
2. Não adicionar lógica de negócio nas feature packages.
3. Sincronizar canvases históricos CPR-001 via `/spdd-sync`.

## Testes

- `WorkoutEngineTests`: cenário W-03 verifica `.workoutEngine` (não `.plateau`).
- `AppEnvironmentTests`: `workoutEngineClient.insights.isEmpty`.
