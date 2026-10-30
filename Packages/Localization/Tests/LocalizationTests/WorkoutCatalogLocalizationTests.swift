import Foundation
import Testing
@testable import Localization
import Domain

@Suite("Workout catalog L10n")
struct WorkoutCatalogLocalizationTests {
    @Test("Toda categoria do catálogo tem chave en e pt-BR")
    func catalogKeysExistInBothLocales() {
        // Usa LocalizationBundle.table — no host macOS do CI o SPM embute
        // `pt-br.lproj` (minúsculo); `path(forResource: "pt-BR")` falha.
        let enTable = LocalizationBundle.table(languageCode: "en") ?? [:]
        let ptTable = LocalizationBundle.table(languageCode: "pt-BR") ?? [:]

        for category in CrossfitCatalog.allCategories {
            let en = enTable[category.titleKey] ?? ""
            let pt = ptTable[category.titleKey] ?? ""
            #expect(!en.isEmpty, "en missing \(category.titleKey)")
            #expect(!pt.isEmpty, "pt-BR missing \(category.titleKey)")
            #expect(en != category.titleKey)
            #expect(pt != category.titleKey)
        }
    }

    @Test("Título canônico mapeia para chave conhecida")
    func storedTitleLookup() {
        for category in CrossfitCatalog.allCategories {
            let found = CrossfitCatalog.category(forStoredTitle: category.title)
            #expect(found?.titleKey == category.titleKey)
        }
    }
}
