---
name: /spdd-sync
id: spdd-sync
category: SPDD
description: Sincroniza mudanças de código (refactor/fix) de volta ao REASONS Canvas
---

Sincronize o REASONS Canvas com o estado atual do código (fluxo: code → prompt).

**Input:** Canvas de referência após `/spdd-sync` (ex.: `@spdd/prompt/CPR-001-*-[Feat]*.md`)

**Passos:**

1. Ler o Canvas existente.
2. Comparar com código atual nos pacotes e app shell.
3. Identificar divergências:
   - Novos arquivos/componentes não documentados
   - Refactors (renomeações, extrações)
   - Correções que não mudaram comportamento
4. Atualizar seções **S (Structure)**, **O (Operations)**, **E (Entities)** conforme necessário.
5. **NÃO alterar Requirements** a menos que comportamento observável tenha mudado.
6. Documentar data de sync no topo do canvas.

**Quando usar:**

- Após refactor (extrair helper, renomear, magic numbers → constants).
- Após `/spdd-generate` para validar alinhamento.
- Retroactive sync de código legado para baseline SPDD.

**Quando NÃO usar:**

- Mudança de requisito de negócio → use `/spdd-prompt-update`.

**Guardrails:**

- Canvas deve refletir código **atual**, não histórico.
- Preservar Safeguards e Norms — atualizar se novos padrões emergirem.

**Referência:** [SPDD — Martin Fowler](https://martinfowler.com/articles/structured-prompt-driven/)
