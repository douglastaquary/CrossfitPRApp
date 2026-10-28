---
name: crossfit-athlete-personas
description: >-
  Personas CrossFit (Liberty→Compete), Mayhem Nation, backlog Free/PRO/Elite e
  Watch/Duo. Use em produto, Insights, WorkoutEngine, tier Elite, coach,
  Watch companion, retenção, share, níveis de atleta ou menção a Mayhem.
---

# CrossfitPR — Personas & Mayhem

Conhecimento de **mercado e produto** para decisões de feature, copy, densidade da engine e upsell Elite. Não substitui SPDD — informa stories/canvases.

## Quando usar

- Personas, níveis Liberty / Independence / Freedom / Compete  
- Mayhem Nation, Froning, competidor, Elite  
- Retenção, share, Watch companion, iPhone Duo  
- Priorizar backlog Free vs PRO vs Elite  
- Calibrar `WorkoutEngine` / coach contra padrões elite  

## Ordem de precedência

1. **SPDD** — story → analysis → canvas → generate  
2. **Esta skill** — quem é o usuário e o que Mayhem ensina  
3. **Design / MV / iOS** — implementação  

## Tese de produto (Norms)

- Free/PRO falam **Liberty → Independence** na UI.  
- Engine e coach podem **calibrar contra referências Elite** (taxas, ratios, baselines); a **densidade exposta** muda por tier.  
- Elite = assessment, limiting factors, season, Watch bundle, feedback denso — vício por qualidade, não spam.  
- **Não** implementar programming diário tipo Mayhem Athlete / SugarWOD.  
- CrossfitPR = segundo cérebro: PRs, %, RPE, gaps, pós-WOD, Watch.  
- Copy via `Strings.*`; UI Elite só com canvas Design CPR-008.  
- Feature nova de negócio → SPDD antes do código.

## Referências (ler sob demanda)

| Arquivo | Conteúdo |
|---------|----------|
| `references/user-personas.md` | Demografia, 6 personas, JTBD, mapa tier |
| `references/mayhem-nation.md` | Cabeças, tracks, sessão-tipo, princípios |
| `references/feature-backlog.md` | Ideias P0–P3 → CPR-007/008/009 |
| `examples.md` | Decisões concretas de produto |

## Checklist rápido do agente

1. Qual persona é o ator primário desta mudança?  
2. Qual tier vê o valor completo vs teaser?  
3. A engine usa referência Elite sem vazar UI Elite no Free?  
4. Há story/canvas (CPR-007/008/009 ou nova)?  
5. Evita programming diário / LLM no Watch / guilt streaks?

## SPDD relacionado

- CPR-007 — Coach IA PRO  
- CPR-008 — Tier Elite  
- CPR-009 — Watch companion  
- CPR-010 — Analysis mercado/Mayhem → esta skill  

## Safeguards

- Sem ViewModels (MV do projeto).  
- Watch não chama LLM; iPhone = composition root do coach.  
- Offline-first; sync não bloqueia log no box.
