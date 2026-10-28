import Foundation
import WatchConnectivity

/// Ativa WCSession no relógio e envia eventos compactos ao iPhone quando alcançável.
enum WatchLinkBootstrap {
    private static let delegate = WatchWCSessionDelegate()

    static func activate() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = delegate
        session.activate()
    }

    static func sendSessionSample() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        guard session.activationState == .activated, session.isReachable else { return }
        sendEvent(
            session,
            phase: "session",
            movement: "thruster",
            rpe: 8
        )
    }

    static func sendRestSample(durationSec: Int = 90) {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        guard session.activationState == .activated, session.isReachable else { return }
        sendEvent(session, phase: "rest", durationSec: durationSec)
    }

    fileprivate static func sendEvent(
        _ session: WCSession,
        phase: String,
        movement: String? = nil,
        rpe: Int? = nil,
        durationSec: Int? = nil
    ) {
        var payload: [String: Any] = ["phase": phase]
        if let movement { payload["movement"] = movement }
        if let rpe { payload["rpe"] = rpe }
        if let durationSec { payload["durationSec"] = durationSec }
        session.sendMessage(payload, replyHandler: nil, errorHandler: nil)
    }
}

private final class WatchWCSessionDelegate: NSObject, WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        guard activationState == .activated else { return }
        WatchLinkBootstrap.sendEvent(session, phase: "session", movement: "thruster", rpe: 8)
        WatchLinkBootstrap.sendEvent(session, phase: "rest", durationSec: 90)
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        guard session.isReachable else { return }
        WatchLinkBootstrap.sendEvent(session, phase: "session", movement: "thruster", rpe: 8)
    }
}
