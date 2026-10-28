import Foundation
import Domain
import Coaching

@MainActor
public final class CoachingClient: ObservableObject {
    @Published public private(set) var latestInsight: CoachingInsight?
    @Published public private(set) var isLoading = false
    @Published public private(set) var lastError: CoachingError?

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

        let snapshot = builder.build(from: records, engineInsights: engineInsights)
        if !force, let cached = cache.insight(for: snapshot.contextHash) {
            latestInsight = CoachingInsight(
                workoutSuggestion: cached.workoutSuggestion,
                focusLifts: cached.focusLifts,
                repScheme: cached.repScheme,
                rationale: cached.rationale,
                runtime: cached.runtime,
                estimatedInputTokens: cached.estimatedInputTokens,
                cacheHit: true
            )
            return
        }

        let runtime = router.preferredRuntime(isOnDeviceAvailable: isOnDeviceAvailable())
        let applied = budget.apply(snapshot, tier: tier, runtime: runtime)
        if applied.limits.maxInputTokens == 0 {
            lastError = .tierNotEligible
            return
        }

        let adapter = router.adapter(for: runtime)
        do {
            var insight = try await adapter.generateCoaching(snapshot: applied.snapshot, tier: tier)
            if insight.rationale.count > applied.limits.maxRationaleChars {
                insight.rationale = String(insight.rationale.prefix(applied.limits.maxRationaleChars))
            }
            insight.estimatedInputTokens = applied.estimatedInputTokens
            cache.store(insight, contextHash: snapshot.contextHash)
            latestInsight = insight
        } catch let error as CoachingError {
            lastError = error
            let fallback = router.adapter(for: .summarizedLocal)
            if let summarized = try? await fallback.generateCoaching(snapshot: applied.snapshot, tier: tier) {
                latestInsight = summarized
            }
        } catch {
            lastError = .adapterUnavailable
        }
    }
}
