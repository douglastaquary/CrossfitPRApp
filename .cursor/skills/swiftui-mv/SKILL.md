---
name: crossfitpr-swiftui-mv
description: >-
  Padrão MV (Model-View) para SwiftUI no CrossfitPR — alinhado a Dimillian
  swiftui-view-refactor + clients Application. Use em views, refactors de UI,
  split de telas, ou quando alguém mencionar MV/MVVM/ViewModel.
---

# CrossfitPR — SwiftUI MV

> **Default:** MV, não MVVM. ViewModels são exceção (quase nunca neste projeto).

Baseado em [Dimillian — swiftui-view-refactor](https://github.com/Dimillian/Skills/blob/main/swiftui-view-refactor/SKILL.md) e [Forget MVVM (2025)](https://dimillian.medium.com/swiftui-in-2025-forget-mvvm-262ff2bbd2ed), adaptado às **Norms CrossfitPR** (SPDD + iOS 16 + `EnvironmentObject` clients).

## Mapa MV → CrossfitPR

| Dimillian MV | CrossfitPR |
|--------------|------------|
| `@Environment(Service.self)` | `@EnvironmentObject` **Clients** (`PersonalRecordClient`, `SubscriptionClient`, …) |
| Services / models | `Domain` (puro) + `WorkoutEngine` + **Clients** em `Application` |
| `@State` / enum `ViewState` | Estado local de UI na view |
| `@Query` / SwiftData | **Não** — persistência via clients → repositories JSON/CloudKit |
| ViewModel | **Proibido** salvo pedido explícito + canvas SPDD |

## Ordem de precedência

1. **SPDD** — escopo e canvas  
2. **Design** — layout/cores/tabs baseline  
3. **Esta skill (MV)** — estrutura de views  
4. **skill-ios** — Swift/concurrency/testes  

Refactor de view **sem** mudar comportamento → MV skill + `/spdd-sync`.  
Mudança visual → canvas Design antes do código.

## Ordem dentro do arquivo View (top → bottom)

1. `@EnvironmentObject` / `@Environment`
2. `let` públicos/privados
3. `@State` / `@SceneStorage` / `@Binding` recebidos
4. Computed **não-view**
5. `init`
6. `body`
7. Subviews (`private struct …: View`) ou builders **pequenos**
8. Métodos `private func` (ações, async)

## Regras de implementação

### Estado e dependências

- Lógica de **negócio** → `Domain`, `WorkoutEngine`, métodos async nos **Clients**.
- Views **orquestram** UI: `.task`, `.refreshable`, `Button(action:)` chamando `private func`.
- **Não** embutir regras de PR/assinatura/insights no `body`.
- Preferir `@State private enum ViewState` para loading/empty/loaded quando fizer sentido.

### Subviews vs `some View` computado

- **Preferir** `private struct FooSection: View` com inputs explícitos (dados, `Binding`, closures).
- Reservar `private var x: some View` a trechos **pequenos** (&lt; ~15 linhas, uma responsabilidade).
- Arquivo &gt; ~300 linhas → extrair seções para structs (mesmo arquivo ou novo arquivo no pacote feature).

### Árvore estável

- Evitar trocar a **raiz** inteira com `if/else` quando dá para usar toolbar/overlay/seções internas.
- Exceção documentada: gate Free/PRO em `WorkoutInsightsView` (duas experiências distintas).

### iOS 16 (este projeto)

- Clients: `ObservableObject` + `@EnvironmentObject` (não `@Observable` / `@Environment(Client.self)` até subir deployment).
- `@MainActor` nos clients; views chamam `await` nos métodos públicos dos clients.

### Proibido (Norms)

- Criar **ViewModels** para espelhar `@EnvironmentObject` ou `@State` local.
- `import SwiftUI` em `Domain`.
- Hardcode de strings/cores — `Strings.*`, `AppDesign.*`.

## Workflow de refactor

1. Reordenar propriedades conforme lista acima.
2. Extrair ações de `body` → `private func` / async nos clients.
3. Substituir helpers grandes `some View` por structs dedicadas.
4. Manter layout e copy idênticos (skill Design).
5. Testes: **Domain**, **WorkoutEngine**, **Clients** — não testar view model inexistente.

## Referências no repo

- Detalhes e checklist: `references/mv-patterns-crossfitpr.md`
- Arquitetura SPM: `docs/ARCHITECTURE.md`, `docs/MV-ARCHITECTURE.md`
- Canvas: `spdd/prompt/CPR-006-*-mv-swiftui-architecture-standard.md`
