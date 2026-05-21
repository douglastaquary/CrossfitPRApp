# CPR-001 — PR Tracking, Insights e Conversão PRO (Baseline)

## Background

Atletas de CrossFit precisam registrar Personal Records (PRs) por exercício, acompanhar evolução ao longo do tempo e receber insights acionáveis sobre seus treinos. O app deve converter usuários gratuitos em assinantes PRO oferecendo análises avançadas bloqueadas no tier free.

## Business Value

1. **Registro confiável de PRs** — histórico persistente offline com sync iCloud.
2. **Insights de evolução** — resumos e tendências que ajudam o atleta a progredir.
3. **Monetização PRO** — análises avançadas (WorkoutEngine, recomendações) como diferencial pago.

## Scope In

- Registrar PRs: exercício, peso (lb), data.
- Listar PRs ordenados por data (mais recente primeiro).
- Gerar insights a partir do histórico de PRs.
- Tier Free: resumo + tendências básicas + teaser PRO.
- Tier PRO: análise WorkoutEngine, metas sugeridas, análise de consistência.
- Onboarding inicial com mensagem sobre persistência local + iCloud.
- Arquitetura modular SPM (Domain, Persistence, WorkoutEngine, Subscription, Application, feature packages).
- SwiftUI sem ViewModels — clients via Environment.

## Scope Out

- Integração com LLM externo (heurísticas locais via WorkoutEngine por enquanto).
- Edição/exclusão de PRs na UI (delete existe no repository, sem tela).
- Gráficos visuais de evolução.
- Compartilhamento social de PRs.
- Integração com apps externos (Wodify, SugarWOD).

> **Nota:** StoreKit 2 real foi implementado em CPR-002 (fora do scope original desta story).

## Acceptance Criteria

### AC-1 — Registrar PR

**Given** um usuário na tela "Novo PR"  
**When** seleciona "BACK SQUAT", informa 140 lb e salva  
**Then** o PR aparece na lista "Meus PRs" com exercício, peso e data.

### AC-2 — Persistência offline-first

**Given** um PR salvo com sucesso  
**When** o app reinicia sem conexão iCloud  
**Then** o PR permanece disponível localmente via SwiftData.

### AC-3 — Insights Free com teaser PRO

**Given** um usuário Free com 4+ PRs no mesmo exercício (pesos estáveis)  
**When** acessa a aba "Insights"  
**Then** vê resumo básico + teaser indicando insights PRO bloqueados (ex.: análise WorkoutEngine).

### AC-4 — Insights PRO desbloqueados

**Given** um usuário PRO com histórico suficiente  
**When** acessa "Insights"  
**Then** vê análise WorkoutEngine e recomendações personalizadas (sem teaser).

### AC-5 — Upgrade PRO

**Given** um usuário Free na tela de upgrade  
**When** toca "Assinar PRO"  
**Then** tier muda para PRO e insights avançados ficam acessíveis.
