# SPDD — Structured-Prompt-Driven Development

Este projeto adota [Structured-Prompt-Driven Development (SPDD)](https://martinfowler.com/articles/structured-prompt-driven/) como método de engenharia assistida por AI.

> **Regra de ouro:** quando a realidade divergir da intenção, **corrija o prompt primeiro** — depois atualize o código.

## Estrutura de artefatos

```
spdd/
├── README.md           # Este arquivo
├── stories/            # Step 1 — User stories (requisitos de negócio)
├── analysis/           # Step 3 — Análise estratégica (/spdd-analysis)
└── prompt/             # Steps 4 & 6 — REASONS Canvas (Feat, Test, Fix, Refactor)
```

### Convenção de nomes

```
{ID}-{TIMESTAMP}-[{ACTION}]-{scope}-{description}.md
```

| Campo | Exemplo | Descrição |
|-------|---------|-----------|
| ID | `CPR-001` | Identificador do épico/feature |
| TIMESTAMP | `202605201200` | `YYYYMMDDHHmm` |
| ACTION | `[Feat]`, `[Fix]`, `[Test]`, `[Refactor]`, `[Analysis]` | Tipo de artefato |
| scope | `domain`, `persistence`, `insights`, `app` | Área afetada (opcional) |
| description | `baseline-pr-tracking` | kebab-case, < 10 palavras |

## Workflow SPDD (6 passos)

```mermaid
flowchart LR
    S1[1. Story] --> S2[2. Clarificar]
    S2 --> S3[3. /spdd-analysis]
    S3 --> S4[4. /spdd-reasons-canvas]
    S4 --> S5[5. /spdd-generate]
    S5 --> S6[6. Testes]
    S5 --> VR[Verificação]
    VR --> CR[Code Review]
    CR -->|Lógica| PU[/spdd-prompt-update]
    CR -->|Refactor| SY[/spdd-sync]
    PU --> S5
    SY --> S4
```

| Passo | Comando Cursor | Entrada | Saída |
|-------|----------------|---------|-------|
| 1 | `/spdd-story` (opcional) | Ideia de enhancement | `spdd/stories/*.md` |
| 2 | Manual | User story | Alinhamento de escopo e DoD |
| 3 | `/spdd-analysis` | Story | `spdd/analysis/*.md` |
| 4 | `/spdd-reasons-canvas` | Analysis | `spdd/prompt/*-[Feat]*.md` |
| 5 | `/spdd-generate` | REASONS Canvas | Código Swift |
| 6 | Template de teste | Canvas + test prompt | `spdd/prompt/*-[Test]*.md` + testes |

## REASONS Canvas (7 dimensões)

| Dimensão | Foco | Pergunta-chave |
|----------|------|----------------|
| **R** Requirements | Intenção | Que problema resolvemos? Qual o DoD? |
| **E** Entities | Domínio | Quais entidades e relações? |
| **A** Approach | Estratégia | Como vamos resolver? |
| **S** Structure | Arquitetura | Onde encaixa no sistema? |
| **O** Operations | Execução | Quais tarefas concretas? |
| **N** Norms | Governança | Quais padrões seguir? |
| **S** Safeguards | Limites | O que é proibido? |

## Loop bidirecional prompt ↔ código

| Tipo de mudança | Fluxo | Comando |
|-----------------|-------|---------|
| Requisito de negócio mudou | requirements → prompt → code | `/spdd-prompt-update` → `/spdd-generate` |
| Refactor sem mudar comportamento | code → prompt | `/spdd-sync` |
| Bug de lógica | prompt primeiro, depois code | `/spdd-prompt-update` → `/spdd-generate` |

## Índice de artefatos (sincronizado 2026-05-20)

### CPR-001 — Baseline PR tracking + insights

| Tipo | Arquivo |
|------|---------|
| Story | [`stories/CPR-001-baseline-pr-tracking-and-insights.md`](stories/CPR-001-baseline-pr-tracking-and-insights.md) |
| Analysis | [`analysis/CPR-001-20260520-[Analysis]-baseline-pr-tracking-and-insights.md`](analysis/CPR-001-20260520-%5BAnalysis%5D-baseline-pr-tracking-and-insights.md) |
| Feat | [`prompt/CPR-001-20260520-[Feat]-baseline-pr-tracking-and-insights.md`](prompt/CPR-001-20260520-%5BFeat%5D-baseline-pr-tracking-and-insights.md) |
| Test | [`prompt/CPR-001-20260520-[Test]-baseline-pr-tracking-and-insights.md`](prompt/CPR-001-20260520-%5BTest%5D-baseline-pr-tracking-and-insights.md) |

### CPR-002 — StoreKit 2 PRO

| Tipo | Arquivo |
|------|---------|
| Story | [`stories/CPR-002-storekit-pro-subscription.md`](stories/CPR-002-storekit-pro-subscription.md) |
| Analysis | [`analysis/CPR-002-20260520-[Analysis]-storekit-pro-subscription.md`](analysis/CPR-002-20260520-%5BAnalysis%5D-storekit-pro-subscription.md) |
| Feat | [`prompt/CPR-002-20260520-[Feat]-storekit-pro-subscription.md`](prompt/CPR-002-20260520-%5BFeat%5D-storekit-pro-subscription.md) |
| Test | [`prompt/CPR-002-20260520-[Test]-storekit-pro-subscription.md`](prompt/CPR-002-20260520-%5BTest%5D-storekit-pro-subscription.md) |

### CPR-003 — Camada Application

| Tipo | Arquivo |
|------|---------|
| Story | [`stories/CPR-003-spm-application-layer.md`](stories/CPR-003-spm-application-layer.md) |
| Feat (sync) | [`prompt/CPR-003-20260520-[Feat]-spm-application-layer.md`](prompt/CPR-003-20260520-%5BFeat%5D-spm-application-layer.md) |

### CPR-004 — Feature packages + WorkoutEngine

| Tipo | Arquivo |
|------|---------|
| Story | [`stories/CPR-004-spm-feature-packages-workout-engine.md`](stories/CPR-004-spm-feature-packages-workout-engine.md) |
| Feat (sync) | [`prompt/CPR-004-20260520-[Feat]-spm-feature-packages-workout-engine.md`](prompt/CPR-004-20260520-%5BFeat%5D-spm-feature-packages-workout-engine.md) |

## Terminologia atual (REASONS E)

| Termo | Código |
|-------|--------|
| WorkoutEngine | Pacote `WorkoutEngine`, struct `WorkoutEngine`, categoria `.workoutEngine` |
| Client de insights | `WorkoutEngineClient` (Application) |
| ~~platô / WorkoutAnalysis~~ | Renomeado em CPR-004 |

## Ferramentas

- **Skill SPDD:** [`.cursor/skills/crossfitpr-spdd/SKILL.md`](../.cursor/skills/crossfitpr-spdd/SKILL.md)
- **Skill Design:** [`.cursor/skills/design/skill-design.md`](../.cursor/skills/design/skill-design.md) — layout/cores baseline
- **Skill iOS:** [`.cursor/skills/ios-development-skill/skill-ios.md`](../.cursor/skills/ios-development-skill/skill-ios.md)
- **Cursor rules:** `spdd-governance.mdc`, `ios-swift-development.mdc`, `design-preservation.mdc`
- **Cursor commands:** `.cursor/commands/spdd-*.md`
- **Regra global:** `.cursor/rules/spdd-governance.mdc`
- **Guia AI:** [`AGENTS.md`](../AGENTS.md)
- **CLI openspdd (opcional):** [github.com/gszhangwei/open-spdd](https://github.com/gszhangwei/open-spdd)

## Referências

- [Structured-Prompt-Driven Development — Martin Fowler](https://martinfowler.com/articles/structured-prompt-driven/)
