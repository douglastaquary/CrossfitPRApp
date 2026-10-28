# MV Patterns — CrossfitPR

Síntese de [mv-patterns.md](https://github.com/Dimillian/Skills/blob/main/swiftui-view-refactor/references/mv-patterns.md) aplicada ao app.

## Stack padrão (Modern SwiftUI MV)

| Camada | Onde | Exemplo |
|--------|------|---------|
| **Model** | `Domain`, engines, repositories | `PersonalRecord`, `WorkoutEngine`, ports |
| **Application services** | `Packages/Application` | `PersonalRecordClient.fetchRecords()` |
| **View** | `Packages/<Feature>/` | `PRHistoriesListView`, subviews |

Fluxo de dados típico:

```
User action → View (private func) → Client (@MainActor) → Repository / Engine → Domain
                ↑________________ @Published / objectWillChange ________________|
```

## Quando **não** usar ViewModel

- Espelhar `records` do `PersonalRecordClient` em um VM.
- Encapsular só `@State` de sheet/navigation.
- Substituir `.task { await client.fetch… }` por VM “loader”.
- View grande → **split em subviews**, não nova camada VM.

## Quando ViewModel *poderia* ser discutido (raro)

- Bridge explícita para API não-SwiftUI (legacy).
- Pedido explícito do produto **e** canvas CPR aprovado.

Default do projeto: **recusar** e aplicar MV.

## Exemplo CrossfitPR (Insights)

```swift
public struct WorkoutInsightsView: View {
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @EnvironmentObject private var subscriptionClient: SubscriptionClient
    @State private var isPresentingPROUpgrade = false

    public var body: some View {
        NavigationStack {
            insightsContent
                .navigationTitle(Strings.Screen.insights)
                .navigationBarTitleDisplayMode(.large)
                .task(id: personalRecordClient.records.count) {
                    await loadRecordsIfNeeded()
                }
                .refreshable { await personalRecordClient.fetchRecords() }
                .sheet(isPresented: $isPresentingPROUpgrade) {
                    PROUpgradeView()
                }
        }
        .brandTint()
    }

    @ViewBuilder
    private var insightsContent: some View {
        if subscriptionClient.currentTier == .pro {
            InsightsViewPRO()
        } else {
            InsightsTeaserView(isPresentingPROUpgrade: $isPresentingPROUpgrade)
        }
    }

    private func loadRecordsIfNeeded() async {
        guard personalRecordClient.records.isEmpty else { return }
        await personalRecordClient.fetchRecords()
    }
}
```

## Checklist de PR (views)

- [ ] Sem ViewModel novo
- [ ] Ações fora do `body` (métodos privados)
- [ ] Strings/cores via `Strings` / `AppDesign`
- [ ] Seções grandes extraídas como `View` struct
- [ ] Comportamento e layout unchanged (refactor) ou canvas Design (feature)
- [ ] Testes de domínio/client se lógica mudou

## Migração gradual

Prioridade sugerida (arquivos com muitos `private var …: some View`):

1. ~~`PROUpgradeView.swift`~~ ✅ (subviews extraídas)
2. ~~`InsightsTeaserView.swift`~~ ✅
3. `InsightsViewPRO.swift`
4. `NewPRRecordView.swift`

Um arquivo por PR; cada um: reorder + extract structs + `/spdd-sync`.
