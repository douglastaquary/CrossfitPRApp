# CrossfitPR — Guia para Agentes AI (SPDD)

Este projeto adota **[Structured-Prompt-Driven Development (SPDD)](https://martinfowler.com/articles/structured-prompt-driven/)** — prompts são artefatos de primeira classe, versionados junto ao código.

> **Regra de ouro:** quando a realidade divergir da intenção, **corrija o prompt primeiro** — depois atualize o código.

## Workflow SPDD (resumo)

```
Story → /spdd-analysis → /spdd-reasons-canvas → /spdd-generate → Testes
                ↑                                    ↓
         /spdd-prompt-update ←── lógica mudou    refactor → /spdd-sync
```

.cursor/
├── commands/spdd-*.md              # Comandos SPDD
├── rules/
│   ├── spdd-governance.mdc         # Governança SPDD (always apply)
│   └── ios-swift-development.mdc   # Swift + skills (globs *.swift)
└── skills/
    ├── crossfitpr-spdd/            # Skill SPDD — intenção e arquitetura
    ├── design/                     # Skill design — layout e cores baseline
    └── ios-development-skill/      # Skill Swift/iOS — implementação

## Artefatos SPDD

| Pasta | Conteúdo |
|-------|----------|
| `spdd/stories/` | User stories (requisitos de negócio) |
| `spdd/analysis/` | Análise estratégica (domínio, riscos, trade-offs) |
| `spdd/prompt/` | REASONS Canvas (Feat, Test, Fix, Refactor) |

### Canvas baseline (sistema atual)

- **Story:** `spdd/stories/CPR-001-baseline-pr-tracking-and-insights.md`
- **Analysis:** `spdd/analysis/CPR-001-20260520-[Analysis]-baseline-pr-tracking-and-insights.md`
- **Feat Canvas:** `spdd/prompt/CPR-001-20260520-[Feat]-baseline-pr-tracking-and-insights.md`
- **Test Canvas:** `spdd/prompt/CPR-001-20260520-[Test]-baseline-pr-tracking-and-insights.md`

**Antes de qualquer implementação nova**, verifique se existe canvas para a feature. Se não, siga o workflow SPDD completo.

## Skills do agente (obrigatório)

Todo desenvolvimento ou ajuste de feature/código Swift usa **skills em par ou trio**:

| Contexto | Skills | Caminhos |
|----------|--------|----------|
| Lógica / arquitetura | SPDD + iOS | `.cursor/skills/crossfitpr-spdd/SKILL.md` + `.cursor/skills/ios-development-skill/skill-ios.md` |
| **UI / layout / cores** | **SPDD + Design + iOS** | + `.cursor/skills/design/skill-design.md` |

**Precedência:** SPDD (escopo) → Design (visual, se UI) → iOS (implementação). Em conflito de escopo → ajuste o canvas antes do código.

Regras Cursor (carregamento automático):
- `spdd-governance.mdc` — sempre ativa
- `ios-swift-development.mdc` — ativa em arquivos `*.swift`
- `design-preservation.mdc` — ativa em arquivos `*.swift` (preservação visual)

## REASONS Canvas (7 dimensões)

| Dim | Nome | Conteúdo |
|-----|------|----------|
| R | Requirements | Problema + Definition of Done |
| E | Entities | Modelo de domínio (Mermaid) |
| A | Approach | Estratégia e decisões |
| S | Structure | Pacotes SPM, dependências, camadas |
| O | Operations | Tarefas concretas (métodos, lógica) |
| N | Norms | Padrões de engenharia |
| S | Safeguards | Limites e proibições |

## Visão geral técnica

CrossfitPR é um app iOS para registrar **PRs** de CrossFit, analisar evolução e converter usuários Free → **PRO**.

- **Linguagem:** Swift 6
- **UI:** SwiftUI sem ViewModels ([Dimillian 2025](https://dimillian.medium.com/swiftui-in-2025-forget-mvvm-262ff2bbd2ed))
- **Persistência:** SwiftData (local) + CloudKit (sync)
- **Testes:** Swift Testing (`import Testing`)
- **Arquitetura:** SPDD + SPM modular ([IceCubesApp](https://github.com/Dimillian/IceCubesApp))
- **Fase atual:** arquitetura/desacoplamento — **não alterar layout, cores ou fluxos de telas** (ver skill design)
- **Skills:** SPDD + iOS Swift (ver seção abaixo)
- **Deployment:** iOS 17+, Xcode 16+
- **Localização:** pt-BR (padrão) + en-US via `Packages/Localization/Resources/Localizable.xcstrings`

## Estrutura de diretórios

```
spdd/                          # Artefatos SPDD (prompts versionados)

CrossfitPR/                    # App shell — Presentation
├── CrossfitPRApp.swift
└── RootView.swift

Packages/
├── Domain/                    # Entidades e ports (REASONS E)
├── Persistence/               # Infra: SwiftData + CloudKit
├── Subscription/              # Infra: StoreKit
├── WorkoutEngine/             # Engine de insights (só Domain)
├── Localization/              # String Catalog pt-BR + en (Localizable.xcstrings)
├── Application/               # Clients + AppEnvironment
├── PRHistory/                 # Feature: histórico + novo PR
├── Insights/                  # Feature: insights de treino
├── PROUpgrade/                # Feature: upgrade PRO
└── Onboarding/                # Feature: onboarding

docs/
├── ARCHITECTURE.md
└── SPDD-WORKFLOW.md
```

## Regras de implementação

### Skills (obrigatório antes de codificar)

1. Ler `.cursor/skills/crossfitpr-spdd/SKILL.md` — canvas, escopo, safeguards.
2. Ler `.cursor/skills/ios-development-skill/skill-ios.md` — Swift, patterns, testes.
3. **Se alterar UI:** ler `.cursor/skills/design/skill-design.md` — layout, cores, navegação baseline.
4. Seguir overrides CrossfitPR na iOS skill (sem ViewModels, etc.).

### Design (Presentation — congelado)

1. **Layout e cores baseline CPR-001 são imutáveis** durante refactors de arquitetura.
2. Tokens visuais: `Packages/Localization/Sources/Localization/AppDesign.swift`.
3. Empty states: `EmptyStateView` (equivalente visual a `ContentUnavailableView`).
4. Cores via `AppDesign.Colors.*` — nunca `.green`/`.orange`/`.red` soltos em views.
5. **2 tabs fixas:** PRs + Evolução; ícones `list.bullet` e `chart.line.uptrend.xyaxis`.
6. Mudança visual exige canvas SPDD — ver `skill-design.md`.

### SPDD (obrigatório)

1. Nova feature → story + analysis + canvas **antes** de código.
2. Mudança de lógica → `/spdd-prompt-update` → `/spdd-generate`.
3. Refactor → `/spdd-sync` para manter canvas atualizado.
4. Commits referenciam ID do canvas (ex.: `CPR-004`).
5. **Nesta fase:** não alterar layout, cores ou fluxos de telas — só arquitetura/módulos (skill design).

### Localização

1. Todo copy de UI e mensagens de erro vive em `Packages/Localization`.
2. Strings: `Packages/Localization/Sources/Localization/Resources/*.lproj/Localizable.strings`.
3. API tipada: `Strings.*` — nunca hardcode strings em views.
4. Idiomas: **pt-BR** (source) e **en** (US English).
5. Exercícios: `ActivityKind.localizedName` via pacote Localization.
6. Novas strings: adicionar chave nos `.strings` + accessor em `Strings.swift`.

### UI (Presentation)

1. **Sem ViewModels** — `@EnvironmentObject` clients + `@State` + enum `ViewState`.
2. Clients via `Application`: `PersonalRecordClient`, `WorkoutEngineClient`, `SubscriptionClient`.
3. Wiring exclusivo em `AppEnvironment.make()` — app target não monta repos diretamente.
4. Views em pacotes SPM por feature (`Packages/<Feature>/`).
5. **Design baseline:** tokens em `AppDesign`; skill `.cursor/skills/design/skill-design.md`.

### Pacote Application (composition root)

1. Único pacote que importa Persistence + Subscription + WorkoutEngine juntos.
2. Expõe clients `@Observable` para Environment.
3. `AppEnvironment` — factory + `bootstrapServices()`.

### Pacote Domain (REASONS E)

1. Structs/enums `Sendable` — sem frameworks Apple.
2. Repositórios como protocolos (ports) em `Domain/Repositories/`.
3. Linguagem de negócio: PR, insight, WorkoutEngine, tier PRO — definida na seção **Entities** do canvas CPR-001 em `spdd/prompt/`.

### Persistência

1. SwiftData entities mapeiam via `toDomain()` / `fromDomain()`.
2. CloudKit sync best-effort — falha não bloqueia save local.

### PRO / Insights

1. Free: resumo + tendências + teaser PRO.
2. PRO: WorkoutEngine, recomendações, consistência.
3. Gating: `SubscriptionTier.canAccess(_:)` + `WorkoutEngine`.
4. StoreKit 2 (CPR-002): product ID `com.douglast.CrossfitPR.pro`; config local em `CrossfitPR/Configuration/Products.storekit`.

## Como adicionar feature (SPDD)

1. Criar story em `spdd/stories/CPR-NNN-*.md`.
2. `/spdd-analysis @spdd/stories/CPR-NNN-*.md`
3. `/spdd-reasons-canvas @spdd/analysis/CPR-NNN-*.md`
4. Revisar canvas → confirmar.
5. `/spdd-generate @spdd/prompt/CPR-NNN-*-[Feat]*.md`
6. Gerar/atualizar test canvas + `swift test`.

## Comandos úteis

```bash
cd Packages/Domain && swift test
cd Packages/Persistence && swift test
cd Packages/WorkoutEngine && swift test
cd Packages/Subscription && swift test
xcodebuild -scheme CrossfitPR -destination 'platform=iOS Simulator,name=iPhone 16' build
```

## Referências

- [Structured-Prompt-Driven Development — Martin Fowler](https://martinfowler.com/articles/structured-prompt-driven/)
- [SwiftUI in 2025: Forget MVVM — Dimillian](https://dimillian.medium.com/swiftui-in-2025-forget-mvvm-262ff2bbd2ed)
- [openspdd CLI](https://github.com/gszhangwei/open-spdd)
