# CPR-001-20260520-[Test]-baseline-pr-tracking-and-insights

> Canvas de testes derivado do Feat canvas CPR-001.  
> Sincronizado via `/spdd-sync` em 2026-05-20 (WorkoutEngine + CPR-004).  
> Feat: [`CPR-001-20260520-[Feat]-baseline-pr-tracking-and-insights.md`](CPR-001-20260520-%5BFeat%5D-baseline-pr-tracking-and-insights.md)

## Requirements

Garantir cobertura de testes unitários para regras de domínio, mapeamento de persistência, engine de insights e gating de subscription — usando Swift Testing em cada pacote SPM.

## Test Scenarios

### DomainTests (`Packages/Domain/Tests/DomainTests/`)

| ID | Suite | Cenário | Expected |
|----|-------|---------|----------|
| D-01 | PersonalRecord | PR com pounds maior que anterior no mesmo exercício | `isImprovement(over:)` == true |
| D-02 | PersonalRecord | PR inferior no mesmo exercício | `isImprovement(over:)` == false |
| D-03 | Subscription Tier | Free acessa basicInsights | `canAccess(.basicInsights)` == true |
| D-04 | Subscription Tier | Free não acessa detailedAIAnalysis | `canAccess(.detailedAIAnalysis)` == false |
| D-05 | Subscription Tier | PRO acessa todas ProFeatures | all `canAccess` == true |
| D-06 | Crossfit Catalog | Catálogo selecionável | não contém `.empty` |

### PersistenceTests (`Packages/Persistence/Tests/PersistenceTests/`)

| ID | Suite | Cenário | Expected |
|----|-------|---------|----------|
| P-01 | Entity Mapping | Round-trip domain ↔ SwiftData | campos id, kind, pounds preservados |
| P-02 | SwiftData Repository | save + fetchAll | 1 record com kind correto |
| P-03 | CloudKit Mapping | makeCloudKitRecord + init | kind e pounds restaurados |

### WorkoutEngineTests (`Packages/WorkoutEngine/Tests/WorkoutEngineTests/`)

| ID | Suite | Cenário | Expected |
|----|-------|---------|----------|
| W-01 | Engine | records vazio | 1 insight summary "Comece seu histórico" |
| W-02 | Engine | 4 PRs estáveis, tier free | contém insight `.proTeaser` |
| W-03 | Engine | 3 PRs estáveis, tier pro | contém insight `.workoutEngine` |

### SubscriptionTests (`Packages/Subscription/Tests/SubscriptionTests/`)

| ID | Suite | Cenário | Expected |
|----|-------|---------|----------|
| S-01 | Client | Free user gating | não acessa detailedAIAnalysis |
| S-02 | Client | purchasePro | tier == .pro, acessa detailedAIAnalysis |

## Norms

1. Usar `import Testing` — não XCTest para novos testes.
2. `@Suite` agrupa por componente; `@Test` nomeia cenário.
3. `#expect` para assertions; `#require` para unwrap.
4. Testes de repository usam `PersistenceFactory.makeModelContainer(inMemory: true)`.
5. Não duplicar cenários já cobertos em outro pacote.

## Safeguards

1. Testes não devem depender de CloudKit real (usar mapping only).
2. Testes `@MainActor` apenas quando necessário (SubscriptionClient).
3. Novos cenários exigem atualização deste canvas antes de implementação.

## Operations

### Manter testes existentes
- Verificar que todos os IDs D-01..S-02 passam via `swift test` em cada pacote.

### Adicionar novos testes (futuro)
1. Identificar cenário no canvas de Feat (AC ou edge case).
2. Adicionar linha neste canvas.
3. Implementar teste no pacote correto.
4. Executar `swift test` no pacote.
