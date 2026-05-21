import SwiftUI
import SharedUI
import Localization

public struct OnboardingView: View {
    @Binding var isCompleted: Bool

    public init(isCompleted: Binding<Bool>) {
        self._isCompleted = isCompleted
    }

    public var body: some View {
        VStack {
            Spacer()
            Text(Strings.Onboarding.title)
                .font(AppDesign.Typography.screenTitle)
                .frame(width: 300, alignment: .leading)

            HViewImageAndText(
                image: "figure.strengthtraining.traditional",
                imageColor: AppDesign.Colors.brand,
                title: "onboarding.item2.title",
                description: "onboarding.item2.description"
            )
            HViewImageAndText(
                image: "list.bullet",
                imageColor: AppDesign.Colors.brand,
                title: "onboarding.item1.title",
                description: "onboarding.item1.description"
            )
            HViewImageAndText(
                image: AppDesign.Icon.tabInsights,
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

            Spacer()

            Button(Strings.Onboarding.cta) {
                isCompleted = true
            }
            .buttonStyle(FilledButtonStyle(fullWidth: true))
            .padding()
        }
        .brandTint()
    }
}
