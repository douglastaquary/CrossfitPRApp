import Foundation
import WatchConnectivity

/// Ativa WCSession no relógio e publica eventos compactos ao iPhone.
enum WatchLinkBootstrap {
    private static let delegate = WatchWCSessionDelegate()

    static func activate() {
        WatchEventSink.send = { publish($0) }
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = delegate
        session.activate()
    }

    static func publish(_ payload: WatchEventPayload) {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        guard session.activationState == .activated else { return }
        var message: [String: Any] = ["phase": payload.phase]
        if let movement = payload.movement { message["movement"] = movement }
        if let rpe = payload.rpe { message["rpe"] = rpe }
        if let durationSec = payload.durationSec { message["durationSec"] = durationSec }
        if session.isReachable {
            session.sendMessage(message, replyHandler: nil, errorHandler: nil)
        } else {
            try? session.updateApplicationContext(message)
        }
    }
}

private final class WatchWCSessionDelegate: NSObject, WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        if activationState == .activated {
            WatchLoadContextStore.latest = session.receivedApplicationContext
        }
    }

    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String: Any]
    ) {
        WatchLoadContextStore.latest = applicationContext
    }

    func sessionReachabilityDidChange(_ session: WCSession) {}
}
