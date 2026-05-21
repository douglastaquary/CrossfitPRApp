# CrossfitPR SPDD — Referência

## Skills do agente

| Skill | Caminho | Quando |
|-------|---------|--------|
| SPDD | `.cursor/skills/crossfitpr-spdd/SKILL.md` | Sempre — intenção e governança |
| Design | `.cursor/skills/design/skill-design.md` | Alterar views, layout, cores, tabs |
| iOS | `.cursor/skills/ios-development-skill/skill-ios.md` | Sempre que escrever/alterar Swift |

Regras Cursor: `spdd-governance.mdc`, `ios-swift-development.mdc`, `design-preservation.mdc`.

## Design baseline (CPR-001)

- Tokens: `Packages/Localization/Sources/Localization/AppDesign.swift`
- Empty states: `EmptyStateView.swift`
- **2 tabs:** PRs + Evolução — ícones congelados em `AppDesign.Icon`
- Cor de marca: verde `#34C759` (`AppDesign.Colors.brand`)
- Refactors de arquitetura **não** alteram layout/cores

## Linguagem de negócio (REASONS E)

| Termo | Código |
|-------|--------|
| PR | `PersonalRecord` |
| Exercício | `Exercise` + `ActivityKind` |
| Insight | `WorkoutInsight` |
| WorkoutEngine | Detecção em `WorkoutEngine` (categoria `.workoutEngine`) |
| PRO | `SubscriptionTier.pro` |
| Teaser PRO | Insight `.proTeaser` para tier free |

## Pacotes SPM

| Pacote | Depende de | Expõe |
|--------|-----------|-------|
| Domain | — | Entidades, ports |
| Persistence | Domain | Repositories, factory |
| Subscription | Domain | SubscriptionClient, stores |
| WorkoutEngine | Domain | `WorkoutEngine` |
| Application | Domain, Persistence, Subscription, WorkoutEngine | Clients, AppEnvironment |
| PRHistory | Domain, Application | Views de histórico |
| Insights | Domain, Application, Subscription, PROUpgrade | `WorkoutInsightsView` |
| PROUpgrade | Domain, Subscription | `PROUpgradeView` |
| Onboarding | — | `OnboardingView` |
| CrossfitPR app | Application, feature packages | App shell |

## Views → Clients (via Application)

| View | Pacote | Client(s) |
|------|--------|-----------|
| `PRHistoriesListView` | PRHistory | `PersonalRecordClient` |
| `NewPRRecordView` | PRHistory | `PersonalRecordClient` |
| `WorkoutInsightsView` | Insights | `PersonalRecordClient`, `WorkoutEngineClient`, `SubscriptionClient` |
| `PROUpgradeView` | PROUpgrade | `SubscriptionClient` |
| `OnboardingView` | Onboarding | — (AppStorage) |

## Convenção de artefatos SPDD

```
spdd/stories/CPR-NNN-{description}.md
spdd/analysis/CPR-NNN-{TIMESTAMP}-[Analysis]-{description}.md
spdd/prompt/CPR-NNN-{TIMESTAMP}-[Feat]-{description}.md
spdd/prompt/CPR-NNN-{TIMESTAMP}-[Test]-{description}.md
```

## Testes

```bash
cd Packages/Localization && swift test
cd Packages/Domain && swift test
cd Packages/Persistence && swift test
cd Packages/WorkoutEngine && swift test
cd Packages/Subscription && swift test
```

## StoreKit (CPR-002)

- Product ID: `com.douglast.CrossfitPR.pro`
- Config local: `CrossfitPR/Configuration/Products.storekit`
- No Xcode: Edit Scheme → Run → Options → StoreKit Configuration → `Products.storekit`

## Roadmap (próximas stories)

| ID | Feature | Status |
|----|---------|--------|
| CPR-003 | Camada Application + desacoplamento SPM | ✅ |
| CPR-004 | Pacotes SPM por feature + WorkoutEngine | ✅ |
| CPR-005 | LLM / Apple Intelligence | Pendente |
| CPR-006 | Edição/exclusão PR na UI | Pendente |
