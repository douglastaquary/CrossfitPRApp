import Foundation
import WatchConnectivity

/// Ativa WCSession no relógio e envia handshake ao iPhone quando alcançável.
enum WatchLinkBootstrap {
    private static let delegate = WatchWCSessionDelegate()

    static func activate() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = delegate
        session.activate()
    }
}

private final class WatchWCSessionDelegate: NSObject, WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        guard activationState == .activated else { return }
        sendHandshake(session)
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        if session.isReachable { sendHandshake(session) }
    }

    private func sendHandshake(_ session: WCSession) {
        guard session.isReachable else { return }
        session.sendMessage(
            ["event": "watch.handshake", "source": "CrossfitPRWatch"],
            replyHandler: nil,
            errorHandler: nil
        )
    }
}
