# QA automatizado — CrossfitPR

## UI — localização (pt-BR / en)

Target `CrossfitPRUITests` → `AppLocalizationQATests`:

| Teste | O que valida |
|-------|----------------|
| `testPortugueseMainTabsAndScreens` | Tabs e navigation bars em PT |
| `testEnglishMainTabsAndScreens` | Tabs e navigation bars em EN |
| `testOnboardingCTAInEnglishAndPortuguese` | CTA + `onboarding.cta` |
| `testInsightsPROUpgradeSheetPortuguese` | Teaser → sheet PRO → `pro.upgrade.close` |
| `testInsightsPROUpgradeSheetEnglish` | Idem em EN |
| `testSettingsTrackingSectionSmokePortuguese` | Ajustes + label “Unidade de peso” |
| `testProCoachSectionPortuguese` | Tier PRO mock + `insights.coach.section` |

**Launch flags** (app under test):

| Environment | Efeito |
|-------------|--------|
| `UITEST_SKIP_SPLASH=1` | Pula splash; **modo UI test** (ignora gate de rede no CI) |
| `UITEST_SKIP_ONBOARDING=1` | Marca onboarding como concluído |
| `UITEST_FORCE_ONBOARDING=1` | Força tela de onboarding |
| `UITEST_SUBSCRIPTION_TIER` | `free` \| `pro` \| `elite` — mock StoreKit no simulador |
| `UITEST_PURCHASE_BEHAVIOR` | `succeed` \| `cancel` \| `fail` \| `pending` — resultado da compra mock |
| `UITEST_USE_STOREKIT` | `1` — StoreKit real + Products.storekit (manual) |
| `OPENAI_API_KEY` | Só builds locais/prod manual — cloud coach; **nunca** no CI |

Idioma: `-AppleLanguages (en)` ou `(pt-BR)` via `XCUIApplication.launchArguments` (e opcionalmente `AppleLanguages` / `AppleLocale` em `launchEnvironment`).

**Wiring:** `AppEnvironment.make()` roda de forma **lazy** no primeiro render do app (`CrossfitPRApp`), para flags `UITEST_*` estarem visíveis no processo antes do composition root.

**Accessibility IDs:** `tab.categories`, `tab.records`, `tab.insights`, `tab.settings`, `insights.teaser.pro.cta`, `insights.coach.section`, `pro.upgrade.close`, `pro.upgrade.scroll`, `pro.upgrade.continue.payment`, `pro.upgrade.restore`, `pro.upgrade.product.proMonthly`, `pro.upgrade.success.title`, `pro.upgrade.error.title`.

## Pagamentos (PRO / Elite)

| Teste | Arquivo |
|-------|---------|
| Unit PaymentFlow | `Packages/Subscription/Tests/.../PaymentFlowTests.swift` |
| UI PaymentFlow | `CrossfitPRUITests/PaymentFlowUITests.swift` |

```bash
./scripts/test-payments.sh
```

Detalhes: [`STOREKIT-PAYMENTS.md`](STOREKIT-PAYMENTS.md).

## Unit — catálogo de exercícios

`Packages/Localization/Tests/LocalizationTests/WorkoutCatalogLocalizationTests.swift` — cada `WorkoutCategory.titleKey` existe em `en` e `pt-BR`.

## Unit — coach (CPR-007)

| Pacote | Suite |
|--------|--------|
| `Packages/Coaching` | `CoachingContextBuilderTests` — snapshot + budget |
| `Packages/Application` | `CoachingClientTests` — cache, tier Free |

Sem LLM real no CI — apenas `MockCrossFitCoachAdapter`.

## Local

```bash
chmod +x scripts/run-qa.sh
./scripts/run-qa.sh
```

## CI

Workflow `.github/workflows/ios.yml` roda build + **todos** os testes acima em `AppLocalizationQATests`. Screenshots README ficam de fora.

SPM no CI: [`CI.md`](CI.md). Pipeline: [`scripts/ci-modern.sh`](../scripts/ci-modern.sh).

## Screenshots README

`ReadmeScreenshotsUITests` — manual/local; pt-BR; onboarding completo (sem `UITEST_SKIP_ONBOARDING`).

```bash
./scripts/capture-readme-media-auto.sh
```

Requer Mac + Xcode + simulador iOS. Binários em `docs/screenshots/` e `docs/media/` quando regenerados.
