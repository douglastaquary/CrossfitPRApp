---
name: /spdd-analysis
id: spdd-analysis
category: SPDD
description: Gera contexto de análise estratégica a partir de uma user story CrossfitPR
---

Gere um documento de análise SPDD para o projeto CrossfitPR (iOS/Swift).

**Input:** User story após `/spdd-analysis` (texto ou `@spdd/stories/*.md`)

**Passos:**

1. Ler a story completa e todos os `@` references.
2. Escanear o codebase nos pacotes relevantes (`Packages/Domain`, `Persistence`, `WorkoutEngine`, `Subscription`, `Application`, pacotes de feature, `CrossfitPR/`).
3. Produzir análise em `spdd/analysis/{ID}-{TIMESTAMP}-[Analysis]-{description}.md` contendo:
   - **Domain Concepts** — existing vs new, com localização no código
   - **Strategic Direction** — abordagem, decisões, trade-offs
   - **Risks & Gaps** — ambiguidades, edge cases, riscos técnicos
   - **Acceptance Criteria Coverage** — mapeamento AC → componentes
   - **Edge Cases Identificados**
4. Usar ID da story (ex.: `CPR-001`) no nome do arquivo.
5. **NÃO gerar código.** Perguntar se deve prosseguir para `/spdd-reasons-canvas`.

**Guardrails:**

- Focar no "what" e "why", não em detalhes de implementação.
- Referenciar arquivos reais do projeto.
- Seguir linguagem de negócio (REASONS E) do canvas baseline em `spdd/prompt/CPR-001-*-[Feat]*.md`.
- Respeitar arquitetura em `docs/ARCHITECTURE.md`.

**Referência:** [SPDD — Martin Fowler](https://martinfowler.com/articles/structured-prompt-driven/)
