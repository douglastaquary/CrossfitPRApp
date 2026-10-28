import Foundation

/// Evento compacto de sessão no relógio — sem transcript bruto (CPR-009 → CPR-007).
public struct WatchSessionEvent: Hashable, Sendable, Codable {
    public var phase: String
    public var movement: String?
    public var rpe: Int?
    public var durationSec: Int?
    public var recordedAt: Date

    public init(
        phase: String,
        movement: String? = nil,
        rpe: Int? = nil,
        durationSec: Int? = nil,
        recordedAt: Date = Date()
    ) {
        self.phase = phase
        self.movement = movement
        self.rpe = rpe
        self.durationSec = durationSec
        self.recordedAt = recordedAt
    }

    /// Payload `WCSession` / dicionário plano (watch → iPhone).
    public init?(watchConnectivityPayload payload: [String: Any]) {
        let rawPhase = (payload["phase"] as? String) ?? (payload["event"] as? String)
        guard let rawPhase, !rawPhase.isEmpty else { return nil }

        let phase: String
        switch rawPhase {
        case "watch.handshake":
            phase = "session"
        default:
            phase = rawPhase
        }

        movement = payload["movement"] as? String
        if let rpeNumber = payload["rpe"] as? NSNumber {
            rpe = rpeNumber.intValue
        } else if let rpeInt = payload["rpe"] as? Int {
            rpe = rpeInt
        } else {
            rpe = nil
        }
        if let durationNumber = payload["durationSec"] as? NSNumber {
            durationSec = durationNumber.intValue
        } else if let durationInt = payload["durationSec"] as? Int {
            durationSec = durationInt
        } else {
            durationSec = nil
        }
        recordedAt = Date()
        self.phase = phase
    }
}
