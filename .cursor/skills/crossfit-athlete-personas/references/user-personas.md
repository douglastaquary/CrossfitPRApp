# Personas CrossFit — CrossfitPR

Referência de mercado e jobs-to-be-done. Níveis espelham a linguagem Mayhem (Liberty → Compete); o app **não** precisa nomear "Mayhem" na UI.

## Demografia (mercado)

| Sinal | Valor aproximado | Implicação UX |
|-------|------------------|---------------|
| Praticantes mundiais | ~4M | Mercado amplo; nicho PR/insights ainda aberto |
| Open anual | ~344k registros | Benchmarks Open = âncora de progresso |
| Idade média | ~33 | Copy adulta, direta; Masters em crescimento |
| Mulheres | ~59% | Copy e imagens inclusivos; pesos kg/lb |
| Renda / educação | Alta (bacharelado comum) | Pagam PRO/Elite se valor for claro |
| Frequência | ~4,2×/semana | Streaks e consistência > volume diário |
| Treino matinal | ~54% antes das 8h | Fluxos rápidos, Watch offline no box |
| Early adopters tech | ~31% | Watch + Duo fazem sentido |
| Profissionais | ~3% | Elite ancora qualidade; maioria é praticante |
| Motivo #1 retenção | Comunidade (~44%) | Share / fist bump digital |

Fontes de pesquisa 2024–2026 (estatísticas CrossFit, Open demographics, apps Health & Fitness). Usar como orientação de produto, não como KPI rígido.

## Pirâmide de níveis (modelo mental)

```
Compete / Elite     ← peaking, assessment, Watch live, coach denso
Freedom (Rx)        ← gaps, RPE, stimulus, throwdowns
Independence        ← %1RM, benchmarks, streaks
Liberty             ← PR simples, celebração, copy motivacional
```

**Tese CrossfitPR:** Free/PRO falam Liberty→Independence na superfície; a **engine calibra contra padrões Elite** (taxas, ratios, benchmarks competitivos) para insights e upsell Elite.

## Personas detalhadas

### 1. Liberty — Iniciante (0–12 meses)

| Campo | Conteúdo |
|-------|----------|
| Quem | Acabou de entrar no box; escala quase tudo; 1RMs incompletos ou inexistentes |
| Contexto | 2–4×/semana; medo de "não estar evoluindo"; depende do coach no floor |
| Dor | Progresso invisível; overload de jargão; vergonha de comparar |
| Job | Ver evidência clara de melhora e sentir pertencimento |
| App Free | Log PR fácil, celebração, histórico simples, teaser PRO |
| App PRO | % básicas quando há 1RM; insights de consistência; metas leves |
| Copy | Motivacional, humano, sem jargão de Games |
| Evitar | Periodização complexa; comparativos elite; volume/semana assustador |

### 2. Independence — Intermediário (1–5 anos)

| Campo | Conteúdo |
|-------|----------|
| Quem | Rx em parte dos WODs; Open ocasional; conhece Girls/Heroes |
| Contexto | 4–5×/semana; quer carga certa sem calculadora no box |
| Dor | "Coach pediu 80% e eu chuto"; platôs sem diagnóstico |
| Job | %1RM instantâneo + benchmarks year-over-year |
| App Free | PRs + teaser de %/benchmarks |
| App PRO | Tabela % no RecordDetail; Girls/Heroes/Open; streaks; coach CPR-007 |
| Copy | Direto, útil no floor ("seu 80% do clean = X kg") |
| Evitar | Tratar como iniciante; esconder números atrás de paywall demais |

### 3. Freedom / Rx — Avançado de box (~5–10% do gym)

| Campo | Conteúdo |
|-------|----------|
| Quem | Rx+ frequente; throwdowns locais; talvez Mayhem Gym Independence/Freedom |
| Contexto | Treina com intenção; nota stimulus e target times |
| Dor | Gaps força vs ginástica vs engine sem diagnóstico claro |
| Job | Ver limiting factors e stimulus hit/miss |
| App PRO | Gaps por domínio; RPE opcional; volume semanal leve |
| App Elite | Assessment vs baselines competitivos; season tags |
| Copy | Linguagem de stimulus, RPE, peaking — ainda acessível |
| Evitar | Virar app de programming diário (compete com Mayhem Athlete) |

### 4. Compete / Elite — Competidor

| Campo | Conteúdo |
|-------|----------|
| Quem | Mindset Mayhem Compete; Open → Semis; 1:30–2h de sessão; % + RPE |
| Contexto | Segue track externo (Mayhem, box, coach 1:1); precisa do "segundo cérebro" |
| Dor | Feedback genérico; dados espalhados; zero valor no pulso durante o WOD |
| Job | Feedback denso pós-sessão + %/timer no Watch + assessment vs field |
| App Elite | Periodização/season; janela 180d; coach Elite; Watch bundle; limiting factor |
| Copy | Competidor, preciso, sem spam — vício por qualidade |
| Evitar | Notification spam; LLM no Watch; programming que substitui o coach |

### 5. Masters 35+

| Campo | Conteúdo |
|-------|----------|
| Quem | Maior crescimento no Open; longevidade importa |
| Dor | Volume/intensity inadequados; recovery ignorado |
| Job | Progresso com cues de recovery e expectativas realistas de taxa |
| App | Mesmos PRs; insights com nuance de idade; Elite se compete Masters |
| Copy | Respeito à longevidade; sem "treino de adolescente" |

### 6. Praticante social (ortogonal ao nível)

| Campo | Conteúdo |
|-------|----------|
| Quem | Qualquer nível; comunidade é o motivo de ficar |
| Dor | Progresso fica no silêncio do celular |
| Job | Compartilhar PR / streak com amigos do box |
| App | Share cards, fist bump digital, leaderboard leve (opt-in) |
| Copy | Celebração coletiva, não ranking tóxico |

## Jobs-to-be-done (resumo)

1. **Registrar** PR em segundos no box (iPhone ou Watch).
2. **Converter** 1RM → % de trabalho sem math mental.
3. **Provar** evolução (benchmarks, streaks, year-over-year Open).
4. **Diagnosticar** gaps vs. aspiração (Independence→Compete).
5. **Receber** feedback pós-WOD acionável (PRO/Elite).
6. **Compartilhar** vitórias sem fricção.
7. **Treinar** com Watch quando o telefone fica na bolsa.

## Mapeamento tier de assinatura ↔ persona

| Tier | Persona primária | Persona secundária |
|------|------------------|--------------------|
| Free | Liberty | Social (share básico futuro) |
| PRO | Independence | Freedom (parcial) |
| Elite | Compete | Freedom avançado / Masters compete |

Engine (`WorkoutEngine` + coach CPR-007/008) pode usar **referências Elite** mesmo quando a UI expõe só Free/PRO — a densidade do output muda por tier.
