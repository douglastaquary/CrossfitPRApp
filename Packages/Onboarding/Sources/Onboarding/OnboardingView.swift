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
            Text(Strings.Onboarding.title)
                .font(AppDesign.Typography.screenTitle)
                .frame(width: 300, alignment: .leading)

            VStack(alignment: .leading, spacing: 0) {
                HViewImageAndText(
                    image: "figure.strengthtraining.traditional",
                    imageColor: AppDesign.Colors.brand,
                    title: "onboarding.item1.title",
                    description: "onboarding.item1.description"
                )
                HViewImageAndText(
                    image: "list.bullet",
                    imageColor: AppDesign.Colors.brand,
                    title: "onboarding.item2.title",
                    description: "onboarding.item2.description"
                )
                HViewImageAndText(
                    image: "chart.line.uptrend.xyaxis",
                    imageColor: AppDesign.Colors.brand,
                    title: "onboarding.item3.title",
                    description: "onboarding.item3.description"
                )
                HViewImageAndText(
                    image: "chart.bar",
                    imageColor: AppDesign.Colors.brand,
                    title: "onboarding.item4.title",
                    description: "onboarding.item4.description"
                )
            }

            Spacer()

            Button(Strings.Onboarding.cta) {
                onComplete()
            }
            .buttonStyle(FilledButtonStyle(fullWidth: true))
            .padding(.horizontal, AppDesign.Layout.horizontalPadding)
            .padding(.bottom, 40)
        }
        .padding()
    }
}
