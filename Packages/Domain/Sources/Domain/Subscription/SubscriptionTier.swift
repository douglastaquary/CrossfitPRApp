import Foundation

/// Tier de assinatura — define o que o usuário pode acessar.
public enum SubscriptionTier: String, Sendable, Codable, CaseIterable {
    case free
    case pro
    case elite
}

/// Feature flags por tier — Free → PRO → Elite (CPR-008).
public enum ProFeature: String, Sendable, CaseIterable {
    case basicInsights
    case detailedAIAnalysis
    case trendCharts
    case workoutEngineAnalysis
    case personalizedRecommendations
    case exportHistory
    case athleteAssessment
    case limitingFactorAnalysis

    public var isAvailableInFreeTier: Bool {
        switch self {
        case .basicInsights: return true
        default: return false
        }
    }

    /// Features exclusivas do tier Elite (CPR-008).
    public var isEliteOnly: Bool {
        switch self {
        case .athleteAssessment, .limitingFactorAnalysis: return true
        default: return false
        }
    }
}

public extension SubscriptionTier {
    /// PRO ou Elite — desbloqueia superfícies pagas (Insights PRO, percentuais, etc.).
    var isPaid: Bool {
        switch self {
        case .pro, .elite: return true
        case .free: return false
        }
    }

    func canAccess(_ feature: ProFeature) -> Bool {
        switch self {
        case .elite:
            return true
        case .pro:
            return !feature.isEliteOnly
        case .free:
            return feature.isAvailableInFreeTier
        }
    }
}
