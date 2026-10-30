import Foundation
import Domain
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

    /// Envia top lifts para % load no Watch (CPR-016).
    public func updateLoadContext(from records: [PersonalRecord]) {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        guard session.activationState == .activated else { return }

        let grouped = Dictionary(grouping: records, by: { $0.prName })
        let lifts: [[String: Any]] = grouped.values
            .compactMap { prs -> (String, Double)? in
                guard let latest = prs.max(by: { $0.recordDate < $1.recordDate }) else { return nil }
                let value = Double(max(latest.kiloValue, latest.poundValue))
                guard value > 0 else { return nil }
                return (latest.prName, value)
            }
            .sorted { $0.1 > $1.1 }
            .prefix(3)
            .map { ["name": $0.0, "oneRM": $0.1, "unit": "kg"] }

        let context: [String: Any] = ["lifts": lifts]
        try? session.updateApplicationContext(context)
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
            ingest(message)
        }
    }

    nonisolated public func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String: Any]
    ) {
        Task { @MainActor in
            ingest(applicationContext)
        }
    }

    @MainActor
    private func ingest(_ message: [String: Any]) {
        lastMessage = message
        WatchSessionEventStore.shared.ingest(watchConnectivityPayload: message)
    }
}
#endif
