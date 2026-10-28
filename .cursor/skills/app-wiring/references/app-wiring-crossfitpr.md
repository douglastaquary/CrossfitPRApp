# App wiring — CrossfitPR

Norma interna para **shell do app**, grafo de dependências e lifecycle global (CPR-006 + composition root).

## Intenção

- TabView + gates (splash, onboarding, rede) + sheets feature-local.
- Dependências compartilhadas instaladas **uma vez** no root.
- Feature views consomem só o necessário via `@EnvironmentObject`; resto permanece local.

## Estrutura atual

```
CrossfitPRApp (@main)
  └── AppLaunchContainer          # splash (LaunchScreenView)
        └── LaunchView            # rede + onboarding gate
              └── MainTabView     # 4 tabs (Categories, PRHistory, Insights, Settings)
```

| Camada | Arquivo / pacote | Papel |
|--------|------------------|--------|
| Composition root | `Application/AppEnvironment.swift` | Monta clients + `bootstrapServices()` |
| Injeção UI | `CrossfitPR/AppDependencyGraph.swift` | `withCrossfitPRDependencyGraph` |
| Tabs | `CrossfitPR/RootView.swift` (`MainTabView`) | Seleção de tab, IDs de acessibilidade |
| Gate | `Launch/LaunchView.swift` | Rede, onboarding |
| Features | `Packages/*` | Views MV — **sem** wiring |

## Escolha de dependências

| Mecanismo | Quando (CrossfitPR) |
|-----------|---------------------|
| `@EnvironmentObject` client | Dados/ações compartilhados (`PersonalRecordClient`, …) — **padrão iOS 16** |
| `@State` / `@Binding` | Sheets, seleção, formulários locais |
| `@SceneStorage` | Tab selecionada no shell |
| Inicializer | Subviews com dados/ closures explícitos (MV) |
| `@Environment` | Preferências SwiftUI (`dismiss`, etc.) |

Não promover dependência ao environment só para evitar 1–2 parâmetros no `init`.

## Modifier de grafo (obrigatório no root)

```swift
AppLaunchContainer { MainTabView() }
    .brandTint()
    .withCrossfitPRDependencyGraph(environment.value)
```

O modifier:

- Aplica todos os `.environmentObject` dos clients + `LocalNotificationManager`.
- Executa `await environment.bootstrapServices()` uma vez (StoreKit, transações, etc.).

**Não** adicionar feature state nem regras de negócio no modifier.

## Lifecycle `.task(id:)`

- Hoje: bootstrap único no root.
- Se no futuro houver “conta” ou client trocável: usar `.task(id: …)` no **modifier** para re-semejar serviços — nunca espalhar por tabs.

## Sheets e navegação

- **Sheets PRO / upgrade:** apresentados pela feature (`WorkoutInsightsView`, `SettingsView`) com `@State` local — OK.
- Preferir enum `SheetDestination` quando uma tab tiver **vários** sheets centralizados.
- Cada tab usa `NavigationStack` onde necessário (ex.: Settings); Categories/PRHistory/Insights conforme pacote.

## SwiftData / persistência

CrossfitPR **não** instala `ModelContainer` no root. Persistência:

`View → Client → Repository (Persistence) → Domain`

## Checklist PR (wiring)

- [ ] Clients injetados só via `withCrossfitPRDependencyGraph` (ou equivalente único no app target)
- [ ] Nenhum `AppEnvironment.make()` fora de `CrossfitPRApp`
- [ ] Feature não importa Persistence/StoreKit diretamente
- [ ] Bootstrap async não duplicado em views filhas
- [ ] MV preservado: sem ViewModel só para wiring

## Quando revisar esta norma

- Novo client global → atualizar `AppEnvironment`, modifier, docs, testes `AppEnvironmentTests`.
- Nova tab → `MainTabView` + Design canvas se mudar baseline.
