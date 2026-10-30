import Foundation
import Domain

/// API central de strings localizadas (pt-BR + en).
public enum Strings {
    public static func tr(_ key: String) -> String {
        LocalizationBundle.string(for: key)
    }

    public static func format(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: tr(key), locale: Locale.current, arguments: arguments)
    }

    // MARK: - Onboarding

    public enum Onboarding {
        public static var title: String { tr("onboarding.view.title") }
        public static var subtitle: String { tr("onboarding.subtitle") }
        public static var loading: String { tr("loading.view.title") }
        public static var icloudMessage: String { tr("onboarding.alert.icloud.account.message") }
        public static var cta: String { tr("onboarding.cta") }
    }

    // MARK: - Tabs (beta — 4 tabs)

    public enum Tab {
        public static var categories: String { tr("tabbar.categories.title") }
        public static var records: String { tr("tabbar.myrecords.title") }
        public static var insights: String { tr("tabbar.insights.title") }
        public static var settings: String { tr("tabbar.settings.title") }
        // Legacy
        public static var prs: String { records }
        public static var evolution: String { insights }
    }

    // MARK: - Screens

    public enum Screen {
        public static var records: String { tr("screen.records.title") }
        public static var category: String { tr("screen.category.title") }
        public static var insights: String { tr("screen.insights.title") }
        public static var settings: String { tr("screen.settings.title") }
    }

    public enum Category {
        public static var searchPrompt: String { tr("category.search.descript") }
        public static var listHeader: String { tr("exercises.list.header.descript") }
        public static var listTipEmoji: String { tr("category.list.tip.emoji") }
    }

    public enum Purchase {
        public static var monthlyPlan: String { tr("purchase.plan.monthly") }
        public static var annualPlan: String { tr("purchase.plan.annual") }
        public static var bestValueBadge: String { tr("purchase.plan.bestValue") }
        public static var selectPlanRequired: String { tr("purchase.selectPlan.required") }
        public static var retry: String { tr("purchase.retry") }
        public static var close: String { tr("purchase.close") }
        public static var continueToPayment: String { tr("purchase.continueToPayment") }
        public static var restore: String { tr("purchase.restore") }
        public static var restoreHint: String { tr("purchase.restore.hint") }
        public static var restoreNothingFound: String { tr("purchase.restore.nothingFound") }
        public static var restoreNothingFoundDetail: String { tr("purchase.restore.nothingFound.detail") }
        public static var stateConnecting: String { tr("purchase.state.connecting") }
        public static var stateConnectingDetail: String { tr("purchase.state.connecting.detail") }
        public static var stateProcessing: String { tr("purchase.state.processing") }
        public static var stateProcessingDetail: String { tr("purchase.state.processing.detail") }
        public static var stateConfirming: String { tr("purchase.state.confirming") }
        public static var stateConfirmingDetail: String { tr("purchase.state.confirming.detail") }
        public static var stateSuccess: String { tr("purchase.state.success") }
        public static var stateSuccessDetail: String { tr("purchase.state.success.detail") }
        public static var statePending: String { tr("purchase.state.pending") }
        public static var statePendingDetail: String { tr("purchase.state.pending.detail") }
        public static var errorTitle: String { tr("purchase.error.title") }
        public static var renewNote: String { tr("purchase.renew.note") }
    }

    public enum Record {
        public static var biggestSection: String { tr("record.biggest.section.title") }
        public static var percentageSection: String { tr("record.datail.section.percentage.title") }
        public static var recordsSection: String { tr("record.records.section.title") }
        public static var deleteConfirmation: String { tr("record.screen.delete.confirmation.title") }
        public static var deleteButton: String { tr("record.screen.delete.button.title") }

        public static func evolutionSection(_ name: String) -> String {
            format("record.evolution.section.title %@", name)
        }
    }

    public enum Settings {
        public static var notificationSection: String { tr("settings.screen.section.notification.title") }
        public static var notificationToggle: String { tr("settings.screen.section.notification.toggle.title") }
        public static var trackingSection: String { tr("settings.screen.section.tracking.title") }
        public static var measureTitle: String { tr("settings.screen.section.tracking.measure.title") }
        public static var proSection: String { tr("settings.screen.section.crossfitpro.title") }
        public static var noCommitment: String { tr("settings.screen.section.nocommitment.title") }
        public static var unlockPro: String { tr("settings.screen.section.unlockpro.title") }
        public static var aboutSection: String { tr("settings.screen.section.about.title") }
        public static var privacy: String { tr("settings.screen.section.privacy.title") }

        public enum NotificationReminder {
            public static var titleOptions: [String] {
                [tr("settings.notification.reminder.title1"), tr("settings.notification.reminder.title2")]
            }

            public static var bodyOptions: [String] {
                [tr("settings.notification.reminder.body1"), tr("settings.notification.reminder.body2")]
            }
        }

        public enum Pro {
            public static var subscriptionActive: String { tr("settings.pro.subscriptionActive") }
            public static var cancelSubscription: String { tr("settings.pro.cancelSubscription") }
            public static var cancelAlertTitle: String { tr("settings.pro.cancelAlert.title") }
            public static var cancelAlertMessage: String { tr("settings.pro.cancelAlert.message") }
            public static var cancelAlertKeep: String { tr("settings.pro.cancelAlert.keep") }
            public static var cancelAlertConfirm: String { tr("settings.pro.cancelAlert.confirm") }
            public static var eliteSubscriptionActive: String { tr("settings.elite.subscriptionActive") }
            public static var unlockElite: String { tr("settings.elite.unlock") }
            public static var managePlan: String { tr("settings.elite.managePlan") }
        }
    }

    public enum App {
        public static var name: String { tr("app.name") }
    }

    public enum Launch {
        public static var offlineHeadline: String { tr("launch.offline.headline") }
        public static var offlineMessage: String { tr("launch.offline.message") }
        public static var offlineRetry: String { tr("launch.offline.retry") }
        public static var networkAlertTitle: String { tr("launch.networkAlertTitle") }
        public static var networkAlertMessage: String { tr("launch.networkAlertMessage") }
        public static var networkAlertCancel: String { tr("launch.networkAlertCancel") }
    }

    // MARK: - PR History

    public enum PRHistory {
        public static var title: String { tr("prHistory.title") }
        public static var loading: String { tr("prHistory.loading") }
        public static var errorTitle: String { tr("prHistory.errorTitle") }
        public static var retry: String { tr("prHistory.retry") }
        public static var emptyTitle: String { tr("prHistory.emptyTitle") }
        public static var emptyMessage: String { tr("prHistory.emptyMessage") }
        public static var registerButton: String { tr("prHistory.registerButton") }
    }

    // MARK: - New PR

    public enum NewPR {
        public static var title: String { tr("newPR.title") }
        public static var sectionExercise: String { tr("newPR.sectionExercise") }
        public static var sectionPR: String { tr("newPR.sectionPR") }
        public static var pickerExercise: String { tr("newPR.pickerExercise") }
        public static var dateLabel: String { tr("newPR.dateLabel") }
        public static var cancel: String { tr("newRecord.screen.cancel.button.title") }
        public static var save: String { tr("newRecord.screen.save.button.title") }
        public static var saveFallbackError: String { tr("newPR.saveFallbackError") }
        public static var sectionPercentage: String { tr("newRecord.screen.section.informations.percentage.title") }
        public static var sectionWeight: String { tr("newRecord.screen.section.informations.weight.title") }
        public static var sectionMaxReps: String { tr("newRecord.screen.toggle.maxrep.title") }
        public static var sectionTime: String { tr("newRecord.screen.picker.timecount.title") }
        public static var sectionDistance: String { tr("newRecord.screen.toggle.distance.title") }
        public static var sectionComment: String { tr("newRecord.screen.section.comment.title") }
        public static var commentPlaceholder: String { tr("newRecord.screen.section.comment.description") }

        public static func weight(_ pounds: Int) -> String {
            format("newPR.weightFormat", pounds)
        }
    }

    // MARK: - Insights

    public enum Insights {
        public static var title: String { tr("insights.title") }
        public static var loading: String { tr("insights.loading") }
        public static var emptyTitle: String { tr("insights.emptyTitle") }
        public static var emptyMessage: String { tr("insights.emptyMessage") }
        public static var proBadge: String { tr("insights.proBadge") }
        public static var unlockPro: String { tr("insights.unlockPro") }
        public static var unlockProAccessibility: String { tr("insights.unlockProAccessibility") }

        public enum Teaser {
            public static var emptyTitle: String { tr("insight.teaser.empty.title") }
            public static var emptyMessage: String { tr("insight.teaser.empty.message") }
            public static var emptyCTA: String { tr("insight.teaser.empty.cta") }
            public static var previewHeader: String { tr("insight.teaser.preview.header") }
            public static var statsRegistered: String { tr("insight.teaser.stats.registered") }
            public static var statsTopPR: String { tr("insight.teaser.stats.topPR") }
            public static var categoriesHeader: String { tr("insight.teaser.categories.header") }
            public static var benefitsHeader: String { tr("insight.teaser.benefits.header") }
        }

        public enum Coach {
            public static var title: String { tr("insight.coach.title") }
            public static var refresh: String { tr("insight.coach.refresh") }
            public static var placeholder: String { tr("insight.coach.placeholder") }
            public static var runtimeOnDevice: String { tr("insight.coach.runtime.onDevice") }
            public static var runtimeCloud: String { tr("insight.coach.runtime.cloud") }
            public static var runtimeSummarized: String { tr("insight.coach.runtime.summarized") }
            public static var cacheHit: String { tr("insight.coach.cacheHit") }
        }

        public enum ProEmpty {
            public static var title: String { tr("insight.pro.empty.title") }
            public static var message: String { tr("insight.pro.empty.message") }
            public static var cta: String { tr("insight.pro.empty.cta") }
            public static var featureRankingTitle: String { tr("insight.pro.empty.feature.ranking.title") }
            public static var featureRankingDescription: String { tr("insight.pro.empty.feature.ranking.description") }
            public static var featureChartsTitle: String { tr("insight.pro.empty.feature.charts.title") }
            public static var featureChartsDescription: String { tr("insight.pro.empty.feature.charts.description") }
            public static var featureGoalsTitle: String { tr("insight.pro.empty.feature.goals.title") }
            public static var featureGoalsDescription: String { tr("insight.pro.empty.feature.goals.description") }
        }
    }

    // MARK: - PRO

    public enum PRO {
        public static var productName: String { tr("pro.productName") }
        public static var title: String { tr("pro.title") }
        public static var subtitle: String { tr("pro.subtitle") }
        public static var sectionBenefits: String { tr("pro.sectionBenefits") }
        public static var unlockButton: String { tr("pro.unlockButton") }
        public static var close: String { tr("pro.close") }
        public static var purchaseFallbackError: String { tr("pro.purchaseFallbackError") }

        public enum Upgrade {
            public static var choosePlan: String { tr("pro.upgrade.choosePlan") }
            public static var productsUnavailableTitle: String { tr("pro.upgrade.productsUnavailable.title") }
            public static var productsUnavailableMessage: String { tr("pro.upgrade.productsUnavailable.message") }
            public static var genericError: String { tr("pro.upgrade.error.generic") }
        }
    }

    // MARK: - Watch (CPR-009 POC)

    public enum Watch {
        public static var galleryTitle: String { tr("watch.gallery.title") }
        public static var galleryNext: String { tr("watch.gallery.next") }
        public static var sessionTitle: String { tr("watch.session.title") }
        public static var sessionTip: String { tr("watch.session.tip") }
        public static var restLabel: String { tr("watch.rest.label") }
        public static var restMotivation: String { tr("watch.rest.motivation") }
        public static var breathTitle: String { tr("watch.breath.title") }
        public static var breathPattern: String { tr("watch.breath.pattern") }
        public static var breathInhale: String { tr("watch.breath.inhale") }
    }

    // MARK: - Elite (CPR-008)

    public enum Elite {
        public static var title: String { tr("elite.title") }
        public static var subtitle: String { tr("elite.subtitle") }
        public static var competitorMode: String { tr("elite.competitorMode") }
        public static var badge: String { tr("elite.badge") }
        public static var planFree: String { tr("elite.plan.free") }
        public static var planPro: String { tr("elite.plan.pro") }
        public static var planElite: String { tr("elite.plan.elite") }
        public static var benefitAssessment: String { tr("elite.benefit.assessment") }
        public static var benefitLimiting: String { tr("elite.benefit.limiting") }
        public static var benefitDense: String { tr("elite.benefit.dense") }
        public static var chooseElitePlan: String { tr("elite.choosePlan") }
        public static var monthlyPlan: String { tr("elite.monthlyPlan") }
        public static var annualPlan: String { tr("elite.annualPlan") }
        public static var sectionCompare: String { tr("elite.sectionCompare") }
        public static var unlockCTA: String { tr("elite.unlockCTA") }
        public static var insightsHeader: String { tr("elite.insights.header") }
        public static var teaserCTA: String { tr("elite.teaser.cta") }
    }

    // MARK: - Exercises

    public enum Exercise {
        public static func name(_ kind: ActivityKind) -> String {
            switch kind {
            case .empty: return tr("exercise.empty")
            case .airSquat: return tr("exercise.airSquat")
            case .backSquat: return tr("exercise.backSquat")
            case .barMuscleUp: return tr("exercise.barMuscleUp")
            case .benchPress: return tr("exercise.benchPress")
            case .boxJump: return tr("exercise.boxJump")
            case .burpee: return tr("exercise.burpee")
            case .clean: return tr("exercise.clean")
            case .cleanAndJerk: return tr("exercise.cleanAndJerk")
            case .deadlift: return tr("exercise.deadlift")
            }
        }
    }

    // MARK: - Pro features

    public enum ProFeatureCopy {
        public static func marketingTitle(_ feature: ProFeature) -> String {
            switch feature {
            case .basicInsights: return tr("proFeature.basicInsights")
            case .detailedAIAnalysis: return tr("proFeature.detailedAIAnalysis")
            case .trendCharts: return tr("proFeature.trendCharts")
            case .workoutEngineAnalysis: return tr("proFeature.workoutEngineAnalysis")
            case .personalizedRecommendations: return tr("proFeature.personalizedRecommendations")
            case .exportHistory: return tr("proFeature.exportHistory")
            case .athleteAssessment: return tr("proFeature.athleteAssessment")
            case .limitingFactorAnalysis: return tr("proFeature.limitingFactorAnalysis")
            }
        }
    }

    // MARK: - Errors

    public enum ErrorCopy {
        public static func repository(_ error: PersonalRecordRepositoryError) -> String {
            switch error {
            case .notFound: return tr("error.repo.notFound")
            case .syncFailed: return tr("error.repo.syncFailed")
            case .invalidData: return tr("error.repo.invalidData")
            }
        }

        public static func subscription(_ error: SubscriptionError) -> String {
            switch error {
            case .purchaseFailed: return tr("error.sub.purchaseFailed")
            case .productUnavailable: return tr("error.sub.productUnavailable")
            case .userCancelled: return ""
            case .pending: return tr("error.sub.pending")
            }
        }

        public enum ClientOperation {
            case fetch, save, delete

            public var generic: String {
                switch self {
                case .fetch: return tr("error.client.fetchGeneric")
                case .save: return tr("error.client.saveGeneric")
                case .delete: return tr("error.client.deleteGeneric")
                }
            }

            public var persistence: String {
                switch self {
                case .fetch: return tr("error.client.fetchPersistence")
                case .save: return tr("error.client.savePersistence")
                case .delete: return tr("error.client.deletePersistence")
                }
            }
        }
    }

    // MARK: - WorkoutEngine

    public enum Engine {
        public static var emptyTitle: String { tr("engine.empty.title") }
        public static var emptyMessage: String { tr("engine.empty.message") }
        public static var summaryTitle: String { tr("engine.summary.title") }
        public static var consistencyTitle: String { tr("engine.consistency.title") }
        public static var teaserTitle: String { tr("engine.teaser.title") }
        public static var trendEncouragementUp: String { tr("engine.trend.encouragementUp") }
        public static var trendEncouragementDown: String { tr("engine.trend.encouragementDown") }
        public static var trendImproved: String { tr("engine.trend.improved") }
        public static var trendDeclined: String { tr("engine.trend.declined") }

        public static func latestRecord(exercise: String, pounds: Int) -> String {
            format("engine.summary.latestFormat", exercise, pounds)
        }

        public static func summaryMessage(count: Int, exercises: Int, latest: String) -> String {
            format("engine.summary.message", count, exercises, latest)
        }

        public static func trendTitle(exercise: String) -> String {
            format("engine.trend.title", exercise)
        }

        public static func trendMessageImproved(delta: Int, encouragement: String) -> String {
            format("engine.trend.message", Strings.Engine.trendImproved, delta, encouragement)
        }

        public static func trendMessageDeclined(delta: Int, encouragement: String) -> String {
            format("engine.trend.message", Strings.Engine.trendDeclined, delta, encouragement)
        }

        public static func plateauTitle(exercise: String) -> String {
            format("engine.plateau.title", exercise)
        }

        public static func plateauMessage(weight: Int) -> String {
            format("engine.plateau.message", weight)
        }

        public static func consistencyMessage(count: Int) -> String {
            format("engine.consistency.message", count)
        }

        public static func targetTitle(exercise: String) -> String {
            format("engine.target.title", exercise)
        }

        public static func targetMessage(projected: Int) -> String {
            format("engine.target.message", projected)
        }

        public static func teaserMessage(count: Int) -> String {
            format("engine.teaser.message", count)
        }

        public static var assessmentTitle: String { tr("engine.assessment.title") }
        public static var limitingFactorTitle: String { tr("engine.limitingFactor.title") }
        public static var eliteTeaserTitle: String { tr("engine.eliteTeaser.title") }
        public static var domainStrength: String { tr("engine.domain.strength") }
        public static var domainOlympic: String { tr("engine.domain.olympic") }
        public static var domainGymnastics: String { tr("engine.domain.gymnastics") }
        public static var domainEngine: String { tr("engine.domain.engine") }
        public static var assessmentGenericDomain: String { tr("engine.assessment.genericDomain") }

        public static func assessmentMessage(lines: String) -> String {
            format("engine.assessment.message", lines)
        }

        public static func assessmentDomainLine(domain: String, percent: Int) -> String {
            format("engine.assessment.domainLine", domain, percent)
        }

        public static func limitingFactorMessage(domain: String) -> String {
            format("engine.limitingFactor.message", domain)
        }

        public static func eliteTeaserMessage(domainHint: String) -> String {
            format("engine.eliteTeaser.message", domainHint)
        }
    }
}
