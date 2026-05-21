# CPR-001-20260520-[Analysis]-baseline-pr-tracking-and-insights

> Sincronizado via `/spdd-sync` em 2026-05-20 (CPR-003 + CPR-004).  
> Story de referência: [`CPR-001-baseline-pr-tracking-and-insights.md`](../stories/CPR-001-baseline-pr-tracking-and-insights.md)

## Entities (REASONS E)

### Existing (implementado)

| Conceito | Papel | Localização | Regras |
|----------|-------|-------------|--------|
| `PersonalRecord` | Entidade principal | `Domain/Entities/PersonalRecord.swift` | PR de um exercício; `isImprovement(over:)` compara mesmo `ActivityKind` |
| `Exercise` | Entidade | `Domain/Entities/Exercise.swift` | Contém `ActivityKind` |
| `ActivityKind` | Enum tipado | `Domain/ValueObjects/ActivityKind.swift` | Exercícios CrossFit |
| `WorkoutInsight` | Modelo de leitura | `Domain/Services/WorkoutInsight.swift` | Insight gerado; categoria `.workoutEngine` para análise PRO |
| `SubscriptionTier` | Enum | `Domain/Subscription/SubscriptionTier.swift` | `.free` / `.pro`; `canAccess(ProFeature)` |
| `ProFeature` | Enum | `Domain/Subscription/SubscriptionTier.swift` | `.workoutEngineAnalysis` para feature PRO |
| `PersonalRecordEntity` | Entidade de persistência | `Persistence/SwiftData/PersonalRecordEntity.swift` | Mapeamento SwiftData ↔ Domain |

### Ports (interfaces)

| Port | Implementações |
|------|----------------|
| `PersonalRecordRepository` | `SwiftDataPersonalRecordRepository`, `CloudKitPersonalRecordRepository`, `CompositePersonalRecordRepository` |
| `WorkoutInsightsProviding` | `WorkoutEngine` |
| `SubscriptionStoreProviding` | `StoreKitSubscriptionStore`, `MockSubscriptionStore` |

### Application clients

| Client | Localização | Compõe |
|--------|-------------|--------|
| `PersonalRecordClient` | `Application/PersonalRecordClient.swift` | Repository |
| `WorkoutEngineClient` | `Application/WorkoutEngineClient.swift` | `WorkoutEngine` + `SubscriptionClient` |
| `SubscriptionClient` | `Subscription/SubscriptionClient.swift` | Store |
| `AppEnvironment` | `Application/AppEnvironment.swift` | Composition root |

### Feature packages (Presentation)

| Pacote | Views |
|--------|-------|
| `PRHistory` | `PRHistoriesListView`, `NewPRRecordView` |
| `Insights` | `WorkoutInsightsView` |
| `PROUpgrade` | `PROUpgradeView` |
| `Onboarding` | `OnboardingView` |

## Strategic Direction

### Abordagem escolhida

1. **Modularização SPM** — pacotes desacoplados: Domain, Persistence, WorkoutEngine, Subscription, Application + feature packages.
2. **SwiftUI sem ViewModels** — clients `@Observable` injetados via `@Environment` ([Dimillian 2025](https://dimillian.medium.com/swiftui-in-2025-forget-mvvm-262ff2bbd2ed)).
3. **Offline-first** — SwiftData como fonte local; CloudKit sync best-effort.
4. **PRO gating no engine** — `WorkoutEngine.generateInsights(from:tier:)` decide o que expor.
5. **Teaser PRO** — usuários free veem contagem de insights bloqueados para incentivar upgrade.
6. **Composition root único** — `AppEnvironment` (CPR-003) faz wiring entre pacotes.

### Decisões de design

| Decisão | Alternativa rejeitada | Rationale |
|---------|----------------------|-----------|
| Composite repository | Apenas CloudKit | Offline-first; sync não bloqueia UX |
| Heurísticas locais (WorkoutEngine) | LLM externo imediato | Baseline sem dependência de API; extensível depois |
| `@Observable` clients | ViewModels / Reducer Store | Alinhado com SwiftUI 2025; menos boilerplate |
| Feature packages SPM | Views no app target | Desacoplamento estilo IceCubesApp (CPR-004) |
| iOS 17+ / Swift 6 | iOS 15 / Swift 5 | SwiftData + Swift Testing |

## Risks & Gaps

| Risco | Severidade | Mitigação |
|-------|-----------|-----------|
| CloudKit schema não configurado | Alta | Configurar record type `PersonalRecord` no dashboard |
| Sem UI de delete/edit PR | Baixa | Fora do scope baseline (roadmap CPR-006) |
| Heurísticas ≠ IA real | Baixa | Roadmap: Apple Intelligence / LLM (CPR-005) |
| Xcode 16+ obrigatório | Média | Documentado em AGENTS.md |

## Acceptance Criteria Coverage

| AC | Coberto por | Status |
|----|-------------|--------|
| AC-1 Registrar PR | `NewPRRecordView` (PRHistory) + `PersonalRecordClient.save` | ✅ |
| AC-2 Offline-first | `SwiftDataPersonalRecordRepository` | ✅ |
| AC-3 Free + teaser | `WorkoutEngine.makeProTeaser` | ✅ |
| AC-4 PRO insights | `WorkoutEngine.makeProInsights` (categoria `.workoutEngine`) | ✅ |
| AC-5 Upgrade | `SubscriptionClient` + StoreKit 2 (CPR-002) | ✅ |

## Edge Cases Identificados

- PR com `ActivityKind.empty` → rejeitado no mapeamento CloudKit/SwiftData.
- CloudKit indisponível → save local succeed, sync falha silenciosamente.
- Lista vazia de PRs → insight "Comece seu histórico".
- Menos de 2 PRs por exercício → sem tendência básica.
- Menos de 3 PRs por exercício → sem detecção WorkoutEngine PRO.

## Evolução pós-baseline

| ID | Feature | Status |
|----|---------|--------|
| CPR-002 | StoreKit 2 real | ✅ |
| CPR-003 | Camada Application | ✅ |
| CPR-004 | Feature packages + WorkoutEngine | ✅ |
| CPR-005 | LLM / Apple Intelligence | Pendente |
| CPR-006 | Edição/exclusão PR na UI | Pendente |
