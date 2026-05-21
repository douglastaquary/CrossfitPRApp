import Foundation
import Domain

@MainActor
public final class LaunchScreenStateManager: ObservableObject {
    @Published public private(set) var state: LaunchScreenStep = .firstStep

    public init() {}

    public func start() {
        Task {
            // Pulse animation
            try? await Task.sleep(nanoseconds: 800_000_000) // 0.8s
            state = .secondStep
            // Explosion + fade
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3s
            state = .finished
        }
    }
}
