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
| iOS | `.cursor/skills/ios-development-skill/skill-ios.md` | Código Swift |

**Precedência:** SPDD → Design → iOS

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

- **Sem ViewModels** — `@EnvironmentObject` clients + `@State`
- **Clients:** `PersonalRecordClient`, `SubscriptionClient`, `SettingsClient`
- **Tokens:** `AppDesign.Colors.*`, `Strings.*`
- **iOS 17+**, Swift 6

## Artefatos SPDD

| Pasta | Conteúdo |
|-------|----------|
| `spdd/stories/` | User stories |
| `spdd/analysis/` | Análises |
| `spdd/prompt/` | REASONS Canvas |

## Comandos úteis

```bash
# Build
xcodebuild -scheme CrossfitPR -destination 'platform=iOS Simulator,name=iPhone 16' build

# Testes
cd Packages/Domain && swift test
```

## Refs

- [SPDD — Martin Fowler](https://martinfowler.com/articles/structured-prompt-driven/)
- [SwiftUI 2025 — Dimillian](https://dimillian.medium.com/swiftui-in-2025-forget-mvvm-262ff2bbd2ed)
