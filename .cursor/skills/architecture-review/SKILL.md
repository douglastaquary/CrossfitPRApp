---
name: crossfitpr-architecture-review
description: >-
  Code review de arquitetura CrossfitPR — MV, grafo SPM, SwiftLint, SPDD.
  Use em PRs, CI, ou quando o usuário pedir review arquitetural.
---

# Architecture Review — CrossfitPR

## Precedência

**SPDD → Design → MV → iOS → SPM**

## Fontes (mesmo checklist que o CI)

| Fonte | Uso |
|-------|-----|
| `.cursor/skills/swiftui-mv/references/mv-patterns-crossfitpr.md` | MV, ViewModel, checklist PR |
| `docs/ARCHITECTURE.md` | Grafo SPM, camadas |
| `docs/MV-ARCHITECTURE.md` | Clients, injeção |
| `spdd/prompt/CPR-006-*` | Norms N-01…N-07 |
| `.github/prompts/architecture-review.md` | Prompt do job LLM no GHA |

## Scripts (determinísticos)

```bash
ruby scripts/architecture/check-spm-graph.rb
bash scripts/architecture/check-mv-conventions.sh
swiftlint lint --config .swiftlint.yml   # opcional local (macOS)
bash scripts/architecture/run-static-checks.sh
```

- Modo **advisory** (default): scripts saem 0; findings vão para `architecture-report.md`.
- Modo **strict**: `STRICT=1` — falha o job (futuro gate).

## Como classificar findings

| Severidade | Exemplos |
|------------|----------|
| **Blocking** | Ciclo SPM; `ViewModel` novo; `SwiftUI` em Domain; feature importa `Persistence` fora da allowlist |
| **Suggestion** | Arquivo view > 300 linhas; muitos `some View`; lógica no `body` |
| **Nit** | Ordem de membros; naming |

## Review LLM (GitHub Actions)

Workflow: `.github/workflows/pr-architecture-review.yml`

- Secret: `ANTHROPIC_API_KEY` ou `OPENAI_API_KEY` (configurar no repositório).
- Comentário no PR com marker `<!-- architecture-review-bot -->`.
- LLM deve citar **somente** violações com evidência no diff ou na saída dos scripts estáticos.

## SPDD

- Feature nova sem canvas → **Blocking** (processo).
- Refactor MV → `/spdd-sync` CPR-006 se normas mudarem; não alterar design baseline sem canvas Design.
