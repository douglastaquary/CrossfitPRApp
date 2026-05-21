# CPR-004 — Pacotes SPM por feature + WorkoutEngine

> **Status:** ✅ Implementado — canvas sincronizado em [`CPR-004-20260520-[Feat]-spm-feature-packages-workout-engine.md`](../prompt/CPR-004-20260520-%5BFeat%5D-spm-feature-packages-workout-engine.md)

## Contexto

Views estavam no app target (`CrossfitPR/Features/`). O pacote legado `WorkoutAnalysis` usava terminologia "platô". Precisávamos de módulos por feature (estilo IceCubesApp) e renomear para **WorkoutEngine**.

## Objetivo

1. Extrair views para pacotes SPM: `PRHistory`, `Insights`, `PROUpgrade`, `Onboarding`.
2. Renomear `WorkoutAnalysis` → `WorkoutEngine` (pacote, engine, client, categorias).
3. Manter layout e fluxos de telas inalterados.

## Critérios de aceite

**Given** o app compilado  
**When** o usuário navega pelas tabs e sheets  
**Then** o comportamento visual e fluxos permanecem idênticos ao baseline CPR-001.

**Given** a arquitetura SPM  
**When** inspecionamos dependências  
**Then** feature packages importam `Application` (clients), não `Persistence` diretamente.

**Given** insights PRO com peso estável  
**When** tier é PRO  
**Then** insight usa categoria `.workoutEngine` e linguagem "WorkoutEngine".

## Escopo

- ✅ Pacotes feature + wiring no `project.pbxproj`
- ✅ `WorkoutEngineClient` substitui `WorkoutAnalysisClient`
- ✅ Docs/skill atualizados
- ❌ Mudanças de UI/layout (fora de escopo)
