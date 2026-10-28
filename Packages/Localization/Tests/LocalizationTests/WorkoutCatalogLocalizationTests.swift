import Foundation
import Testing
@testable import Localization
import Domain

@Suite("Workout catalog L10n")
struct WorkoutCatalogLocalizationTests {
    @Test("Toda categoria do catálogo tem chave en e pt-BR")
    func catalogKeysExistInBothLocales() {
        for category in CrossfitCatalog.allCategories {
            let en = localizedString(for: category.titleKey, locale: "en")
            let pt = localizedString(for: category.titleKey, locale: "pt-BR")
            #expect(!en.isEmpty)
            #expect(!pt.isEmpty)
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

    private func localizedString(for key: String, locale: String) -> String {
        guard let path = Bundle.module.path(forResource: locale, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return ""
        }
        return bundle.localizedString(forKey: key, value: "", table: nil)
    }
}
