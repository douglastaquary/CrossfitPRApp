import Foundation

/// Tier de assinatura — define o que o usuário pode acessar.
public enum SubscriptionTier: String, Sendable, Codable, CaseIterable {
    case free
    case pro
}

/// Feature flags por tier — usado para conversão Free → PRO.
public enum ProFeature: String, Sendable, CaseIterable {
    case basicInsights
    case detailedAIAnalysis
    case trendCharts
    case workoutEngineAnalysis
    case personalizedRecommendations
    case exportHistory

    public var isAvailableInFreeTier: Bool {
        switch self {
        case .basicInsights: return true
        default: return false
        }
    }
}

public extension SubscriptionTier {
    func canAccess(_ feature: ProFeature) -> Bool {
        switch self {
        case .pro: return true
        case .free: return feature.isAvailableInFreeTier
        }
    }
}
