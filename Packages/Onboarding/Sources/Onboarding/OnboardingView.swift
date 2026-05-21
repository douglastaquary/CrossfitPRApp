import SwiftUI
import SharedUI
import Localization

public struct OnboardingView: View {
    var onComplete: () -> Void

    public init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }

    public var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text(Strings.Onboarding.title)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 16) {
                featureRow(icon: "figure.strengthtraining.traditional", title: "Gerencie seus recordes")
                featureRow(icon: "list.bullet", title: "Organize seus PRs")
                featureRow(icon: "chart.line.uptrend.xyaxis", title: "Gráficos de evolução")
                featureRow(icon: "chart.bar", title: "Insights poderosos")
            }
            .padding(.horizontal, 32)

            Spacer()

            Button {
                onComplete()
            } label: {
                Text(Strings.Onboarding.cta)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color(.systemBackground))
    }
    
    private func featureRow(icon: String, title: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.green)
                .frame(width: 32)
            Text(title)
                .font(.body)
            Spacer()
        }
    }
}
