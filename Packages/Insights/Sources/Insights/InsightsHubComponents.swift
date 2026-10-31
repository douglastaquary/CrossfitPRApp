import SwiftUI
import Charts
import Domain
import Application
import Subscription
import Localization
import SharedUI

// MARK: - Metric cell (Fitness-like)

struct InsightsMetricCell: View {
    let label: String
    let value: String
    var compact: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(AppDesign.Typography.metricLabel)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(value)
                .font(compact ? AppDesign.Typography.rowValue.weight(.bold) : AppDesign.Typography.metricValue)
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Summary

struct InsightsSummarySection: View {
    let records: [PersonalRecord]
    let measureMode: MeasureTrackingMode

    private var uniqueMovements: Int {
        Set(records.map { $0.prName.lowercased() }).count
    }

    private var bestLift: PersonalRecord? {
        records.filter { $0.group == .barbell }.max { $0.poundValue < $1.poundValue }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Strings.Insights.Hub.summaryTitle)
                .font(AppDesign.Typography.sectionTitle)

            HStack(spacing: 16) {
                InsightsMetricCell(label: Strings.Insights.Hub.prsLabel, value: "\(records.count)")
                InsightsMetricCell(label: Strings.Insights.Hub.consistencyLabel, value: "\(uniqueMovements)")
                if let best = bestLift {
                    let w = measureMode == .pounds ? best.poundValue : best.kiloValue
                    InsightsMetricCell(
                        label: Strings.Insights.Hub.bestLiftLabel,
                        value: "\(w) \(measureMode.suffix)"
                    )
                }
            }
            .padding()
            .background(AppDesign.Colors.cardBackground)
            .cornerRadius(12)
        }
    }
}

// MARK: - Last session + Health

struct InsightsLastSessionSection: View {
    @EnvironmentObject private var workoutSessionClient: WorkoutSessionClient
    @EnvironmentObject private var healthMetricsClient: HealthMetricsClient
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient

    private var session: CrossFitWorkoutSession? {
        workoutSessionClient.latestSession
    }

    private var metrics: SessionBiometrics? {
        session?.metrics ?? healthMetricsClient.latestMetrics
    }

    private var hasRecoveryEvents: Bool {
        WatchSessionEventStore.shared.recentEvents().contains {
            $0.phase == "breath" || $0.phase == "rest" || $0.phase == "wod_rest"
        }
    }

    var body: some View {
        Group {
            if let session {
                VStack(alignment: .leading, spacing: 12) {
                    Text(Strings.Insights.Hub.sessionTitle)
                        .font(AppDesign.Typography.sectionTitle)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(session.title)
                            .font(AppDesign.Typography.insightCardTitle)
                        Text(session.style.rawValue.uppercased() + (session.score.isEmpty ? "" : " · \(session.score)"))
                            .font(AppDesign.Typography.captionSecondary)
                            .foregroundStyle(.secondary)

                        if let metrics, metrics.hasAnyMetric {
                            metricsGrid(metrics, sessionDuration: session.duration)
                        } else if !healthMetricsClient.authorizationGranted {
                            Text(Strings.Insights.Hub.connectHealth)
                                .font(AppDesign.Typography.captionSecondary)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(AppDesign.Colors.cardBackground)
                    .cornerRadius(12)

                    if hasRecoveryEvents {
                        recoveryCard
                    }
                }
            } else if let metrics = healthMetricsClient.latestMetrics, metrics.hasAnyMetric {
                VStack(alignment: .leading, spacing: 12) {
                    Text(Strings.Insights.Hub.sessionTitle)
                        .font(AppDesign.Typography.sectionTitle)
                    metricsGrid(metrics, sessionDuration: metrics.exerciseTime ?? 0)
                        .padding()
                        .background(AppDesign.Colors.cardBackground)
                        .cornerRadius(12)
                }
            }
        }
        .task(id: personalRecordClient.records.count) {
            await workoutSessionClient.fetchSessions()
            await healthMetricsClient.refresh()
        }
    }

    private var recoveryCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(Strings.Insights.Hub.recoveryTitle)
                .font(AppDesign.Typography.insightCardTitle)
            Text(Strings.Insights.Hub.recoveryMessage)
                .font(AppDesign.Typography.insightCardBody)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppDesign.Colors.cardBackground)
        .cornerRadius(12)
    }

    private func metricsGrid(_ metrics: SessionBiometrics, sessionDuration: TimeInterval) -> some View {
        let exercise = metrics.exerciseTime ?? sessionDuration
        let cells: [(String, String)] = {
            var items: [(String, String)] = []
            if let active = metrics.activeCalories {
                items.append((Strings.Insights.Hub.activeCalories, "\(Int(active.rounded()))"))
            }
            if let total = metrics.totalCalories {
                items.append((Strings.Insights.Hub.totalCalories, "\(Int(total.rounded()))"))
            }
            if exercise > 0 {
                items.append((Strings.Insights.Hub.exerciseTime, formatDuration(exercise)))
            }
            if sessionDuration > 0, abs(sessionDuration - exercise) > 1 {
                items.append((Strings.Insights.Hub.duration, formatDuration(sessionDuration)))
            }
            if let hr = metrics.averageHeartRate {
                items.append((Strings.Insights.Hub.averageHR, "\(hr)"))
            }
            return items
        }()

        return LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
            alignment: .leading,
            spacing: 12
        ) {
            ForEach(Array(cells.enumerated()), id: \.offset) { _, cell in
                InsightsMetricCell(label: cell.0, value: cell.1, compact: true)
            }
        }
    }

    private func formatDuration(_ t: TimeInterval) -> String {
        let total = Int(t)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m, s)
        }
        return String(format: "%d:%02d:%02d", 0, m, s)
    }
}

// MARK: - Engine insight cards

struct InsightsEngineCardsSection: View {
    @EnvironmentObject private var workoutEngineClient: WorkoutEngineClient
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @EnvironmentObject private var subscriptionClient: SubscriptionClient

    private var displayInsights: [WorkoutInsight] {
        let allowed: Set<WorkoutInsight.Category> = subscriptionClient.currentTier.isPaid
            ? [.summary, .trend, .workoutEngine, .recommendation]
            : [.summary, .trend]
        return workoutEngineClient.insights.filter { allowed.contains($0.category) }
    }

    var body: some View {
        Group {
            if !displayInsights.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text(Strings.Insights.Hub.engineTitle)
                        .font(AppDesign.Typography.sectionTitle)

                    ForEach(displayInsights) { insight in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(insight.title)
                                .font(AppDesign.Typography.insightCardTitle)
                            Text(insight.message)
                                .font(AppDesign.Typography.insightCardBody)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppDesign.Colors.cardBackground)
                        .cornerRadius(12)
                    }
                }
            }
        }
        .task(id: personalRecordClient.records.count) {
            await workoutEngineClient.analyze(records: personalRecordClient.records)
        }
    }
}

// MARK: - Recent sessions list

struct InsightsRecentSessionsSection: View {
    @EnvironmentObject private var workoutSessionClient: WorkoutSessionClient

    var body: some View {
        Group {
            if workoutSessionClient.sessions.count > 1 {
                VStack(alignment: .leading, spacing: 10) {
                    Text(Strings.Insights.Hub.sessionsTitle)
                        .font(AppDesign.Typography.sectionTitle)
                    ForEach(workoutSessionClient.sessions.prefix(3)) { session in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(session.title)
                                    .font(AppDesign.Typography.insightCardTitle)
                                Text(session.score.isEmpty ? session.style.rawValue : session.score)
                                    .font(AppDesign.Typography.captionSecondary)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(session.date, style: .date)
                                .font(AppDesign.Typography.captionSecondary)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }
                .padding()
                .background(AppDesign.Colors.cardBackground)
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - Free chart teaser

struct InsightsFreeChartTeaser: View {
    let records: [PersonalRecord]
    let measureMode: MeasureTrackingMode

    /// Um ponto por movimento (melhor lift) — evita eixo de datas sobreposto.
    private var chartRows: [(name: String, value: Double)] {
        let barbell = InsightsRanking.records(for: .barbell, in: records)
        let grouped = Dictionary(grouping: barbell, by: \.prName)
        return grouped.keys.sorted().compactMap { name -> (String, Double)? in
            guard let best = grouped[name]?.max(by: {
                (measureMode == .pounds ? $0.poundValue : $0.kiloValue)
                    < (measureMode == .pounds ? $1.poundValue : $1.kiloValue)
            }) else { return nil }
            let value = Double(measureMode == .pounds ? best.poundValue : best.kiloValue)
            let short = name.localizedWorkoutTitle
            return (short, value)
        }
        .prefix(6)
        .map { ($0.0, $0.1) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Strings.Insights.Hub.chartTeaserTitle)
                .font(AppDesign.Typography.sectionTitle)

            if chartRows.isEmpty {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppDesign.Colors.brand.opacity(0.12))
                    .frame(height: 160)
                    .overlay {
                        Image(systemName: "chart.bar.fill")
                            .font(.largeTitle)
                            .foregroundStyle(AppDesign.Colors.brand.opacity(0.5))
                    }
            } else {
                Chart {
                    ForEach(chartRows, id: \.name) { row in
                        BarMark(
                            x: .value("Move", row.name),
                            y: .value("Value", row.value)
                        )
                        .foregroundStyle(AppDesign.Colors.brand)
                    }
                }
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel()
                            .font(.caption2)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 180)
            }
        }
    }
}

// MARK: - Locked PRO upsell (compact)

struct InsightsLockedUpsellSection: View {
    @Binding var isPresentingPROUpgrade: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lock.fill")
                    .foregroundStyle(AppDesign.Colors.proAccent)
                Text(Strings.Insights.Hub.lockedTitle)
                    .font(AppDesign.Typography.insightCardTitle)
                Spacer()
                Text(Strings.Insights.proBadge)
                    .font(AppDesign.Typography.proBadge)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(AppDesign.Colors.proAccent)
                    .foregroundStyle(.white)
                    .cornerRadius(4)
            }

            Text(Strings.Insights.Hub.lockedMessage)
                .font(AppDesign.Typography.insightCardBody)
                .foregroundStyle(.secondary)

            Button {
                isPresentingPROUpgrade = true
            } label: {
                Text(Strings.Insights.Hub.upgradeCTA)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppDesign.Colors.brand)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
            }
            .accessibilityIdentifier("insights.teaser.pro.cta")
        }
        .padding()
        .background(AppDesign.Colors.cardBackground)
        .cornerRadius(12)
    }
}
