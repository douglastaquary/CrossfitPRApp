# Backlog de features — personas × tiers × SPDD

Prioridade relativa: **P0** (fundação / já no canvas) → **P1** (atração praticante + Elite) → **P2** (diferenciação) → **P3** (futuro dispositivo).

## Mapa rápido ideia → tier → artefato

| # | Feature | Tier | Persona | SPDD / status | P |
|---|---------|------|---------|---------------|---|
| 1 | PR Celebration + Share Card | Free→PRO | Social, Liberty+ | CPR-017 | P1 |
| 2 | %1RM instantâneo (RecordDetail) | Free teaser / PRO full | Independence | CPR-001 (evoluir) | P0 |
| 3 | Benchmarks Girls / Heroes / Open YoY | PRO | Independence | CPR-018 | P1 |
| 4 | Nível auto-sugerido Liberty→Freedom | Free+PRO | Todas | Story futura | P1 |
| 5 | Streak + consistência (manhã) | Free leve / PRO denso | Social, Liberty | CPR-001 Insights | P1 |
| 6 | Athlete Assessment (gaps vs baselines) | Elite | Compete, Freedom | CPR-008 ( Domínio+Engine ) | P0 |
| 7 | Limiting factor card | Elite (teaser PRO) | Compete | CPR-008 + CPR-007 | P0 |
| 8 | Season mode (Open / peaking / deload) | Elite | Compete | CPR-015 | P1 |
| 9 | RPE + intended stimulus no log | PRO/Elite | Freedom+ | CPR-007 context | P1 |
| 10 | Volume/semana + readiness leve | Elite | Compete, Masters | CPR-008 | P2 |
| 11 | Watch companion (tips → captura) | PRO+ / Elite bundle | Compete, Independence | CPR-009 | P0 |
| 12 | Watch: timer WOD + % load + haptic PR | PRO+/Elite | Independence+ | CPR-016 (haptic PR follow-up) | P1 |
| 13 | Coach IA CrossFit | PRO / Elite prompts | Independence+ | CPR-007 / CPR-008 | P0 |
| 14 | iPhone Duo layouts (outer/inner/seated) | Todos | Box logging | Futuro (pós iPhone/iPad) | P3 |

## Detalhamento por bloco

### A. Praticantes — retenção + share

**1. PR Celebration + Share Card**  
- Momento de celebração no save de PR; card exportável (Stories / WhatsApp).  
- "Fist bump" digital — comunidade sem leaderboard tóxico.  
- Free: celebração in-app; PRO: card branded rico.

**2. %1RM instantâneo**  
- Tabela 50–100% no detalhe do movimento; arredondamento kg/lb do Settings.  
- Job #1 no box para Independence ("80% do clean = X").

**3. Benchmarks pack**  
- Girls, Heroes, scores Open por ano; gráfico YoY.  
- Alimenta assessment Elite com baselines conhecidas.

**4. Nível auto-sugerido**  
- Heurística a partir de PRs / movimentos Rx-capable; editável pelo user.  
- Espelha Liberty / Independence / Freedom; copy via `Strings.*`.

**5. Streak + consistência**  
- 54% treinam cedo — insight "manhãs fortes" sem guilt por miss (princípio Mayhem missed day).

### B. Atletas Mayhem / Compete — atração Elite

**6. Athlete Assessment**  
- Domínios: força, Oly, ginástica, engine.  
- Comparar vs baselines competitivas (engine usa referência Elite).  
- UI só no Elite; teaser em PRO.

**7. Limiting factor card**  
- Inspirado em Mayhem Performance Coaching: "seu teto agora é X".  
- Coach CPR-007/008 consome o mesmo snapshot.

**8. Season mode**  
- Tags: Off-season / Build / Open / Peaking / Deload.  
- Janela Elite 180 dias (`TokenBudgetPolicy` em CPR-008 analysis).

**9. RPE + stimulus**  
- Campos opcionais no log; Watch fase 2 envia eventos compactos → `CoachingContextBuilder`.

**10. Volume / readiness**  
- Resumo semanal; flags leves de overload. **Não** virar programming diário.

### C. Watch (CPR-009)

| Modo | Comportamento |
|------|----------------|
| Só Watch | Timer AMRAP/EMOM/For Time; rounds/reps; haptic PR; HealthKit; offline → sync |
| Só iPhone | Histórico, insights, coach, share |
| Juntos | Sessão no pulso → contexto no iPhone → feedback PRO/Elite pós-WOD |

Fases canvas: (1) tips read-only (2) captura RPE/séries.  
Ampliar DoD mental: **% load no pulso** + **celebração haptic**.  
Safeguard: Watch **não** chama LLM.

### D. iPhone Duo (P3)

- Outer (closed): log rápido + Live Activity de rest.  
- Inner (open): PRs | sessão lado a lado (regular width).  
- Seated / half-fold: timer grande em cima, log embaixo.  
- Implementar só após experiências iPhone/iPad estáveis; size classes, sem layouts fixos por pose.

### E. Monetização

| Tier | Entrega |
|------|---------|
| Free | PRs, histórico, teaser insights/coach |
| PRO | WorkoutEngine detalhado, coach CPR-007, %, benchmarks, Watch fase 1 |
| Elite | Assessment, limiting factor, season, coach Elite, Watch bundle, janela/dados densos |

Vício desejado = **qualidade de feedback em tempo quase real**, não spam de push.

## Dependências

```
CPR-001 baseline ──► CPR-007 coach PRO ──► CPR-008 Elite
                           │
                           └──► CPR-009 Watch (context builder no iPhone)
```

Análise de mercado / skill: `spdd/analysis/CPR-010-crossfit-market-mayhem-personas.md`.

## Ao implementar uma linha deste backlog

1. Verificar se já existe story/canvas; senão `/spdd-analysis` → canvas → `/spdd-generate`.  
2. Consultar esta skill (personas + Mayhem) para copy, densidade e limites.  
3. Design skill se UI mudar; CPR-008 Design para modo competidor.  
4. Não inventar programming estilo Mayhem Athlete.
