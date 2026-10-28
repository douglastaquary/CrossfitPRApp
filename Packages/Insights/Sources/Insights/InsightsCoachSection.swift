import SwiftUI
import Domain
import Application
import Localization
import SharedUI

/// Card PRO — coach IA (mock/adapters CPR-007 até Apple Intelligence real).
struct InsightsCoachSection: View {
    @EnvironmentObject private var coachingClient: CoachingClient
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @EnvironmentObject private var workoutEngineClient: WorkoutEngineClient
    @EnvironmentObject private var subscriptionClient: SubscriptionClient

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(Strings.Insights.Coach.title)
                    .font(.headline)
                Spacer()
                if coachingClient.isLoading {
                    ProgressView()
                } else {
                    Button(Strings.Insights.Coach.refresh) {
                        Task { await reload(force: true) }
                    }
                    .font(.caption)
                }
            }

            if let insight = coachingClient.latestInsight {
                Text(insight.workoutSuggestion)
                    .font(.subheadline.bold())
                if !insight.focusLifts.isEmpty {
                    Text(insight.focusLifts.joined(separator: " · "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(insight.repScheme)
                    .font(.caption.monospaced())
                Text(insight.rationale)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                Text(Strings.Insights.Coach.placeholder)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(AppDesign.Colors.brand.opacity(0.08))
        .cornerRadius(12)
        .task(id: personalRecordClient.records.count) {
            await reload(force: false)
        }
    }

    private func reload(force: Bool) async {
        let tier = subscriptionClient.currentTier
        await workoutEngineClient.analyze(records: personalRecordClient.records)
        await coachingClient.refreshCoaching(
            records: personalRecordClient.records,
            engineInsights: workoutEngineClient.insights,
            tier: tier,
            force: force
        )
    }
}
