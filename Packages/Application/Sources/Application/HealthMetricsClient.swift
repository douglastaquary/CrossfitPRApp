import Foundation
import Combine
import Domain

/// Client MV — métricas HealthKit / mock (CPR-009).
@MainActor
public final class HealthMetricsClient: ObservableObject {
    private let provider: any HealthKitSessionMetricsProviding

    @Published public private(set) var latestMetrics: SessionBiometrics?
    @Published public private(set) var authorizationGranted = false
    @Published public private(set) var lastError: String?

    public init(provider: any HealthKitSessionMetricsProviding) {
        self.provider = provider
    }

    public func refresh(lookingBack days: Int = 14) async {
        authorizationGranted = await provider.requestAuthorizationIfNeeded()
        guard authorizationGranted else {
            latestMetrics = nil
            return
        }
        latestMetrics = await provider.latestWorkoutMetrics(lookingBack: days)
    }

    public func applyMockMetrics(_ metrics: SessionBiometrics?) {
        latestMetrics = metrics
        authorizationGranted = metrics != nil
    }
}
