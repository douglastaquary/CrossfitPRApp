# Views legadas em `CrossfitPR/` (fora do build)

## Situação atual

O target **CrossfitPR** (Xcode) compila apenas:

- `CrossfitPR/CrossfitPRApp.swift`
- `CrossfitPR/RootView.swift`
- Recursos: `Assets.xcassets`, `LaunchScreen.storyboard`, `Info.plist`

Toda a UI de produto vive nos pacotes SPM (`Packages/Categories`, `PRHistory`, `Insights`, etc.).

## Pastas duplicadas / legado

Estes caminhos **não** entram no `PBXSourcesBuildPhase` — são resquício da arquitetura pré-SPM (ViewModels, Core Data, stores locais):

| Legado | Substituto SPM |
|--------|----------------|
| `CrossfitPR/Views/*` | `Packages/SharedUI`, componentes em features |
| `CrossfitPR/Insights/InsightsView*.swift` | `Packages/Insights` |
| `CrossfitPR/RecordDetail/RecordDetailView*.swift` | `Packages/RecordDetail` |
| `CrossfitPR/NewPR/NewRecordView*.swift` | `Packages/PRHistory/NewPRRecordView.swift` |
| `CrossfitPR/Settings/SettingsView.swift` | `Packages/Settings` |
| `CrossfitPR/Onboarding/OnboardingView.swift` | `Packages/Onboarding` |
| `CrossfitPR/LaunchViewApp/LaunchView.swift` | `Packages/Launch/LaunchView.swift` |
| `CrossfitPR/Exercises/CategoryListView.swift` | `Packages/Categories` |
| `CrossfitPR/Service/*`, `CrossfitPR/Models/*` | `Packages/Application`, `Domain`, `Persistence` |

## Recomendações

1. **Não editar** legado para features novas — implementar sempre no pacote feature.
2. Antes de apagar: confirmar que nenhum script/ferramenta referencia esses arquivos.
3. Remoção futura pode ser um PR dedicado (“delete dead CrossfitPR monolith sources”) após backup/tag.

## Checklist antes de deletar

- [ ] `git tag pre-legacy-purge` ou branch de arquivo
- [ ] Confirmar `grep -r CrossfitPR/Views` no `project.pbxproj` vazio
- [ ] CI + UITests screenshots verdes
- [ ] README não referencia paths legados

## `Localizable.strings` na raiz do repo

Existem `en.lproj/` e `pt-BR.lproj/` na raiz e em `CrossfitPR/` que **não** alimentam o app atual. A fonte de verdade é:

`Packages/Localization/Sources/Localization/Resources/{en,pt-BR}.lproj/Localizable.strings`
