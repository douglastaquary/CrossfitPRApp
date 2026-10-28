# CPR-006 — Analysis: MV SwiftUI

## Situação

- Projeto já seguia espírito MV (“sem ViewModels”, `@EnvironmentObject` clients).
- Várias views usam muitos `private var …: some View` (PROUpgrade, InsightsTeaser).
- Documentação externa (Dimillian) formaliza práticas que reduzem acoplamento e churn de identity.

## Decisão

| Opção | Prós | Contras |
|-------|------|---------|
| MVVM clássico | Familiar | Duplica clients, mais arquivos, testes frágeis |
| **MV + Clients (escolhida)** | Alinhado ao código atual + Dimillian | Migração gradual de views legadas |
| TCA / reducers | Previsível | Fora do escopo e Norms |

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Refactor quebra layout | Skill Design + PRs pequenos |
| Confusão MV vs “sem ViewModels” | `docs/MV-ARCHITECTURE.md` explica equivalência |
| iOS 16 vs @Observable | Skill documenta `EnvironmentObject` até upgrade |

## Plano

1. Normas + skills + regras (este entregável)
2. Refactor piloto por pacote feature (CPR-006 follow-ups)
