import Foundation
import Domain

/// Provider determinístico para simulador / UITest — CPR-009.
public struct MockHealthKitMetricsProvider: HealthKitSessionMetricsProviding, Sendable {
    public var metrics: SessionBiometrics?
    public var authorize: Bool

    public init(metrics: SessionBiometrics? = nil, authorize: Bool = true) {
        self.metrics = metrics
        self.authorize = authorize
    }

    public func requestAuthorizationIfNeeded() async -> Bool {
        authorize
    }

    public func latestWorkoutMetrics(lookingBack days: Int) async -> SessionBiometrics? {
        _ = days
        return metrics
    }
}
