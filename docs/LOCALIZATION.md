# Localização — CrossfitPR

## Idiomas suportados

| Código | Uso |
|--------|-----|
| `en` | Inglês |
| `pt-BR` | Português (Brasil) — **fallback** do pacote (`defaultLocalization`) |

O idioma exibido segue a **preferência de idioma do dispositivo** (Settings → General → Language). O iOS escolhe o melhor `.lproj` disponível no bundle do pacote `Localization`.

## Onde ficam as strings

- Arquivos: `Packages/Localization/Sources/Localization/Resources/en.lproj/Localizable.strings` e `pt-BR.lproj/Localizable.strings`
- API Swift: `Strings.*` em `Packages/Localization/Sources/Localization/Strings.swift`
- Resolução: `NSLocalizedString(key, bundle: .module, comment: "")`

## Adicionar copy nova

1. Incluir a **mesma chave** em `en` e `pt-BR`.
2. Expor via enum aninhado em `Strings.swift` (nunca hardcode na view).
3. Rodar `swift test` em `Packages/Localization` se aplicável.

## Projeto Xcode

`CrossfitPR.xcodeproj`: `developmentRegion = pt-BR`, `knownRegions = en, pt-BR, Base`.

Strings do app shell (se houver) devem usar o módulo `Localization`; o target app **não** inclui `.lproj` próprios ativos para copy de features.

## Norma (CPR-006 N-07)

Views em `Packages/*` não devem usar `Text("…")` com frases de produto — usar `Strings.tr` ou propriedades tipadas.
