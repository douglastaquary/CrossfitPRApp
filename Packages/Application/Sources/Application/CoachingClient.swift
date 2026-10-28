import Foundation
import Domain
import Coaching

@MainActor
public final class CoachingClient: ObservableObject {
    @Published public private(set) var latestInsight: CoachingInsight?
    @Published public private(set) var isLoading = false
    @Published public private(set) var lastError: CoachingError?
    @Published public private(set) var lastDiagnostics: CoachingRefreshDiagnostics?

    private let builder: CoachingContextBuilder
    private let budget: TokenBudgetPolicy
    private let cache: CoachingInsightCaching
    private let router: CoachingAdapterRouter
    private let isOnDeviceAvailable: () -> Bool

    public init(
        builder: CoachingContextBuilder = CoachingContextBuilder(),
        budget: TokenBudgetPolicy = TokenBudgetPolicy(),
        cache: CoachingInsightCaching = InMemoryCoachingInsightCache(),
        router: CoachingAdapterRouter = CoachingAdapterRouter(),
        isOnDeviceAvailable: @escaping () -> Bool = { false }
    ) {
        self.builder = builder
        self.budget = budget
        self.cache = cache
        self.router = router
        self.isOnDeviceAvailable = isOnDeviceAvailable
    }

    public func refreshCoaching(
        records: [PersonalRecord],
        engineInsights: [WorkoutInsight],
        tier: SubscriptionTier,
        force: Bool = false
    ) async {
        guard tier.canAccess(.detailedAIAnalysis) else {
            latestInsight = nil
            return
        }

        isLoading = true
        lastError = nil
        defer { isLoading = false }

        let watchEvents = WatchSessionEventStore.shared.recentEvents()
        let snapshot = builder.build(from: records, engineInsights: engineInsights, watchEvents: watchEvents)
        if !force, let cached = cache.insight(for: snapshot.contextHash) {
            let insight = CoachingInsight(
                workoutSuggestion: cached.workoutSuggestion,
                focusLifts: cached.focusLifts,
                repScheme: cached.repScheme,
                rationale: cached.rationale,
                runtime: cached.runtime,
                estimatedInputTokens: cached.estimatedInputTokens,
                cacheHit: true
            )
            latestInsight = insight
            let diagnostics = CoachingRefreshDiagnostics(
                runtime: insight.runtime,
                estimatedInputTokens: insight.estimatedInputTokens,
                cacheHit: true
            )
            lastDiagnostics = diagnostics
            CoachingDiagnostics.record(diagnostics)
            return
        }

        let orchestrator = CoachingInferenceOrchestrator(
            router: router,
            isOnDeviceAvailable: isOnDeviceAvailable
        )

        do {
            let result = try await orchestrator.generateInsight(
                snapshot: snapshot,
                tier: tier,
                budget: budget
            )
            cache.store(result.insight, contextHash: snapshot.contextHash)
            latestInsight = result.insight
            let diagnostics = CoachingRefreshDiagnostics(
                runtime: result.insight.runtime,
                estimatedInputTokens: result.insight.estimatedInputTokens,
                cacheHit: result.insight.cacheHit
            )
            lastDiagnostics = diagnostics
            CoachingDiagnostics.record(diagnostics)
        } catch let error as CoachingError {
            lastError = error
        } catch {
            lastError = .adapterUnavailable
        }
    }
}
