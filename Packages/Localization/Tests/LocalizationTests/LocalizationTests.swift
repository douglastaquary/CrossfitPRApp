import Foundation
import Testing
@testable import Localization
import Domain

@Suite("Localized copy")
struct LocalizationTests {
    @Test("Nomes de exercício diferem do rawValue técnico")
    func exerciseNamesAreLocalized() {
        let kinds: [ActivityKind] = [
            .airSquat, .backSquat, .barMuscleUp, .benchPress,
            .boxJump, .burpee, .clean, .cleanAndJerk, .deadlift,
        ]

        for kind in kinds {
            #expect(kind.localizedName != kind.rawValue)
        }
    }

    @Test("Mensagens de erro de repositório não são vazias")
    func repositoryErrorMessages() {
        #expect(!PersonalRecordRepositoryError.notFound.localizedMessage.isEmpty)
        #expect(!PersonalRecordRepositoryError.invalidData.localizedMessage.isEmpty)
    }

    @Test("Cancelamento de assinatura não exibe mensagem")
    func subscriptionCancelledIsSilent() {
        #expect(SubscriptionError.userCancelled.localizedMessage.isEmpty)
    }

    @Test("Strings principais de onboarding existem")
    func onboardingStringsExist() {
        #expect(!Strings.Onboarding.title.isEmpty)
        #expect(!Strings.Onboarding.subtitle.isEmpty)
    }
}
