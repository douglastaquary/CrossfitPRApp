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

            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 64))
                .foregroundStyle(.green)

            VStack(spacing: 8) {
                Text(Strings.Onboarding.title)
                    .font(.title.bold())
                Text(Strings.Onboarding.subtitle)
                    .font(.subheadline)
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
            .tint(.green)
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
