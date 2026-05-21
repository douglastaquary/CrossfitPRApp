import Foundation
import Domain

@MainActor
public final class LaunchScreenStateManager: ObservableObject {
    @Published public private(set) var state: LaunchScreenStep = .firstStep

    public init() {}

    public func start() {
        Task {
            try? await Task.sleep(nanoseconds: 900_000_000)
            state = .secondStep
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            state = .finished
        }
    }
}
