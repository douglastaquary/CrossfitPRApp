# CPR-003 — Desacoplamento SPM e camada Application

> **Status:** ✅ Implementado — canvas sincronizado em [`CPR-003-20260520-[Feat]-spm-application-layer.md`](../prompt/CPR-003-20260520-%5BFeat%5D-spm-application-layer.md)

## Background

Módulos SPM existiam, mas clients de aplicação estavam misturados com infra (`PersonalRecordClient` em Persistence) e o pacote de engine dependia de `Subscription` diretamente. Precisávamos de boundaries claros sem alterar telas ou fluxos.

## Business Value

1. **Testabilidade** — wiring isolado em `AppEnvironment`
2. **Manutenção** — dependências unidirecionais entre pacotes
3. **Evolução segura** — UI congelada enquanto arquitetura amadurece

## Scope In

- Criar pacote `Application` (clients + composition root)
- Mover `PersonalRecordClient` de Persistence → Application
- Mover client de análise (`WorkoutEngineClient`) para Application
- Remover dependência engine → Subscription (composição só em Application)
- `CrossfitPRApp` usa `AppEnvironment.make()`
- App target linka Application (transitive: Persistence, WorkoutEngine)

## Scope Out

- Mudanças de layout ou fluxo de telas
- Novas features de produto (LLM, etc.)
- Pacotes SPM por feature de UI (entregue em CPR-004)

## Acceptance Criteria

### AC-1 — Grafo de deps

**Given** os pacotes SPM  
**When** inspecionado Package.swift de cada um  
**Then** WorkoutEngine depende apenas de Domain; Application compõe todos.

### AC-2 — UI inalterada

**Given** telas existentes  
**When** comparado fluxo do usuário  
**Then** mesmas tabs, mesmas ações, mesmo layout baseline.

### AC-3 — Composition root

**Given** app launch  
**When** `AppEnvironment.make()` é chamado  
**Then** todos os clients são injetados via Environment.
