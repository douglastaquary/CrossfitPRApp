import Foundation
import Domain

/// API central de strings localizadas (pt-BR + en).
public enum Strings {
    public static func tr(_ key: String) -> String {
        NSLocalizedString(key, bundle: .module, comment: "")
    }

    public static func format(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: tr(key), locale: Locale.current, arguments: arguments)
    }

    // MARK: - Onboarding

    public enum Onboarding {
        public static var title: String { tr("onboarding.title") }
        public static var subtitle: String { tr("onboarding.subtitle") }
        public static var loading: String { tr("onboarding.loading") }
        public static var icloudMessage: String { tr("onboarding.icloudMessage") }
        public static var cta: String { tr("onboarding.cta") }
    }

    // MARK: - Tabs

    public enum Tab {
        public static var prs: String { tr("tab.prs") }
        public static var evolution: String { tr("tab.evolution") }
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
        public static var cancel: String { tr("newPR.cancel") }
        public static var save: String { tr("newPR.save") }
        public static var saveFallbackError: String { tr("newPR.saveFallbackError") }

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
    }
}
