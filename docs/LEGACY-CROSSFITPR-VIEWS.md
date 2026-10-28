# Legado `CrossfitPR/` — removido

> **Tag de arquivo:** `pre-legacy-purge` (estado imediatamente antes da limpeza).

## App shell atual (único conteúdo em `CrossfitPR/`)

| Arquivo / pasta | Função |
|-----------------|--------|
| `CrossfitPRApp.swift` | `@main`, `AppEnvironment`, injection |
| `RootView.swift` | `MainTabView` (4 tabs) |
| `Assets.xcassets` | Ícones, splash `216`, imagens |
| `Base.lproj/LaunchScreen.storyboard` | Launch storyboard do target |
| `Configuration/Products.storekit` | StoreKit local (testes de assinatura) |
| `Info.plist`, `CrossfitPR.entitlements` | Configuração do target |

Toda UI e domínio de produto estão em **`Packages/*`** (SPM).

## O que foi removido

Monólito pré-SPM: ViewModels, Core Data (`DB/`, `*.xcdatamodeld`), `Views/`, `Insights/`, `Service/`, etc.

Cópias órfãs de strings: `en.lproj/` e `pt-BR.lproj` na **raiz do repo** e dentro de `CrossfitPR/`.

**Fonte de verdade de localização:** `Packages/Localization/Sources/Localization/Resources/{en,pt-BR}.lproj/`.

## Recuperar código antigo

```bash
git checkout pre-legacy-purge -- CrossfitPR/Views   # exemplo
```
