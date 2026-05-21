import SwiftUI
import Localization

public struct OnboardingView: View {
    let onContinue: () -> Void

    @State private var accountStatusMessage: String?
    @State private var isCheckingAccount = true

    public init(onContinue: @escaping () -> Void) {
        self.onContinue = onContinue
    }

    public var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: AppDesign.Icon.onboardingHero)
                .font(.system(size: AppDesign.Layout.onboardingHeroSize))
                .foregroundStyle(AppDesign.Colors.brand)

            VStack(spacing: 8) {
                Text(Strings.Onboarding.title)
                    .font(AppDesign.Typography.screenTitle)
                Text(Strings.Onboarding.subtitle)
                    .font(AppDesign.Typography.bodySecondary)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            if isCheckingAccount {
                ProgressView(Strings.Onboarding.loading)
            } else if let accountStatusMessage {
                Text(accountStatusMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()

            Button(Strings.Onboarding.cta) {
                onContinue()
            }
            .buttonStyle(.borderedProminent)
            .brandTint()
            .padding(.bottom, 32)
        }
        .padding()
        .task {
            await checkCloudAvailability()
        }
    }

    private func checkCloudAvailability() async {
        isCheckingAccount = true
        defer { isCheckingAccount = false }

        accountStatusMessage = Strings.Onboarding.icloudMessage
    }
}
