# Arquitetura MV — CrossfitPR

Este documento é o **padrão oficial de UI** do projeto, junto com [`ARCHITECTURE.md`](ARCHITECTURE.md) (SPM/camadas) e o workflow [`SPDD-WORKFLOW.md`](SPDD-WORKFLOW.md).

## O que é “MV” aqui

- **Model:** entidades e regras em `Domain`; persistência e StoreKit nos adapters; orquestração reativa nos **Clients** (`Application`).
- **View:** SwiftUI fina — estado local, injeção de clients, subviews explícitas.

**Não** usamos MVVM por padrão. “Sem ViewModels” nos guias antigos **significa** adotar MV moderno (Dimillian / Ricouard), não ausência de arquitetura.

## Referências externas

| Fonte | Uso |
|-------|-----|
| [Dimillian — swiftui-view-refactor SKILL](https://github.com/Dimillian/Skills/blob/main/swiftui-view-refactor/SKILL.md) | Ordem de view, subviews, árvore estável |
| [mv-patterns.md](https://github.com/Dimillian/Skills/blob/main/swiftui-view-refactor/references/mv-patterns.md) | Quando evitar ViewModel |
| [Forget MVVM (2025)](https://dimillian.medium.com/swiftui-in-2025-forget-mvvm-262ff2bbd2ed) | Contexto |

Adaptação CrossfitPR: `.cursor/skills/swiftui-mv/SKILL.md`

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

## Migração

Estado: **norma adotada**; código legado pode ter `private var section: some View` extensos.

Plano: refatorar por feature package, um PR por tela grande (lista em `mv-patterns-crossfitpr.md`).

Artefato SPDD: `spdd/prompt/CPR-006-*-mv-swiftui-architecture-standard.md`
