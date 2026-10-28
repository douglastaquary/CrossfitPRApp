# MV Patterns — CrossfitPR

Norma interna de **MV SwiftUI moderno** (CPR-006). Referência para skills, code review e CI.

## Postura padrão

- Default **MV**: views leves, orquestração local, lógica nos clients/domain.
- Preferir `@State`, `@EnvironmentObject`, `.task` / `.task(id:)`, `.onChange`, `.refreshable` antes de ViewModel.
- Lógica de negócio em **services, models, clients** — não no `body`.
- Telas grandes → **subviews `struct`** antes de nova camada.
- Testar **Domain**, **WorkoutEngine**, **clients**; views permanecem declarativas.

## Stack CrossfitPR

| Camada | Onde | Exemplo |
|--------|------|---------|
| **Model** | `Domain`, engines, repositories | `PersonalRecord`, `WorkoutEngine`, ports |
| **Application** | `Packages/Application` | `PersonalRecordClient.fetchRecords()` |
| **View** | `Packages/<Feature>/` | `PRHistoriesListView`, subviews |

```
User action → View (private func) → Client (@MainActor) → Repository / Engine → Domain
                ↑________________ @Published / objectWillChange ________________|
```

Persistência: **clients → repositories** (JSON/CloudKit). Não usar ViewModel para espelhar fetch.

## Quando **não** usar ViewModel

- Espelhar `@Published` de um client.
- Encapsular só `@State` de sheet/navigation.
- Substituir `.task { await client.fetch… }` por “loader VM”.
- View longa → **split em subviews**, não indireção.

## Quando ViewModel *poderia* ser discutido (raro)

- Bridge para API não-SwiftUI legada.
- Pedido explícito **e** canvas CPR aprovado.

Default: **recusar** e aplicar MV.

## Padrão: estado local + clients

```swift
public struct WorkoutInsightsView: View {
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @EnvironmentObject private var subscriptionClient: SubscriptionClient
    @State private var isPresentingPROUpgrade = false

    public var body: some View {
        NavigationStack {
            insightsContent
                .navigationTitle(Strings.Screen.insights)
                .task(id: personalRecordClient.records.count) {
                    await loadRecordsIfNeeded()
                }
                .refreshable { await personalRecordClient.fetchRecords() }
        }
    }

    @ViewBuilder
    private var insightsContent: some View { /* gate Free/PRO */ }

    private func loadRecordsIfNeeded() async {
        guard personalRecordClient.records.isEmpty else { return }
        await personalRecordClient.fetchRecords()
    }
}
```

## Padrão: modifiers como orquestração

- `.task(id: searchText) { … }` para reload derivado.
- `.onChange(of: …) { Task { await … } }` para fluxos simples.
- Não promover isso a ViewModel sem motivo claro.

## Testes

- Services, regras de domínio, workflows async nos clients.
- UI tests pontuais (localização, fluxos críticos).
- **Não** criar ViewModel só para “testar view”.

## Checklist de PR (views) — espelho do CI

- [ ] Sem tipo `*ViewModel` novo
- [ ] Ações fora do `body` (`private func`)
- [ ] `Strings.*` / `AppDesign.*` (en + pt-BR — `docs/LOCALIZATION.md`)
- [ ] Seções grandes como `View` struct
- [ ] Refactor: layout/comportamento unchanged; feature: canvas Design
- [ ] Testes de domínio/client se lógica mudou
- [ ] Respeito ao grafo SPM (`docs/ARCHITECTURE.md`, `scripts/architecture/check-spm-graph.rb`)

## Checklist de refactor (MV)

- [ ] Remover VMs que só espelham environment ou `@State`
- [ ] Lógica de negócio fora do `body` → clients/domain
- [ ] View como coordenador fino de UI
- [ ] Split de `some View` grandes antes de novas abstrações

## Migração gradual

Ondas 1–4 concluídas (ver histórico no canvas CPR-006).

**Backlog:** `SharedUI` (formatos); catálogo de exercícios.

**Onda 5 — arquivo por view raiz**

- ~~`PROUpgradeView` + `PROUpgradeSubviews.swift`~~ ✅ (view raiz ~120 linhas)

Um arquivo por PR; reorder + extract + `/spdd-sync` quando norma mudar.
