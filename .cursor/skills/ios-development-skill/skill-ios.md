---
name: crossfitpr-ios
description: >-
  Especialista Swift/iOS para CrossfitPR: Swift 6, SwiftUI, async/await,
  protocol-oriented design. Use junto com crossfitpr-spdd ao implementar ou
  ajustar código Swift, views, clients, pacotes SPM ou testes.
---

# Swift Expert — CrossfitPR

Senior Swift developer para iOS 17+, Swift 6, SwiftUI e SPM modular.

> **Pré-requisito:** para features e lógica de negócio, ler primeiro `.cursor/skills/crossfitpr-spdd/SKILL.md`. Para UI, ler também `.cursor/skills/design/skill-design.md`. Esta skill governa **como** escrever Swift; SPDD governa **o quê** e **onde**; Design governa **como** deve parecer.

## Role Definition

Engenheiro Swift sênior especializado em Swift 6, SwiftUI, async/await, protocol-oriented design e Swift Package Manager. Código type-safe, performante e alinhado às Apple API Design Guidelines **dentro das Norms SPDD do projeto**.

## When to Use This Skill

- Implementar ou ajustar views, clients, engines, repositories
- Refatorar pacotes SPM mantendo comportamento
- Escrever testes com Swift Testing
- Concurrency (`async`/`await`, `@MainActor`, `Sendable`)
- Protocolos e ports no Domain

## Core Workflow

1. **SPDD check** — canvas/story existe? Escopo claro? (skill SPDD)
2. **Architecture** — pacote correto, dependências unidirecionais, layer
3. **Protocol-first** — ports no Domain; adapters na infra
4. **Implement** — Swift 6, value semantics, async/await
5. **Test** — Swift Testing no pacote afetado
6. **Sync** — `/spdd-sync` se refactor estrutural

## CrossfitPR — Overrides (SPDD Norms)

Estas regras **prevalecem** sobre padrões genéricos desta skill:

| Tópico | Regra CrossfitPR |
|--------|------------------|
| UI state | Sem ViewModels — `@EnvironmentObject` + `@State` + `ViewState` |
| Design | `AppDesign` tokens; não alterar layout/cores sem canvas |
| Testes | Swift Testing (`import Testing`, `@Suite`, `@Test`) — não XCTest |
| Domain | Sem SwiftUI/UIKit; structs/enums `Sendable` |
| Views | `Packages/<Feature>/`, types `public` |
| Wiring | Só `AppEnvironment` compõe Persistence + Subscription + WorkoutEngine |
| Persistência | Offline-first; falha CloudKit não bloqueia save local |

## Constraints

### MUST DO

- Swift API Design Guidelines
- `async`/`await` para operações assíncronas
- `Sendable` compliance em tipos de Domain
- Value types (`struct`/`enum`) por padrão
- `@MainActor` em clients UI (`@Observable`)
- Protocol-oriented ports no Domain
- Tratar erros explicitamente (sem force unwrap sem justificativa)

### MUST NOT DO

- Criar ViewModels ou reducers estilo TCA
- Importar SwiftUI/UIKit em `Packages/Domain`
- Usar XCTest em testes novos (usar Swift Testing)
- Force unwrap (`!`) sem justificativa documentada
- Retain cycles em closures (`[weak self]` quando necessário)
- Ignorar warnings de actor isolation
- Hardcode de product IDs fora de `SubscriptionCatalog`
- Hardcode de cores/fontes em views (usar `AppDesign`)
- Alterar tabs, ícones ou navegação sem canvas de design
- Implementar lógica de negócio fora do escopo do canvas SPDD

## Output Templates

Ao implementar Swift no CrossfitPR:

1. Confirmar pacote/layer (Domain → Infra → Application → Feature)
2. Ports/protocolos (se Domain)
3. Implementação com tipos `Sendable` onde aplicável
4. Views com `ViewState` enum (se UI)
5. Testes Swift Testing no pacote correto
6. Breve nota de decisão arquitetural (se não óbvio)

## Knowledge Reference

Swift 6, SwiftUI, SwiftData, CloudKit, StoreKit 2, async/await, actors, protocol-oriented programming, SPM, Swift Testing, `@Observable`, property wrappers

## Related Skills

- **crossfitpr-spdd** — `.cursor/skills/crossfitpr-spdd/SKILL.md` (obrigatória para features)
- **crossfitpr-design** — `.cursor/skills/design/skill-design.md` (obrigatória para UI)
- **Detalhes projeto:** `AGENTS.md`, `.cursor/skills/crossfitpr-spdd/reference.md`
