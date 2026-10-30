# Review visual — Free / PRO / Elite (com dados)

Galeria gerada por `ReadmeScreenshotsUITests.testCaptureTierScreenGallery`.

```bash
./scripts/generate-xcodeproj.sh
./scripts/configure-spm-xcode14.sh   # Xcode 14.2
export CROSSFITPR_DOCS_ROOT="$(pwd)/docs"
xcodebuild test -scheme CrossfitPR -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
  -only-testing:CrossfitPRUITests/ReadmeScreenshotsUITests/testCaptureTierScreenGallery
```

Seeds: Free=`freeTeaser`, PRO=`proRich`, Elite=`eliteRich`.

## Free

| Tela | Preview |
|------|---------|
| Exercícios | ![](review/free/categories.png) |
| Meus PRs | ![](review/free/records.png) |
| Detalhe do PR | ![](review/free/record-detail.png) |
| Percepções (topo) | ![](review/free/insights-top.png) |
| Percepções (meio) | ![](review/free/insights-mid.png) |
| Percepções (fim) | ![](review/free/insights-bottom.png) |
| Ajustes | ![](review/free/settings.png) |

## PRO

| Tela | Preview |
|------|---------|
| Exercícios | ![](review/pro/categories.png) |
| Meus PRs | ![](review/pro/records.png) |
| Detalhe do PR | ![](review/pro/record-detail.png) |
| Percepções (topo) | ![](review/pro/insights-top.png) |
| Percepções (meio) | ![](review/pro/insights-mid.png) |
| Percepções (fim) | ![](review/pro/insights-bottom.png) |
| Ajustes | ![](review/pro/settings.png) |

## Elite

| Tela | Preview |
|------|---------|
| Exercícios | ![](review/elite/categories.png) |
| Meus PRs | ![](review/elite/records.png) |
| Detalhe do PR | ![](review/elite/record-detail.png) |
| Percepções (topo) | ![](review/elite/insights-top.png) |
| Percepções (meio) | ![](review/elite/insights-mid.png) |
| Percepções (fim) | ![](review/elite/insights-bottom.png) |
| Ajustes | ![](review/elite/settings.png) |

## O que olhar

1. Free: teaser com insight real + gráfico + CTA (sem parede de vendas)
2. PRO: resumo → sessão/CAL/FC → percepções → coach → ranking
3. Elite: assessment + limiting factor além do PRO
4. PRs/Exercícios populados de forma coerente entre tiers
5. Settings reflete o tier ativo
