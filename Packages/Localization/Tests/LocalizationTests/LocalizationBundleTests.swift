import Foundation
import Testing
@testable import Localization

@Suite("Bundle de localização")
struct LocalizationBundleTests {
    @Test("Argumento -AppleLanguages vira o código do .lproj")
    func appleLanguagesArgument() {
        #expect(LocalizationBundle.languageCode(fromAppleLanguagesArgument: "(en)") == "en")
        #expect(LocalizationBundle.languageCode(fromAppleLanguagesArgument: "(pt-BR)") == "pt-BR")
        #expect(
            LocalizationBundle.languageCode(
                from: ["-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
            ) == "en"
        )
        #expect(LocalizationBundle.languageCode(from: ["-AppleLocale", "en_US"]) == nil)
    }

    @Test("onboarding.cta existe nos dois idiomas")
    func onboardingCTAMatchesLocale() {
        #expect(LocalizationBundle.table(languageCode: "en")?["onboarding.cta"] == "Let's go")
        #expect(LocalizationBundle.table(languageCode: "pt-BR")?["onboarding.cta"] == "Bora começar")
    }
}
