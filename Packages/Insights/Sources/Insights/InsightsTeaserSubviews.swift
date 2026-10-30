import SwiftUI
import Domain
import Application
import Localization

// MARK: - Empty State

struct InsightsTeaserEmptySection: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: AppDesign.Icon.emptyInsights)
                .font(.system(size: AppDesign.Layout.emptyStateIconSize))
                .foregroundStyle(AppDesign.Colors.brand.opacity(0.7))

            VStack(spacing: 8) {
                Text(Strings.Insights.Teaser.emptyTitle)
                    .font(AppDesign.Typography.sectionTitle)

                Text(Strings.Insights.Teaser.emptyMessage)
                    .font(AppDesign.Typography.bodySecondary)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                NotificationCenter.default.post(name: .navigateToCategories, object: nil)
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text(Strings.Insights.Teaser.emptyCTA)
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppDesign.Colors.brand)
                .foregroundStyle(.white)
                .cornerRadius(12)
            }
        }
        .padding(.vertical, 12)
    }
}
