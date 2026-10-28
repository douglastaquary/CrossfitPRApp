# QA automatizado — CrossfitPR

## UI — localização (pt-BR / en)

Target `CrossfitPRUITests` → `AppLocalizationQATests`:

| Teste | O que valida |
|-------|----------------|
| `testPortugueseMainTabsAndScreens` | Tabs e navigation bars em PT |
| `testEnglishMainTabsAndScreens` | Tabs e navigation bars em EN |
| `testOnboardingCTAInEnglishAndPortuguese` | CTA + `accessibilityIdentifier` `onboarding.cta` |

**Launch flags** (app under test):

| Environment | Efeito |
|-------------|--------|
| `UITEST_SKIP_SPLASH=1` | Pula splash animado |
| `UITEST_SKIP_ONBOARDING=1` | Marca onboarding como concluído |
| `UITEST_FORCE_ONBOARDING=1` | Força tela de onboarding |

Idioma: `-AppleLanguages (en)` ou `(pt-BR)` via `XCUIApplication.launchArguments`.

**Accessibility IDs:** `tab.categories`, `tab.records`, `tab.insights`, `tab.settings`.

## Unit — catálogo de exercícios

`Packages/Localization/Tests/LocalizationTests/WorkoutCatalogLocalizationTests.swift` — cada `WorkoutCategory.titleKey` existe em `en` e `pt-BR`.

## Local

```bash
chmod +x scripts/run-qa.sh
./scripts/run-qa.sh
```

## CI

Workflow `.github/workflows/ios.yml` roda build + `AppLocalizationQATests` (screenshots README ficam de fora).

SPM no CI usa `XCLocalSwiftPackageReference` (`relativePath = .` → `Package.swift` na raiz). **Não** commitar `file:///Users/...` no `project.pbxproj`. Xcode 14.2 local: `./scripts/configure-spm-xcode14.sh`.

## Screenshots README

`ReadmeScreenshotsUITests` permanece manual/optional — força PT implícito no simulador; não faz parte do gate de CI.
