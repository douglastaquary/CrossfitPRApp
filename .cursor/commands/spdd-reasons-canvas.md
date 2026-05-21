---
name: /spdd-reasons-canvas
id: spdd-reasons-canvas
category: SPDD
description: Gera REASONS Canvas (prompt estruturado) a partir de análise ou requisito
---

Gere um REASONS Canvas implementation-ready para CrossfitPR.

**Input:** Análise SPDD ou requisito após `/spdd-reasons-canvas` (ex.: `@spdd/analysis/CPR-001-*.md`)

**Passos:**

1. Ler input completo + codebase relevante.
2. Gerar prompt com **7 seções REASONS** totalmente preenchidas:
   - **R** Requirements — essência do problema + DoD
   - **E** Entities — diagrama Mermaid classDiagram
   - **A** Approach — estratégia e decisões
   - **S** Structure — pacotes SPM, dependências, camadas
   - **O** Operations — tarefas concretas com métodos e lógica
   - **N** Norms — padrões CrossfitPR (sem ViewModels, Swift 6, SPM boundaries)
   - **S** Safeguards — limites funcionais, scope, governança SPDD
3. Salvar em `spdd/prompt/{ID}-{TIMESTAMP}-[Feat]-{description}.md`.
4. **NÃO incluir** metadata do framework, TODOs ou placeholders.
5. **NÃO implementar código** até confirmação do usuário.
6. Perguntar: "Canvas pronto. Prosseguir com `/spdd-generate`?"

**Guardrails:**

- Respeitar implementações existentes — evitar refatoração desnecessária.
- Operations deve ter assinaturas e lógica passo-a-passo.
- Norms deve referenciar `AGENTS.md` e canvas baseline CPR-001.
- Safeguards deve incluir regra SPDD: prompt primeiro, código depois.

**Referência:** [SPDD — Martin Fowler](https://martinfowler.com/articles/structured-prompt-driven/)
