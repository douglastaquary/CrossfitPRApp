import Foundation

/// Agregados de PRs enviados ao coach — sem histórico bruto nem PII (CPR-007).
public struct CoachingContextSnapshot: Hashable, Sendable, Codable {
    public struct MovementSummary: Hashable, Sendable, Codable {
        public var name: String
        public var group: String
        public var lastValue: Int
        public var deltaPercent: Int
        public var lastDateISO: String

        public init(
            name: String,
            group: String,
            lastValue: Int,
            deltaPercent: Int,
            lastDateISO: String
        ) {
            self.name = name
            self.group = group
            self.lastValue = lastValue
            self.deltaPercent = deltaPercent
            self.lastDateISO = lastDateISO
        }
    }

    public var windowDays: Int
    public var contextHash: String
    public var movements: [MovementSummary]
    public var stalled: [String]
    public var rising: [String]
    public var engineSignals: CoachingSignals

    public init(
        windowDays: Int,
        contextHash: String,
        movements: [MovementSummary],
        stalled: [String],
        rising: [String],
        engineSignals: CoachingSignals
    ) {
        self.windowDays = windowDays
        self.contextHash = contextHash
        self.movements = movements
        self.stalled = stalled
        self.rising = rising
        self.engineSignals = engineSignals
    }
}
