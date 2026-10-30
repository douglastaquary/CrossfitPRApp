import Foundation

/// Métricas de sessão (HealthKit ou mock) — CPR-009 / CPR-012.
public struct SessionBiometrics: Hashable, Sendable, Codable {
    public var averageHeartRate: Int?
    public var activeCalories: Double?
    public var totalCalories: Double?
    public var exerciseTime: TimeInterval?

    public init(
        averageHeartRate: Int? = nil,
        activeCalories: Double? = nil,
        totalCalories: Double? = nil,
        exerciseTime: TimeInterval? = nil
    ) {
        self.averageHeartRate = averageHeartRate
        self.activeCalories = activeCalories
        self.totalCalories = totalCalories
        self.exerciseTime = exerciseTime
    }

    public var hasAnyMetric: Bool {
        averageHeartRate != nil
            || activeCalories != nil
            || totalCalories != nil
            || exerciseTime != nil
    }
}
