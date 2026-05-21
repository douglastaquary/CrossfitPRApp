# Arquitetura CrossfitPR

## Metodologia

Este projeto é guiado por **[SPDD](https://martinfowler.com/articles/structured-prompt-driven/)** — prompts REASONS Canvas em `spdd/` definem intenção; **módulos SPM** desacoplam responsabilidades.

Canvas baseline: [`spdd/prompt/CPR-001-20260520-[Feat]-baseline-pr-tracking-and-insights.md`](../spdd/prompt/CPR-001-20260520-%5BFeat%5D-baseline-pr-tracking-and-insights.md)  
Skill: [`.cursor/skills/crossfitpr-spdd/SKILL.md`](../.cursor/skills/crossfitpr-spdd/SKILL.md)  
iOS: [`.cursor/skills/ios-development-skill/skill-ios.md`](../.cursor/skills/ios-development-skill/skill-ios.md)

## Princípios (fase atual)

1. **Arquitetura primeiro** — desacoplar módulos SPM antes de mudar telas/fluxos
2. **Prompt first** — corrigir canvas antes de alterar lógica de negócio
3. **Views estáveis** — UI/fluxos congelados nesta fase; mudanças só via clients
4. **Composition root único** — `AppEnvironment` faz wiring entre pacotes
5. **Offline-first** — SwiftData local, CloudKit sync assíncrono

## Grafo de dependências SPM

```
Domain                         (sem dependências)
  ↑
  ├── Persistence              (infra: SwiftData, CloudKit)
  ├── Subscription             (infra: StoreKit)
  └── WorkoutEngine            (domínio: engine de insights)
        ↑
Application                    (clients + AppEnvironment — ÚNICO wiring)
  ↑
Feature packages               (Presentation por feature)
  PRHistory | Insights | PROUpgrade | Onboarding
  ↑
CrossfitPR App                 (shell: CrossfitPRApp + RootView)
```

| Pacote | Depende de | Expõe |
|--------|-----------|-------|
| `Domain` | — | Entidades, ports (REASONS E) |
| `Persistence` | Domain | Repositories, `PersistenceFactory` |
| `Subscription` | Domain | `SubscriptionClient`, stores StoreKit |
| `WorkoutEngine` | Domain | `WorkoutEngine` |
| `Application` | Domain, Persistence, Subscription, WorkoutEngine | Clients, `AppEnvironment` |
| `PRHistory` | Domain, Application | `PRHistoriesListView`, `NewPRRecordView` |
| `Insights` | Domain, Application, Subscription, PROUpgrade | `WorkoutInsightsView` |
| `PROUpgrade` | Domain, Subscription | `PROUpgradeView` |
| `Onboarding` | — | `OnboardingView` |
| `CrossfitPR` (app) | Application, Domain, Subscription, feature packages | App shell |

**Regra:** pacotes de infra/domínio **não** importam uns aos outros lateralmente. `WorkoutEngine` **não** depende de `Subscription`. A composição acontece em `Application`.

## Camadas

| Camada | Pacote | Responsabilidade |
|--------|--------|------------------|
| Presentation | Feature packages + `CrossfitPR/` | SwiftUI — sem lógica de negócio |
| Application | `Packages/Application` | Clients, composition root |
| Domain | `Packages/Domain` | Entidades e ports |
| Infrastructure | Persistence, Subscription | Adapters externos |

## Composition root

```swift
let environment = try AppEnvironment.make()
await environment.bootstrapServices()

// Inject na hierarquia SwiftUI
.environment(environment.personalRecordClient)
.environment(environment.subscriptionClient)
.environment(environment.workoutEngineClient)
```

## Requisitos de build

- Xcode 16+
- iOS 17+
- Swift 6
