# Review visual — Insights hub (CPR-011)

Galeria canônica com dados: [`REVIEW-TIERS.md`](REVIEW-TIERS.md) → `review/{free,pro,elite}/insights-*.png`.

```bash
export CROSSFITPR_DOCS_ROOT="$(pwd)/docs"
xcodebuild test -scheme CrossfitPR -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
  -only-testing:CrossfitPRUITests/ReadmeScreenshotsUITests/testCaptureTierScreenGallery
```

## O que validar

1. Free: teaser + insight + gráfico + CTA (sem empty)
2. PRO: resumo → sessão → coach → ranking
3. Elite: assessment + limiting factor
4. Título: **Percepções** (pt-BR) / **Insights** (en)
