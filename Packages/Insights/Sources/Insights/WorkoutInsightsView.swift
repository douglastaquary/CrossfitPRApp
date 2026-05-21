import SwiftUI
import Domain
import Application
import Subscription
import PROUpgrade
import Localization

public struct WorkoutInsightsView: View {
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @EnvironmentObject private var workoutEngineClient: WorkoutEngineClient
    @EnvironmentObject private var subscriptionClient: SubscriptionClient
    @State private var isPresentingPROUpgrade = false

    public enum ViewState: Equatable {
        case loading
        case loaded
    }

    @State private var viewState: ViewState = .loading

    public init() {}

    public var body: some View {
        NavigationStack {
            Group {
                switch viewState {
                case .loading:
                    ProgressView(Strings.Insights.loading)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .loaded:
                    if workoutEngineClient.insights.isEmpty {
                        EmptyStateView(
                            title: Strings.Insights.emptyTitle,
                            systemImage: "chart.line.uptrend.xyaxis",
                            message: Strings.Insights.emptyMessage
                        )
                    } else {
                        List(workoutEngineClient.insights) { insight in
                            InsightRow(insight: insight) {
                                isPresentingPROUpgrade = true
                            }
                        }
                    }
                }
            }
            .navigationTitle(Strings.Insights.title)
            .toolbar {
                if subscriptionClient.currentTier == .free {
                    ToolbarItem(placement: .primaryAction) {
                        Button(Strings.Insights.proBadge) {
                            isPresentingPROUpgrade = true
                        }
                        .fontWeight(.semibold)
                        .accessibilityLabel(Strings.Insights.unlockProAccessibility)
                    }
                }
            }
            .sheet(isPresented: $isPresentingPROUpgrade) {
                PROUpgradeView()
            }
            .task(id: personalRecordClient.records.count) {
                await refreshAnalysis()
            }
            .refreshable {
                await personalRecordClient.fetchRecords()
                await refreshAnalysis()
            }
        }
    }

    private func refreshAnalysis() async {
        viewState = .loading
        if personalRecordClient.records.isEmpty {
            await personalRecordClient.fetchRecords()
        }
        await workoutEngineClient.analyze(records: personalRecordClient.records)
        viewState = .loaded
    }
}

private struct InsightRow: View {
    let insight: WorkoutInsight
    let onUpgrade: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(insight.title)
                    .font(.headline)
                if insight.requiresPro {
                    Text(Strings.Insights.proBadge)
                        .font(.caption2.bold())
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.2))
                        .clipShape(Capsule())
                }
            }

            if insight.requiresPro && insight.category == .proTeaser {
                Text(insight.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Button(Strings.Insights.unlockPro, action: onUpgrade)
                    .font(.subheadline.bold())
            } else {
                Text(insight.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
