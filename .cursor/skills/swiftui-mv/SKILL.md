---
name: crossfitpr-swiftui-mv
description: >-
  Padrão MV (Model-View) para SwiftUI no CrossfitPR — clients Application + CPR-006.
  Use em views, refactors de UI, split de telas, ou MV/MVVM/ViewModel.
---

# CrossfitPR — SwiftUI MV

> **Default:** MV, não MVVM. ViewModels são exceção (quase nunca neste projeto).

Normas **CrossfitPR** (SPDD + iOS 16 + `EnvironmentObject` clients). Detalhes: `references/mv-patterns-crossfitpr.md`.

## Mapa MV → CrossfitPR

| MV genérico | CrossfitPR |
|-------------|------------|
| `@Environment(Service.self)` | `@EnvironmentObject` **Clients** |
| Services / models | `Domain` + `WorkoutEngine` + **Clients** em `Application` |
| `@State` / enum `ViewState` | Estado local de UI na view |
| Persistência na view | **Não** — clients → repositories JSON/CloudKit |
| ViewModel | **Proibido** salvo pedido explícito + canvas SPDD |

## Ordem de precedência

1. **SPDD** — escopo e canvas  
2. **Design** — layout/cores/tabs baseline  
3. **App wiring** — shell e injeção global (`app-wiring` skill)  
4. **Esta skill (MV)** — estrutura de views  
5. **skill-ios** — Swift/concurrency/testes  

Refactor sem mudar comportamento → MV skill + `/spdd-sync`.  
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
- Views **orquestram** UI: `.task`, `.refreshable`, `Button(action:)` → `private func`.
- Preferir `@State private enum ViewState` para loading/empty/loaded quando fizer sentido.

### Subviews vs `some View` computado

- **Preferir** `private struct FooSection: View` com inputs explícitos.
- Reservar `private var x: some View` a trechos **pequenos** (< ~15 linhas).
- Arquivo > ~300 linhas → extrair subviews (mesmo pacote, arquivo irmão se necessário).

### Árvore estável

- Evitar trocar a **raiz** inteira com `if/else` quando toolbar/overlay bastam.
- Exceção documentada: gate Free/PRO em `WorkoutInsightsView`.

### iOS 16 (este projeto)

- Clients: `ObservableObject` + `@EnvironmentObject`.
- `@MainActor` nos clients; views usam `await` nos métodos públicos.

### Proibido (Norms)

- **ViewModels** espelhando clients ou `@State` local.
- `import SwiftUI` em `Domain`.
- Hardcode de strings/cores — `Strings.*`, `AppDesign.*`.

## Workflow de refactor

1. Reordenar propriedades.
2. Extrair ações do `body` → `private func` / clients.
3. Substituir helpers grandes `some View` por structs.
4. Layout/copy idênticos (skill Design).
5. Testes: **Domain**, **WorkoutEngine**, **Clients**.

## Referências no repo

- Checklist completo: `references/mv-patterns-crossfitpr.md`
- Review CI: `.cursor/skills/architecture-review/SKILL.md`
- Arquitetura SPM: `docs/ARCHITECTURE.md`, `docs/MV-ARCHITECTURE.md`
- Canvas: `spdd/prompt/CPR-006-*-mv-swiftui-architecture-standard.md`
