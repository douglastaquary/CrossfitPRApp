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
    @EnvironmentObject private var settingsClient: SettingsClient
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
                Text(Strings.Elite.insightsHeader)
                    .font(AppDesign.Typography.sectionTitle)
                Spacer()
                EliteSealBadge(style: .unlocked, showsLabel: true)
            }

            if let assessmentInsight {
                EliteAssessmentCard(insight: assessmentInsight)
            }

            if let limitingInsight {
                EliteLimitingFactorCard(insight: limitingInsight)
            }

            EliteSeasonCard(phase: settingsClient.seasonPhase)
        }
        .accessibilityIdentifier("insights.elite.section")
    }

    private var teaserContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                EliteSealBadge(style: .lockedHint, showsLabel: false)
                Text(Strings.Engine.eliteTeaserTitle)
                    .font(.subheadline.weight(.semibold))
                Spacer()
            }

            if let teaserInsight {
                Text(teaserInsight.message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Text(Strings.Season.teaserBody)
                .font(.footnote)
                .foregroundStyle(.secondary)

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
            HStack(alignment: .firstTextBaseline) {
                Text(insight.title)
                    .font(.subheadline.weight(.semibold))
                Spacer(minLength: 8)
                EliteSealBadge(style: .unlocked, showsLabel: false)
            }
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
                Spacer(minLength: 8)
                EliteSealBadge(style: .unlocked, showsLabel: false)
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

/// Season mode card — CPR-015 (sem programming diário).
struct EliteSeasonCard: View {
    let phase: SeasonPhase

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .foregroundStyle(AppDesign.Colors.eliteAccent)
                Text(Strings.Season.cardTitle)
                    .font(.subheadline.weight(.semibold))
                Spacer(minLength: 8)
                EliteSealBadge(style: .unlocked, showsLabel: false)
            }
            Text(Strings.Season.phaseName(phase))
                .font(.headline)
            Text(Strings.Season.phaseBlurb(phase))
                .font(.footnote)
                .foregroundStyle(.secondary)
            Text(Strings.Season.insightHint)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AppDesign.Colors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppDesign.Colors.eliteAccent.opacity(0.35), lineWidth: 1)
        )
        .accessibilityIdentifier("insights.elite.season")
    }
}
