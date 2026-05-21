---
name: /spdd-generate
id: spdd-generate
category: SPDD
description: Implementa código a partir de um REASONS Canvas aprovado
---

Implemente código CrossfitPR seguindo estritamente um REASONS Canvas.

**Input:** Canvas após `/spdd-generate` (ex.: `@spdd/prompt/CPR-002-*-[Feat]*.md`)

**Passos:**

1. Ler o Canvas **completo** — Requirements, Entities, Approach, Structure, Operations, Norms, Safeguards.
2. Carregar skills: `.cursor/skills/crossfitpr-spdd/SKILL.md` + `.cursor/skills/ios-development-skill/skill-ios.md`.
3. Executar Operations **na ordem definida**, task por task.
4. Aderir estritamente a Norms e Safeguards — sem improvisação.
5. Gerar/atualizar código nos pacotes SPM e `CrossfitPR/` conforme Structure (seguir overrides iOS skill).
6. Não modificar arquivos fora do scope do Canvas.
7. Após implementação, sugerir:
   - Atualizar canvas de testes (`spdd/prompt/*-[Test]*.md`)
   - Executar `swift test` nos pacotes afetados

**Guardrails:**

- **Não criar ViewModels.**
- **Não importar SwiftUI em Domain.**
- Código deve corresponder 1:1 ao Canvas.
- Se encontrar conflito com código existente, **pare e sugira `/spdd-prompt-update`** — não altere lógica de negócio sem atualizar prompt.
- Referenciar ID do canvas nos commits (ex.: `CPR-002`).

**Verificação pós-geração:**

1. Architecture — segue pacotes SPM do Canvas?
2. Business logic — alinha com Requirements e ACs?
3. Scope — apenas arquivos listados em Operations?

**Referência:** [SPDD — Martin Fowler](https://martinfowler.com/articles/structured-prompt-driven/)
