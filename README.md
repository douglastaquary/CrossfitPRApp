# CrossfitPR 🏋️

**Registre seus PRs, veja sua evolução e entenda quando vale a pena ir mais pesado.**

CrossfitPR é um app iOS feito para quem treina CrossFit e quer histórico claro de Personal Records — sem planilha, sem adivinhar se aquele snatch de ontem foi PR ou não. Quatro abas, fluxo direto: categorias → PRs → insights → ajustes.

---

## Demo

<p align="center">
  <img src="docs/media/crossfitpr-demo.gif" width="320" alt="Demonstração do CrossfitPR">
</p>

> GIF e prints vêm de `docs/media/` e `docs/screenshots/`. Para atualizar após mudanças de UI, rode `./scripts/capture-readme-media-auto.sh` (Xcode 14.2: `./scripts/configure-spm-xcode14.sh` na primeira vez).

---

## Telas

<p align="center">
  <img src="docs/screenshots/onboarding.png" width="180" alt="Onboarding">
  <img src="docs/screenshots/categories.png" width="180" alt="Categorias">
  <img src="docs/screenshots/records-empty.png" width="180" alt="Meus PRs">
  <img src="docs/screenshots/insights-free.png" width="180" alt="Insights">
  <img src="docs/screenshots/pro-upgrade.png" width="180" alt="CrossfitPR PRO">
  <img src="docs/screenshots/settings.png" width="180" alt="Ajustes">
</p>

---

## O que você ganha

### Grátis — registrar e acompanhar o básico

- **PRs por categoria** — Barbell, Gymnastic, Endurance e mais
- **Histórico** — lista dos seus registros com detalhe por exercício
- **Insights essenciais** — visão inicial da evolução (teaser do que o PRO desbloqueia)
- **Unidade kg ou lb** — escolha em Ajustes
- **Offline-first** — dados salvos no aparelho; sync com iCloud quando disponível
- **Onboarding rápido** — splash + boas-vindas, já cai nas tabs

### CrossfitPR PRO — menos que um café por mês ☕

O PRO é para quem quer **interpretação**, não só números na tela:

| Benefício | Por que importa |
|-----------|-----------------|
| **Análises inteligentes dos treinos** | Padrões no seu histórico explicados em linguagem clara — o que melhorou, o que travou |
| **Motor de treino (WorkoutEngine)** | Estagnação, tendências e gatilhos para destravar PRs |
| **Gráficos de progressão** | Evolução por movimento, não só o último valor |
| **Metas no seu ritmo** | Recomendações alinhadas ao que você já registrou |
| **Exportar histórico** | Leve seus dados para onde quiser |

#### Por que a assinatura PRO inclui IA?

Interpretar meses de PRs com contexto (volume, platôs, categorias diferentes) **não roda de graça**: modelos de IA em nuvem têm custo por análise — tokens, inferência e manutenção do pipeline que transforma seu histórico em texto útil.

**Parte do valor do PRO cobre exatamente isso:** infraestrutura de IA para ler seus dados de treino com segurança e devolver análises que um resumo local não consegue dar. No plano Free você continua registrando PRs e vendo o básico; no PRO você financia análises mais profundas — como ter um coach olhando seus números entre os treinos.

> **Transparência:** hoje o app já usa heurísticas locais (WorkoutEngine) e destrava a experiência PRO completa na interface. A camada de **IA generativa** para análises detalhadas está no roadmap ([CPR-005](spdd/analysis/CPR-001-20260520-%5BAnalysis%5D-baseline-pr-tracking-and-insights.md)); a assinatura PRO já reflete esse custo futuro e o posicionamento do produto.

---

## Requisitos

| Item | Versão |
|------|--------|
| iOS | 16.0+ |
| Xcode | 14.2+ (Swift 5.7) ou Xcode 16+ |
| Conta Apple Developer | Recomendada para CloudKit / TestFlight |

---

## Rodar o projeto

```bash
git clone https://github.com/douglastaquary/CrossfitPR.git
cd CrossfitPR
open CrossfitPR.xcodeproj
```

1. Em **Signing & Capabilities**, escolha seu Team (`com.douglast.CrossfitPR`).
2. Simulador **iPhone 14 Pro** (ou superior) → `⌘R`.

**Linha de comando:**

```bash
xcodebuild -scheme CrossfitPR \
  -destination 'platform=iOS Simulator,name=iPhone 14 Pro' build

cd Packages/Domain && swift test
cd ../WorkoutEngine && swift test
```

**Atualizar GIF e screenshots do README:**

```bash
./scripts/configure-spm-xcode14.sh   # Xcode 14.2 — aponta SPM local file URL
./scripts/capture-readme-media-auto.sh
```

---

## Arquitetura (SPDD + SPM)

Desenvolvimento guiado por [SPDD](https://martinfowler.com/articles/structured-prompt-driven/) — intenção no canvas, código rastreável. Camadas em [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md); UI **MV** em [`docs/MV-ARCHITECTURE.md`](docs/MV-ARCHITECTURE.md) (CPR-006, [Dimillian](https://github.com/Dimillian/Skills/blob/main/swiftui-view-refactor/SKILL.md)).

```
CrossfitPR/              # App shell (SwiftUI, 4 tabs)
Package.swift            # Pacotes locais (monorepo SPM)
Packages/
├── Domain               # Entidades, ProFeature, ports
├── Persistence          # JSON local + CloudKit (best-effort)
├── Subscription         # StoreKit 2
├── WorkoutEngine        # Insights heurísticos
├── Application          # Clients + AppEnvironment
├── Localization         # Strings + AppDesign
├── SharedUI             # Componentes compartilhados
├── Launch / Onboarding  # Splash + primeira execução
├── Categories           # Exercícios por categoria
├── PRHistory            # Lista e novo PR
├── RecordDetail         # Detalhe e percentuais
├── Insights             # Free teaser + PRO completo
├── PROUpgrade           # Assinatura
└── Settings             # Preferências
```

**Padrões:** SwiftUI **MV** (Model + View; sem ViewModels); `@EnvironmentObject` clients; copy/cores via `Strings.*` e `AppDesign.*`.

---

## Idiomas

Português (pt-BR) e inglês — `Packages/Localization/Sources/Localization/Resources/`.

---

## Contribuir

1. Fork → branch `feature/...`
2. Workflow SPDD: story → analysis → canvas → código (ID `CPR-NNN`)
3. Pull Request com test plan

---

## Licença

[MIT](LICENSE)

---

**Douglas Taquary** · [@douglastaquary](https://github.com/douglastaquary)

<p align="center"><i>Feito com carinho para a comunidade CrossFit</i></p>
