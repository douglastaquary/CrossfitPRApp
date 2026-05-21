---
name: crossfitpr-spdd
description: >-
  CrossfitPR + SPDD: canvas REASONS, módulos SPM, SwiftUI sem ViewModels.
  Use em features, refatorar, testes, ou menção a SPDD/CPR-00N.
---

# CrossfitPR — SPDD Skill

> **Regra de ouro:** intenção divergiu do código? Atualize o canvas primeiro.

## Workflow rápido

```
Story → /spdd-analysis → /spdd-reasons-canvas → /spdd-generate → testes
```

| Mudança | Ação |
|---------|------|
| Novo requisito | `/spdd-prompt-update` → `/spdd-generate` |
| Refactor | código → `/spdd-sync` |

## Estrutura SPM

```
Domain/         → Entidades, ports, services puros
Persistence/    → SwiftData + CloudKit
Subscription/   → StoreKit 2
WorkoutEngine/  → Engine de insights
Application/    → Clients + AppEnvironment
Localization/   → Strings + AppDesign tokens
SharedUI/       → Componentes visuais
Launch/         → Splash + onboarding gate
Categories/     → Lista de exercícios
PRHistory/      → Histórico + novo PR
RecordDetail/   → Detalhe + percentuais
Insights/       → Insights Free/PRO
PROUpgrade/     → Tela de upgrade
Settings/       → Configurações
Onboarding/     → Boas-vindas
```

## Padrões (Norms)

- **Sem ViewModels** — `@EnvironmentObject` clients + `@State`
- **Clients:** `PersonalRecordClient`, `SubscriptionClient`, `SettingsClient`
- **Tokens visuais:** `AppDesign.Colors.*`, `AppDesign.Typography.*`
- **Strings:** `Strings.*` — nunca hardcode
- **iOS 17+**, Swift 6, Swift Testing

## Safeguards

- Domain: sem SwiftUI/UIKit
- Offline-first: CloudKit sync não bloqueia save local
- Free tier: sempre teaser PRO em insights avançados

## REASONS Canvas

| Dim | Conteúdo |
|-----|----------|
| R | Requirements + DoD |
| E | Entities (Mermaid) |
| A | Approach |
| S | Structure (SPM) |
| O | Operations |
| N | Norms |
| S | Safeguards |

Canvas baseline: `spdd/prompt/CPR-001-*-[Feat]-*.md`

## Refs

- Stories: `spdd/stories/`
- Analysis: `spdd/analysis/`
- Canvas: `spdd/prompt/`
- Guia: `AGENTS.md`
