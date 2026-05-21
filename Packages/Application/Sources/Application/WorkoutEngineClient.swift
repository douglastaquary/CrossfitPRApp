import Foundation
import Combine
import Domain
import WorkoutEngine
import Subscription

/// Cliente de aplicação — compõe WorkoutEngine + tier de assinatura.
@MainActor
public final class WorkoutEngineClient: ObservableObject {
    private let engine: any WorkoutInsightsProviding
    private let subscriptionClient: SubscriptionClient

    @Published public private(set) var insights: [WorkoutInsight] = []
    @Published public private(set) var isAnalyzing = false

    public init(
        engine: any WorkoutInsightsProviding = WorkoutEngine(),
        subscriptionClient: SubscriptionClient
    ) {
        self.engine = engine
        self.subscriptionClient = subscriptionClient
    }

    public func analyze(records: [PersonalRecord]) async {
        isAnalyzing = true
        defer { isAnalyzing = false }

        let tier = subscriptionClient.currentTier
        insights = await engine.generateInsights(from: records, tier: tier)
    }
}
