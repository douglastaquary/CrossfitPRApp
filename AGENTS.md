# CrossfitPR — Guia para Agentes AI (SPDD)

> **Regra de ouro:** intenção divergiu do código? Corrija o canvas primeiro.

## Workflow SPDD

```
Story → /spdd-analysis → /spdd-reasons-canvas → /spdd-generate → Testes
```

| Mudança | Comando |
|---------|---------|
| Novo requisito | `/spdd-prompt-update` → `/spdd-generate` |
| Refactor | código → `/spdd-sync` |

## Skills (otimizadas para tokens)

| Skill | Arquivo | Quando usar |
|-------|---------|-------------|
| SPDD | `.cursor/skills/crossfitpr-spdd/SKILL.md` | Sempre |
| Design | `.cursor/skills/design/skill-design.md` | Alterando UI |
| **MV SwiftUI** | `.cursor/skills/swiftui-mv/SKILL.md` | Views, refactors, estrutura de telas |
| **Personas / Mayhem** | `.cursor/skills/crossfit-athlete-personas/SKILL.md` | Elite, Watch, retenção, níveis Liberty→Compete |
| **Architecture review** | `.cursor/skills/architecture-review/SKILL.md` | PR/CI, grafo SPM, MV |
| **App wiring** | `.cursor/skills/app-wiring/SKILL.md` | Shell, tabs, injeção global |
| iOS | `.cursor/skills/ios-development-skill/skill-ios.md` | Código Swift |

**Precedência:** SPDD → Personas (produto) → Design → **MV** → iOS

**Padrão MV:** [`docs/MV-ARCHITECTURE.md`](docs/MV-ARCHITECTURE.md) · Canvas CPR-006 · [`mv-patterns-crossfitpr.md`](.cursor/skills/swiftui-mv/references/mv-patterns-crossfitpr.md)

## Estrutura SPM

```
Packages/
├── Domain/         # Entidades, ports, services puros
├── Persistence/    # SwiftData + CloudKit
├── Subscription/   # StoreKit 2
├── WorkoutEngine/  # Engine de insights
├── Application/    # Clients + AppEnvironment
├── Localization/   # Strings + AppDesign tokens
├── SharedUI/       # Componentes visuais
├── Launch/         # Splash + onboarding gate
├── Categories/     # Lista de exercícios
├── PRHistory/      # Histórico + novo PR
├── RecordDetail/   # Detalhe + percentuais
├── Insights/       # Insights Free/PRO
├── PROUpgrade/     # Upgrade PRO
├── Settings/       # Configurações
└── Onboarding/     # Boas-vindas
```

## Navegação (4 tabs)

```
AppLaunchContainer → LaunchView → MainTabView
├── Tab 0: Categories
├── Tab 1: PRHistory
├── Tab 2: Insights
└── Tab 3: Settings
```

## Padrões obrigatórios

- **MV (Model-View)** — clients + `@State`; **sem ViewModels** (CPR-006, não MVVM)
- **Clients:** `PersonalRecordClient`, `SubscriptionClient`, `SettingsClient`
- **Tokens:** `AppDesign.Colors.*`, `Strings.*`
- **iOS 16+**, Swift 6
- **Copy humanizado** — textos diretos e motivacionais via `Strings.*`

## Artefatos SPDD

| Pasta | Conteúdo |
|-------|----------|
| `spdd/stories/` | User stories |
| `spdd/analysis/` | Análises |
| `spdd/prompt/` | REASONS Canvas |

## Comandos úteis

```bash
# Clone / alterou project.yml — gerar .xcodeproj (não está no git):
./scripts/generate-xcodeproj.sh   # docs/XCODEGEN.md

# Build (Xcode 14.2 local)
./scripts/generate-xcodeproj.sh
./scripts/configure-spm-xcode14.sh
xcodebuild -scheme CrossfitPR -destination 'platform=iOS Simulator,name=iPhone 14 Pro' build

# Gate CI (Xcode recente — espelha GitHub Actions)
CODE_SIGNING_ALLOWED=NO ./scripts/ci-modern.sh
```

CI: [`docs/CI.md`](docs/CI.md) · build `.github/workflows/ios.yml` · review `.github/workflows/pr-architecture-review.yml`  
Pagamentos: [`docs/STOREKIT-PAYMENTS.md`](docs/STOREKIT-PAYMENTS.md)

## Refs

- [SPDD — Martin Fowler](https://martinfowler.com/articles/structured-prompt-driven/)
