import SwiftUI
import Domain
import Localization

/// Sheet de prêmio (CPR-013 Design) — medalha + critério.
public struct PRAwardDetailSheet: View {
    let award: PRAward
    @Environment(\.dismiss) private var dismiss

    public init(award: PRAward) {
        self.award = award
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer(minLength: 24)
                Image(systemName: "medal.fill")
                    .font(.system(size: 96))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppDesign.Colors.eliteAccent, Color.yellow.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: AppDesign.Colors.eliteAccent.opacity(0.45), radius: 18)
                Text(Strings.tr(award.titleKey))
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                Text(Strings.tr(award.bodyKey))
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Text(Strings.Award.earnedTimes(award.earnedCount))
                    .font(.subheadline.weight(.semibold))
                Text(Strings.Award.latest(award.latestDate.formatted(date: .numeric, time: .omitted)))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
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
}
