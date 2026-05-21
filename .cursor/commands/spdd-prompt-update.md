---
name: /spdd-prompt-update
id: spdd-prompt-update
category: SPDD
description: Atualiza REASONS Canvas quando requisitos ou lógica de negócio mudam
---

Atualize incrementalmente um REASONS Canvas existente (fluxo: requirements → prompt → code).

**Input:** Canvas + descrição da mudança após `/spdd-prompt-update`

Exemplo:
```
/spdd-prompt-update @spdd/prompt/CPR-001-*-[Feat]*.md
Adicionar suporte a edição de PR existente. AC: Given PR na lista, When tap edit, Then form pré-preenchido.
```

**Passos:**

1. Ler canvas existente completo.
2. Identificar seções REASONS afetadas (geralmente R, E, O, Safeguards).
3. Atualizar **apenas** seções impactadas — preservar o restante.
4. Salvar no mesmo arquivo (ou novo timestamp se mudança major).
5. **NÃO alterar código** neste passo.
6. Sugerir `/spdd-generate` com diff direcionado após confirmação.

**Quando usar:**

- Bug de lógica de negócio (comportamento observável mudou).
- Novo requisito de PO/BA.
- AC adicionado ou modificado.

**Quando NÃO usar:**

- Refactor sem mudança de comportamento → use `/spdd-sync`.

**Referência:** [SPDD — Martin Fowler](https://martinfowler.com/articles/structured-prompt-driven/)
