import Foundation
import Network

/// Monitor de conectividade — gate de rede no LaunchView (beta).
@MainActor
public final class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.douglast.CrossfitPR.network-monitor")

    @Published public private(set) var isConnected = true

    public init() {
        // CI/simulador: NWPathMonitor costuma reportar offline e bloqueia LaunchView.
        if UITestLaunchSupport.isUITestMode {
            isConnected = true
            return
        }
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
