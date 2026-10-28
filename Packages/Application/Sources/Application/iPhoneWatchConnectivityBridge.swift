import Foundation
#if canImport(WatchConnectivity)
import WatchConnectivity

/// CPR-009 — recebe eventos compactos do companion watchOS (fase 1: ping / handshake).
@MainActor
public final class iPhoneWatchConnectivityBridge: NSObject, ObservableObject {
    public static let shared = iPhoneWatchConnectivityBridge()

    @Published public private(set) var lastMessage: [String: Any] = [:]

    private override init() {
        super.init()
    }

    public func activate() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }
}

extension iPhoneWatchConnectivityBridge: WCSessionDelegate {
    nonisolated public func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {}

    nonisolated public func sessionDidBecomeInactive(_ session: WCSession) {}

    nonisolated public func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }

    nonisolated public func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        Task { @MainActor in
            lastMessage = message
            WatchSessionEventStore.shared.ingest(watchConnectivityPayload: message)
        }
    }
}
#endif
