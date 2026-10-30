# Review visual — Insights hub (CPR-011)

Na `main` (PR #37).

## Como regenerar os prints

Com o simulador saudável (se o CoreSimulator travar: reinicie o Mac ou `killall Simulator` + abra o Simulator pelo Xcode):

```bash
./scripts/generate-xcodeproj.sh
./scripts/configure-spm-xcode14.sh   # só Xcode 14.2 local
# Não use CODE_SIGNING_ALLOWED=NO — o XCUITest deixa de ver a UI no simulador.
./scripts/capture-readme-media-auto.sh
```

Os UITests usam `UITEST_SEED_SCENARIO`:

| Arquivo | Tier | Seed |
|---------|------|------|
| `insights-free.png` | free | `freeTeaser` |
| `insights-free-empty.png` | free | `empty` |
| `insights-pro.png` | pro | `proRich` |
| `insights-pro-empty.png` | pro | `empty` |
| `insights-elite.png` | elite | `eliteRich` |
| `insights-elite-empty.png` | elite | `empty` |

Watch: `./scripts/capture-watch-readme-screenshots.sh`

## O que validar

1. Free com dados: resumo + insight engine + gráfico + CTA PRO/Elite (sem parede de vendas)
2. PRO: resumo → última sessão/CAL/FC → percepções → coach → ranking/charts
3. Elite: assessment + limiting factor visíveis
4. Empty: copy curta + CTA registrar PR
5. Título da tab/nav: **Percepções** (pt-BR) / **Insights** (en)
