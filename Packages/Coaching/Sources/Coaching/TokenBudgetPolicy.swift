import Foundation
import Domain

public struct TokenBudgetLimits: Sendable, Equatable {
    public var maxInputTokens: Int
    public var maxOutputTokens: Int
    public var maxMovements: Int
    public var maxRationaleChars: Int

    public init(
        maxInputTokens: Int,
        maxOutputTokens: Int,
        maxMovements: Int,
        maxRationaleChars: Int
    ) {
        self.maxInputTokens = maxInputTokens
        self.maxOutputTokens = maxOutputTokens
        self.maxMovements = maxMovements
        self.maxRationaleChars = maxRationaleChars
    }
}

public struct TokenBudgetPolicy: Sendable {
    public init() {}

    public func limits(for tier: SubscriptionTier, runtime: CoachingRuntime) -> TokenBudgetLimits {
        switch tier {
        case .free:
            return TokenBudgetLimits(maxInputTokens: 0, maxOutputTokens: 0, maxMovements: 0, maxRationaleChars: 0)
        case .pro:
            switch runtime {
            case .onDeviceApple:
                return TokenBudgetLimits(maxInputTokens: 2_048, maxOutputTokens: 512, maxMovements: 12, maxRationaleChars: 280)
            case .cloud:
                return TokenBudgetLimits(maxInputTokens: 1_024, maxOutputTokens: 320, maxMovements: 8, maxRationaleChars: 200)
            case .summarizedLocal:
                return TokenBudgetLimits(maxInputTokens: 512, maxOutputTokens: 160, maxMovements: 6, maxRationaleChars: 160)
            }
        case .elite:
            switch runtime {
            case .onDeviceApple:
                return TokenBudgetLimits(maxInputTokens: 3_072, maxOutputTokens: 768, maxMovements: 16, maxRationaleChars: 360)
            case .cloud:
                return TokenBudgetLimits(maxInputTokens: 1_536, maxOutputTokens: 480, maxMovements: 14, maxRationaleChars: 280)
            case .summarizedLocal:
                return TokenBudgetLimits(maxInputTokens: 768, maxOutputTokens: 240, maxMovements: 10, maxRationaleChars: 200)
            }
        }
    }

    public func apply(_ snapshot: CoachingContextSnapshot, tier: SubscriptionTier, runtime: CoachingRuntime) -> (
        snapshot: CoachingContextSnapshot,
        limits: TokenBudgetLimits,
        estimatedInputTokens: Int
    ) {
        let limits = limits(for: tier, runtime: runtime)
        var trimmed = snapshot
        if trimmed.movements.count > limits.maxMovements {
            trimmed = CoachingContextSnapshot(
                windowDays: trimmed.windowDays,
                contextHash: trimmed.contextHash,
                movements: Array(trimmed.movements.prefix(limits.maxMovements)),
                stalled: trimmed.stalled,
                rising: trimmed.rising,
                engineSignals: CoachingSignals(tags: Array(trimmed.engineSignals.tags.prefix(4))),
                sessionEvents: Array(trimmed.sessionEvents.prefix(4))
            )
        }

        let estimate = TokenBudgetEstimator.estimatedInputTokens(for: trimmed)
        if estimate > limits.maxInputTokens, limits.maxInputTokens > 0 {
            trimmed = CoachingContextSnapshot(
                windowDays: trimmed.windowDays,
                contextHash: trimmed.contextHash,
                movements: Array(trimmed.movements.prefix(max(3, limits.maxMovements / 2))),
                stalled: Array(trimmed.stalled.prefix(2)),
                rising: Array(trimmed.rising.prefix(2)),
                engineSignals: CoachingSignals(tags: Array(trimmed.engineSignals.tags.prefix(2))),
                sessionEvents: Array(trimmed.sessionEvents.prefix(2))
            )
        }

        let finalEstimate = TokenBudgetEstimator.estimatedInputTokens(for: trimmed)
        return (trimmed, limits, finalEstimate)
    }
}
