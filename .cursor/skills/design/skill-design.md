---
name: crossfitpr-design
description: >-
  Preserva layout, cores, navegação e componentes visuais do baseline CrossfitPR
  (CPR-001). Use ao criar ou alterar views SwiftUI, tokens visuais, tabs, sheets
  ou copy de UI. Obrigatória junto com crossfitpr-spdd e crossfitpr-ios em
  qualquer mudança de Presentation.
---

# CrossfitPR — Design Skill

## Regra de ouro

**Arquitetura pode evoluir; o design baseline não.**

Refactors SPM, clients, persistência e testes **não** autorizam alterar layout, cores, ícones, estrutura de tabs ou fluxos de navegação sem canvas SPDD explícito de design.

## Quando usar

- Criar ou editar views em `Packages/<Feature>/`
- Alterar `RootView`, onboarding, listas, forms, sheets
- Adicionar/remover tabs ou mudar ícones de tab
- Introduzir cores, fontes ou espaçamentos novos
- Substituir componentes visuais (`EmptyStateView`, badges PRO)

## Skills em trio (obrigatório para UI)

| Ordem | Skill | Caminho |
|-------|-------|---------|
| 1 | SPDD | `.cursor/skills/crossfitpr-spdd/SKILL.md` |
| 2 | Design (esta) | `.cursor/skills/design/skill-design.md` |
| 3 | iOS Swift | `.cursor/skills/ios-development-skill/skill-ios.md` |

**Precedência:** SPDD (escopo) → Design (visual) → iOS (implementação).

## Design baseline (CPR-001)

Referência canônica: `spdd/prompt/CPR-001-20260520-[Feat]-baseline-pr-tracking-and-insights.md`  
Tokens de código: `Packages/Localization/Sources/Localization/AppDesign.swift`

### Navegação (congelada)

```
RootView
├── [onboarding incompleto] OnboardingView → CTA
└── [onboarding completo] TabView (2 tabs)
    ├── Tab PRs → PRHistoriesListView (NavigationStack)
    │   └── sheet → NewPRRecordView (Form)
    └── Tab Evolução → WorkoutInsightsView (NavigationStack)
        └── sheet → PROUpgradeView (List)
```

| Elemento | Valor fixo |
|----------|------------|
| Tabs | **2** — PRs + Evolução (copy via `Strings.Tab.*`) |
| Ícone tab PRs | `list.bullet` (`AppDesign.Icon.tabPRs`) |
| Ícone tab Evolução | `chart.line.uptrend.xyaxis` (`AppDesign.Icon.tabInsights`) |
| Onboarding | Tela única centrada (não carousel) |
| Novo PR | Sheet modal com Form |
| PRO | Sheet modal a partir de Insights |

**Proibido** sem canvas: terceira tab, NavigationLink para detail, alterar ordem das tabs.

### Paleta de cores

| Token | Uso | SwiftUI |
|-------|-----|---------|
| **Brand** | Accent global, onboarding, CTAs, TabView tint | `AppDesign.Colors.brand` (#34C759 light) |
| **PRO** | Badge premium | `AppDesign.Colors.proAccent` + opacity 0.2 no fundo |
| **Erro** | Mensagens inline | `AppDesign.Colors.error` |
| **Secundário** | Subtítulos, metadados | `.foregroundStyle(.secondary)` |
| **AccentColor** | Asset do app | `CrossfitPR/Assets.xcassets/AccentColor.colorset` |

**Proibido:** cores hardcoded ad hoc (`.green`, `.orange`, `.red`) em views — usar `AppDesign`.

### Tipografia (SF Pro / Dynamic Type)

| Uso | Token |
|-----|-------|
| Título de tela / onboarding | `AppDesign.Typography.screenTitle` |
| Título de seção PRO | `AppDesign.Typography.sectionTitle` |
| Nome do exercício / insight | `AppDesign.Typography.rowTitle` |
| Data / metadado | `AppDesign.Typography.rowSubtitle` + `.secondary` |
| Peso (lb) | `AppDesign.Typography.rowValue` + `.secondary` |
| Badge PRO | `AppDesign.Typography.proBadge` |

### Componentes visuais

| Componente | Arquivo | Regra |
|------------|---------|-------|
| Empty / erro | `EmptyStateView.swift` | Equivalente visual a `ContentUnavailableView`; ícone hierárquico 48pt |
| Lista PR | `PRHistoriesListView` | `HStack`: exercício + data à esquerda, peso à direita |
| Insight row | `WorkoutInsightsView` | Título + badge PRO opcional + mensagem |
| Onboarding | `OnboardingView` | Ícone 64pt brand + título + subtítulo + CTA `.borderedProminent` |

### Ícones SF Symbols (congelados)

Ver `AppDesign.Icon.*` — não trocar símbolos sem atualizar esta skill e o canvas.

## O que pode mudar sem canvas de design

- Textos via `Strings.*` / localização (pt-BR, en)
- Wiring de arquitetura (`@EnvironmentObject`, clients, repos)
- Lógica de negócio e testes
- Refactor de pacote SPM **sem** alterar body das views

## O que exige canvas SPDD de design

- Nova tab ou remoção de tab
- Mudança de cor de marca ou accent
- Novo fluxo de navegação (push, fullScreenCover, nova sheet)
- Redesign de lista/form/onboarding
- Substituir `EmptyStateView` por outro padrão
- Tela de edição/exclusão de PR (CPR-006)

## Checklist antes de commitar UI

```
- [ ] Li crossfitpr-spdd + skill-design + skill-ios
- [ ] Cores via AppDesign (sem .green/.orange/.red soltos)
- [ ] Ícones via AppDesign.Icon
- [ ] Tipografia via AppDesign.Typography
- [ ] Strings via Localization (sem hardcode)
- [ ] Tabs e sheets iguais ao baseline
- [ ] Canvas SPDD atualizado se layout mudou
```

## Safeguards

1. **Não** remover tabs existentes durante refactors de arquitetura.
2. **Não** alterar spacing/typography “por estética” sem canvas.
3. **Não** introduzir ViewModels para contornar regra de design.
4. **Não** duplicar tokens visuais fora de `AppDesign`.
5. Empty states **sempre** via `EmptyStateView` (nunca layout ad hoc).

## Referências

- Canvas baseline: `spdd/prompt/CPR-001-20260520-[Feat]-baseline-pr-tracking-and-insights.md`
- Tokens: `Packages/Localization/Sources/Localization/AppDesign.swift`
- Guia agentes: `AGENTS.md`
- Regra Cursor: `.cursor/rules/design-preservation.mdc`
