import Foundation
import Domain

/// Escolhe adapter on-device → cloud → resumo local (CPR-007).
public struct CoachingAdapterRouter: Sendable {
    public var prefersOnDevice: Bool
    public var onDevice: any CrossFitCoachingProviding
    public var cloud: any CrossFitCoachingProviding
    public var summarized: any CrossFitCoachingProviding

    public init(
        prefersOnDevice: Bool = true,
        onDevice: any CrossFitCoachingProviding = AppleIntelligenceCoachAdapter(),
        cloud: any CrossFitCoachingProviding = CloudCoachAdapter(),
        summarized: any CrossFitCoachingProviding = SummarizedLocalCoachAdapter()
    ) {
        self.prefersOnDevice = prefersOnDevice
        self.onDevice = onDevice
        self.cloud = cloud
        self.summarized = summarized
    }

    public func adapter(for runtime: CoachingRuntime) -> any CrossFitCoachingProviding {
        switch runtime {
        case .onDeviceApple: return onDevice
        case .cloud: return cloud
        case .summarizedLocal: return summarized
        }
    }

    public func preferredRuntime(isOnDeviceAvailable: Bool) -> CoachingRuntime {
        if prefersOnDevice, isOnDeviceAvailable { return .onDeviceApple }
        return .cloud
    }
}
