# Arquitetura MV — CrossfitPR

Este documento é o **padrão oficial de UI** do projeto, junto com [`ARCHITECTURE.md`](ARCHITECTURE.md) (SPM/camadas) e o workflow [`SPDD-WORKFLOW.md`](SPDD-WORKFLOW.md).

## O que é “MV” aqui

- **Model:** entidades e regras em `Domain`; persistência e StoreKit nos adapters; orquestração reativa nos **Clients** (`Application`).
- **View:** SwiftUI fina — estado local, injeção de clients, subviews explícitas.

**Não** usamos MVVM por padrão. “Sem ViewModels” significa **MV SwiftUI moderno** (clients + `@State`), não ausência de arquitetura.

## Referências no repositório

| Documento | Uso |
|-----------|-----|
| [`.cursor/skills/swiftui-mv/SKILL.md`](../.cursor/skills/swiftui-mv/SKILL.md) | Ordem de view, subviews, workflow |
| [`mv-patterns-crossfitpr.md`](../.cursor/skills/swiftui-mv/references/mv-patterns-crossfitpr.md) | Quando evitar ViewModel, checklist PR/CI |
| Canvas **CPR-006** | Norms oficiais SPDD |

Copy de UI: `Strings.*` + [`LOCALIZATION.md`](LOCALIZATION.md) (en / pt-BR).

## Clients = serviços de aplicação

| Client | Responsabilidade MV |
|--------|---------------------|
| `PersonalRecordClient` | CRUD PRs, expõe `@Published records` |
| `SubscriptionClient` | Tier PRO, produtos, compra |
| `SettingsClient` | Preferências, gate onboarding |
| `WorkoutEngineClient` | Insights derivados dos PRs |

Injeção no app shell:

```swift
.environmentObject(environment.personalRecordClient)
.environmentObject(environment.subscriptionClient)
// …
```

Views **não** instanciam repositories nem StoreKit diretamente.

## Regras de implementação (resumo)

1. **SPDD primeiro** — canvas para feature nova; `/spdd-sync` após refactor MV.
2. **Design preservado** — refactor MV não muda tabs, cores, fluxos (ver skill Design).
3. **Extraia subviews** antes de criar ViewModel.
4. **Teste Model**, não ViewModel: `Packages/Domain`, `WorkoutEngine`, testes de client quando existirem.

## Code review e CI

- PRs: workflow [`pr-architecture-review.yml`](../.github/workflows/pr-architecture-review.yml) (advisory).
- Detalhes: [`CI.md`](CI.md).

## Migração

Estado: **norma adotada** (CPR-006). Backlog pontual em `mv-patterns-crossfitpr.md`.

Artefato SPDD: `spdd/prompt/CPR-006-*-mv-swiftui-architecture-standard.md`
