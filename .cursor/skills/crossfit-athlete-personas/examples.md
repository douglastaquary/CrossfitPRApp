# Exemplos — decisões com esta skill

## 1. Insight Free vs PRO vs Elite (mesmo PR de Back Squat)

**Contexto:** User registrou Back Squat 140 kg (novo PR). Engine tem histórico 90–180 dias.

| Tier | Output adequado |
|------|-----------------|
| Free | "Novo PR! +5 kg vs março." + teaser "Veja seu gap vs. atletas avançados no PRO/Elite" |
| PRO | Tendência, % sugeridos para próximos WODs, consistência, coach curto CPR-007 |
| Elite | Assessment: squat forte vs press fraco; limiting factor "overhead"; season Open em 6 semanas |

**Errado:** Free com periodização completa; Elite com copy de iniciante.

## 2. Feature "% no RecordDetail"

- Persona: **Independence** (job: carga certa no box).  
- Tier: teaser Free / full PRO.  
- Mayhem: Compete usa % **e** RPE — mostrar % agora; RPE como campo opcional depois (backlog #9).  
- Não exigir nível Compete para ver a tabela.

## 3. Priorizar Watch fase 1

- Persona: Independence + Compete (telefone na bolsa).  
- CPR-009: tips read-only + rest timer antes de captura RPE.  
- Safeguard: sem LLM no Watch; sync → `CoachingContextBuilder` no iPhone.  
- Comercial: bundle PRO+Watch / Elite (canvas).

## 4. Recusar "WOD do dia estilo Mayhem"

- User pede programming diário com vídeos e 12 tracks.  
- Skill: **fora de escopo** — compete com Mayhem Athlete.  
- Alternativa: assessment + % + feedback pós-WOD + Watch timer para quem já tem o WOD no quadro.

## 5. Copy de streak

- Mayhem: missed day sem punição.  
- **Certo:** "3 treinos esta semana — ritmo sólido."  
- **Errado:** "Você quebrou a sequência de 40 dias!" com vergonha.  
- Persona social: oferecer share do streak positivo, não do fail.

## 6. Heurística de nível sugerido

```
if poucos 1RMs / só scale movements → Liberty
else if Rx parcial + benchmarks médios → Independence
else if Rx frequente + Open scores → Freedom
else if peaking / comps + volume alto → Compete (só label; Elite é assinatura)
```

User sempre pode editar. Label Compete ≠ entitlement StoreKit Elite.

## 7. Engine calibra Elite, UI respeita tier

```
baselines = eliteReferenceRates()           // sempre disponível no Domain
insight = engine.generate(records, tier)   // trunca densidade por SubscriptionTier
```

Teaser PRO/Elite mostra *que* existe gap; não entrega o diagnostic completo no Free.
