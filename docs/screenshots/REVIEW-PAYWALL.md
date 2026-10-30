# Review — Paywall (variante B / CPR-014)

Produção: **B** (`PROUpgradeLayoutVariant` → `.b`).

```bash
export CROSSFITPR_DOCS_ROOT="$(pwd)/docs"
xcodebuild test -scheme CrossfitPR -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
  -only-testing:CrossfitPRUITests/ReadmeScreenshotsUITests/testCapturePaywallVariants
```

## B — Passos

![](paywall-variant-b.png)

Badge competidor · plano PRO/Elite · Mensal/Anual · preço · CTA · tabela Free/PRO/Elite.
(`pro-upgrade.png` é cópia da mesma captura para scripts/ASC.)
