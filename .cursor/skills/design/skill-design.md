---
name: crossfitpr-design
description: >-
  Preserva design baseline CrossfitPR: cores, navegação, componentes.
  Use em views SwiftUI, tokens visuais, tabs. Obrigatória com SPDD + iOS.
---

# CrossfitPR — Design Skill

> **Regra de ouro:** Arquitetura evolui; design baseline não (sem canvas).

## Navegação (4 tabs)

```
AppLaunchContainer
├── LaunchScreenView (splash animado)
└── LaunchView
    ├── [offline] Tela de rede
    ├── [onboarding] OnboardingView
    └── [completo] MainTabView
        ├── Tab 0: Categories (exercícios)
        ├── Tab 1: PRHistory (meus records)
        ├── Tab 2: Insights (percepções)
        └── Tab 3: Settings (configurações)
```

## Tokens visuais

**Arquivo:** `Packages/Localization/Sources/Localization/AppDesign.swift`

| Token | Uso |
|-------|-----|
| `AppDesign.Colors.brand` | Accent global, CTAs, tabs |
| `AppDesign.Colors.proAccent` | Badge PRO |
| `AppDesign.Colors.weightChip` | Chips de peso |
| `AppDesign.Colors.metadataChip` | Chips de data |
| `AppDesign.Colors.error` | Erros inline |

| Tipografia | Uso |
|------------|-----|
| `AppDesign.Typography.screenTitle` | Títulos de tela |
| `AppDesign.Typography.rowTitle` | Nome de exercício |
| `AppDesign.Typography.formField` | Campos de formulário |

| Ícone | Tab |
|-------|-----|
| `AppDesign.Icon.tabCategories` | Exercícios |
| `AppDesign.Icon.tabRecords` | Meus records |
| `AppDesign.Icon.tabInsights` | Percepções |
| `AppDesign.Icon.tabSettings` | Configurações |

## Componentes SharedUI

| Componente | Uso |
|------------|-----|
| `FilledButtonStyle` | CTAs principais |
| `PersonalRecordRowView` | Linha de PR |
| `HSubtitleView` | Label + valor |
| `RecordImageInformationView` | Chip com ícone |
| `RankingCardView` | Card de ranking PRO |
| `CategorySegmentView` | Picker de categoria |

## Regras

- Cores: sempre `AppDesign.Colors.*` — nunca `.green`/`.red`
- Strings: sempre `Strings.*` — nunca hardcode
- Ícones: sempre `AppDesign.Icon.*`
- Layout: não mudar sem canvas SPDD

## O que exige canvas

- Nova tab ou remoção
- Nova cor/fonte
- Novo fluxo de navegação
- Redesign de tela

## Checklist

```
- [ ] Cores via AppDesign
- [ ] Strings via Localization
- [ ] Ícones via AppDesign.Icon
- [ ] Tabs/sheets iguais ao baseline
```
