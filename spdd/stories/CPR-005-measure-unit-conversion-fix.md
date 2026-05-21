# CPR-005 — Fix: Conversão e Exibição de Unidade de Medida

## Contexto

O CrossfitPR permite que o atleta escolha sua unidade de medida preferida (Kilos ou Libras) nas configurações. No entanto, algumas telas não respeitam essa preferência e exibem valores hardcoded em libras.

## Problema

1. `PRPercentagesView` exibe sempre "lb" independente da preferência do usuário
2. Falta helper centralizado para formatar valores com unidade correta
3. Conversão entre unidades não está encapsulada em um único lugar

## Requisitos

### Funcional
- **RF-001**: O app deve exibir todos os valores de peso na unidade preferida do usuário
- **RF-002**: Ao alterar a unidade nas configurações, todos os pontos do app devem refletir imediatamente
- **RF-003**: A conversão deve usar fator padrão: 1 lb = 0.453592 kg

### Não-funcional
- **RNF-001**: Helpers de conversão e formatação devem estar no pacote Domain (lógica pura)
- **RNF-002**: Views devem usar `settingsClient.measureTrackingMode` para decidir exibição

## Definition of Done

- [ ] `MeasureTrackingMode` possui helpers de conversão e formatação
- [ ] `PRPercentagesView` usa unidade correta baseada na preferência
- [ ] Todas as views que exibem peso respeitam a preferência
- [ ] Nenhum hardcode de "lb" ou "kg" em views (exceto sufixos dinâmicos)

## Impacto

| Pacote | Mudança |
|--------|---------|
| Domain | Adicionar helpers em `MeasureTrackingMode` |
| RecordDetail | Corrigir `PRPercentagesView` |
| SharedUI | Verificar `PersonalRecordRowView` (já usa `isPounds`) |

## Referências

- Baseline: `spdd/prompt/CPR-001-20260520-[Feat]-baseline-pr-tracking-and-insights.md`
- Settings: `Packages/Settings/Sources/Settings/SettingsView.swift`
