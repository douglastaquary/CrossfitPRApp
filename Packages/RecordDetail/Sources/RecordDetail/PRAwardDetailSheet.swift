import SwiftUI
import Domain
import Application
import Subscription
import Localization
import SharedUI

/// Sheet de prêmio (CPR-013) + Share Card (CPR-017).
public struct PRAwardDetailSheet: View {
    let award: PRAward
    var shareModel: PRShareCardModel?

    @EnvironmentObject private var subscriptionClient: SubscriptionClient
    @EnvironmentObject private var settingsClient: SettingsClient
    @Environment(\.dismiss) private var dismiss

    public init(award: PRAward, shareModel: PRShareCardModel? = nil) {
        self.award = award
        self.shareModel = shareModel
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "medal.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [AppDesign.Colors.eliteAccent, Color.yellow.opacity(0.9)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: AppDesign.Colors.eliteAccent.opacity(0.45), radius: 14)

                    Text(Strings.tr(award.titleKey))
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)

                    Text(Strings.tr(award.bodyKey))
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)

                    Text(Strings.Award.earnedTimes(award.earnedCount))
                        .font(.subheadline.weight(.semibold))
                    Text(Strings.Award.latest(award.latestDate.formatted(date: .numeric, time: .omitted)))
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if let model = resolvedShareModel {
                        Text(Strings.Share.celebrationTitle)
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 8)

                        ShareCardView(model: model)
                        ShareCardShareButton(model: model)
                            .padding(.horizontal, 8)
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .background(AppDesign.Colors.background.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Strings.NewPR.cancel) { dismiss() }
                }
            }
        }
    }

    private var resolvedShareModel: PRShareCardModel? {
        if let shareModel { return shareModel }
        return PRShareCardModel(
            exerciseName: Strings.tr(award.titleKey),
            valueLine: Strings.Share.cardBrand,
            date: award.latestDate,
            tier: subscriptionClient.currentTier
        )
    }
}
