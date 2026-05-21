---
name: crossfitpr-spdd
description: >-
  Desenvolve features no CrossfitPR seguindo SPDD (Structured-Prompt-Driven
  Development): workflow REASONS Canvas, módulos SPM, SwiftUI sem ViewModels.
  Use ao implementar features, refatorar, criar testes, ou quando o usuário
  mencionar SPDD, REASONS Canvas, CPR-00N, prompts estruturados ou CrossfitPR.
  Sempre em conjunto com crossfitpr-ios para código Swift.
---

# CrossfitPR — SPDD Skill

## Regra de ouro

Quando intenção e código divergirem: **atualize o prompt (canvas) primeiro**, depois o código.

## Skills em par/trio (obrigatório)

| Contexto | Skills |
|----------|--------|
| Lógica / arquitetura | SPDD + iOS |
| **UI / layout / cores** | **SPDD + Design + iOS** |

| Skill | Caminho | Papel |
|-------|---------|-------|
| SPDD | `.cursor/skills/crossfitpr-spdd/SKILL.md` | Intenção, canvas, arquitetura |
| Design | `.cursor/skills/design/skill-design.md` | Layout, cores, navegação baseline |
| iOS | `.cursor/skills/ios-development-skill/skill-ios.md` | Swift, SwiftUI, concurrency |

**Precedência:** SPDD → Design (UI) → iOS.

Regra Cursor complementar: `.cursor/rules/design-preservation.mdc` (arquivos `*.swift`).

## Antes de codificar

1. Existe story em `spdd/stories/CPR-NNN-*.md`?
2. Existe analysis em `spdd/analysis/`?
3. Existe canvas Feat em `spdd/prompt/*-[Feat]*.md`?

Se **não** → executar workflow completo antes de escrever Swift.

## Workflow

```
Story → /spdd-analysis → /spdd-reasons-canvas → revisar → /spdd-generate → testes
```

| Mudança | Comando |
|---------|---------|
| Novo requisito / bug de lógica | `/spdd-prompt-update` → `/spdd-generate` |
| Refactor sem mudar comportamento | refactor → `/spdd-sync` |

Comandos: `.cursor/commands/spdd-*.md`

## REASONS Canvas (7 dimensões)

| Dim | Conteúdo |
|-----|----------|
| R | Requirements + DoD |
| E | Entities (Mermaid) |
| A | Approach |
| S | Structure (pacotes SPM) |
| O | Operations (tarefas concretas) |
| N | Norms |
| S | Safeguards |

Canvas baseline: `spdd/prompt/CPR-001-20260520-[Feat]-baseline-pr-tracking-and-insights.md`

```
Domain → Persistence | Subscription | WorkoutEngine → Application → Feature packages → CrossfitPR App
```

**Regra:** não alterar layout, cores ou fluxos de telas nesta fase — só módulos e wiring. Ver `design/skill-design.md`.

## Arquitetura técnica

```
Packages/Domain/        → Entidades + ports
Packages/Persistence/ → Infra SwiftData/CloudKit
Packages/Subscription/→ Infra StoreKit
Packages/WorkoutEngine/ → Engine (só Domain)
Packages/Application/ → Clients + AppEnvironment (composition root)
Packages/PRHistory/   → Feature: histórico + novo PR
Packages/Insights/    → Feature: insights
Packages/PROUpgrade/  → Feature: upgrade PRO
Packages/Onboarding/  → Feature: onboarding
CrossfitPR/           → App shell (CrossfitPRApp + RootView)
```

### Padrões obrigatórios (Norms)

- **Sem ViewModels** — `@Environment(Client.self)` + `@State` + enum `ViewState`
- **Clients:** `PersonalRecordClient`, `WorkoutEngineClient`, `SubscriptionClient`
- **Swift 6**, iOS 17+, Swift Testing (`import Testing`)
- **Offline-first** — SwiftData local; CloudKit sync best-effort
- Novas views em `Packages/<Feature>/`

### Safeguards

- Não importar SwiftUI/UIKit em `Packages/Domain`
- Não implementar lógica de negócio fora do scope do canvas
- Não bloquear save local por falha CloudKit
- Free tier: sempre teaser PRO quando insights avançados existem

## Nova feature (checklist)

```
- [ ] Criar spdd/stories/CPR-NNN-*.md
- [ ] /spdd-analysis @story
- [ ] /spdd-reasons-canvas @analysis
- [ ] Revisar canvas (E, A, S, O, Safeguards)
- [ ] /spdd-generate @canvas
- [ ] Atualizar canvas [Test] + swift test
- [ ] Commit referencia CPR-NNN
```

## Referências

- iOS Swift: [skill-ios.md](../ios-development-skill/skill-ios.md)
- Design baseline: [skill-design.md](../design/skill-design.md)
- Detalhes: [reference.md](reference.md)
- Guia AI: [AGENTS.md](../../AGENTS.md)
- Workflow: [docs/SPDD-WORKFLOW.md](../../docs/SPDD-WORKFLOW.md)
- [SPDD — Martin Fowler](https://martinfowler.com/articles/structured-prompt-driven/)
