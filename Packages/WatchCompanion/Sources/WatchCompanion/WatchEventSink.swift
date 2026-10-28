import Foundation

/// Payload enviado ao iPhone (WatchConnectivity no target `CrossfitPRWatch`).
public struct WatchEventPayload: Sendable {
    public var phase: String
    public var movement: String?
    public var rpe: Int?
    public var durationSec: Int?

    public init(phase: String, movement: String? = nil, rpe: Int? = nil, durationSec: Int? = nil) {
        self.phase = phase
        self.movement = movement
        self.rpe = rpe
        self.durationSec = durationSec
    }
}

/// Ponte injetada pelo app watchOS — evita WatchConnectivity dentro do pacote compartilhado.
public enum WatchEventSink {
    public static var send: @Sendable (WatchEventPayload) -> Void = { _ in }
}
