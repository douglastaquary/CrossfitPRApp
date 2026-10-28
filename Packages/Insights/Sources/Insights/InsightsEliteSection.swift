import SwiftUI
import Domain
import Application
import Subscription
import PROUpgrade
import Localization
import SharedUI

/// Assessment + limiting factor (Elite) e teaser (PRO) — CPR-008 Design.
struct InsightsEliteSection: View {
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @EnvironmentObject private var workoutEngineClient: WorkoutEngineClient
    @EnvironmentObject private var subscriptionClient: SubscriptionClient
    @State private var showUpgrade = false

    private var isElite: Bool {
        subscriptionClient.currentTier == .elite
    }

    private var assessmentInsight: WorkoutInsight? {
        workoutEngineClient.insights.first { $0.category == .eliteAssessment }
    }

    private var limitingInsight: WorkoutInsight? {
        workoutEngineClient.insights.first { $0.category == .eliteLimitingFactor }
    }

    private var teaserInsight: WorkoutInsight? {
        workoutEngineClient.insights.first { $0.category == .eliteTeaser }
    }

    var body: some View {
        Group {
            if isElite {
                eliteContent
            } else if subscriptionClient.currentTier == .pro, teaserInsight != nil {
                teaserContent
            }
        }
        .task(id: personalRecordClient.records.count) {
            await workoutEngineClient.analyze(records: personalRecordClient.records)
        }
        .sheet(isPresented: $showUpgrade) {
            PROUpgradeView()
        }
    }

    private var eliteContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: AppDesign.Icon.eliteBadge)
                    .foregroundStyle(AppDesign.Colors.eliteAccent)
                Text(Strings.Elite.insightsHeader)
                    .font(.headline)
                Spacer()
                Text(Strings.Elite.badge)
                    .font(AppDesign.Typography.proBadge)
                    .padding(.horizontal, AppDesign.Layout.proBadgeHorizontalPadding)
                    .padding(.vertical, AppDesign.Layout.proBadgeVerticalPadding)
                    .background(AppDesign.Colors.eliteAccent)
                    .foregroundStyle(.white)
                    .cornerRadius(4)
            }

            if let assessmentInsight {
                EliteAssessmentCard(insight: assessmentInsight)
            }

            if let limitingInsight {
                EliteLimitingFactorCard(insight: limitingInsight)
            }
        }
        .accessibilityIdentifier("insights.elite.section")
    }

    private var teaserContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: AppDesign.Icon.eliteBadge)
                    .foregroundStyle(AppDesign.Colors.eliteAccent)
                Text(Strings.Engine.eliteTeaserTitle)
                    .font(.subheadline.weight(.semibold))
                Spacer()
            }

            if let teaserInsight {
                Text(teaserInsight.message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Button {
                showUpgrade = true
            } label: {
                Text(Strings.Elite.teaserCTA)
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(AppDesign.Colors.eliteAccent)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(AppDesign.Colors.eliteAccent.opacity(0.1))
        .cornerRadius(12)
        .accessibilityIdentifier("insights.elite.teaser")
    }
}

struct EliteAssessmentCard: View {
    let insight: WorkoutInsight

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(insight.title)
                .font(.subheadline.weight(.semibold))
            Text(insight.message)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AppDesign.Colors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppDesign.Colors.eliteAccent.opacity(0.4), lineWidth: 1)
        )
    }
}

struct EliteLimitingFactorCard: View {
    let insight: WorkoutInsight

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "target")
                    .foregroundStyle(AppDesign.Colors.eliteAccent)
                Text(insight.title)
                    .font(.subheadline.weight(.semibold))
            }
            Text(insight.message)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AppDesign.Colors.eliteAccent.opacity(0.08))
        .cornerRadius(12)
    }
}
