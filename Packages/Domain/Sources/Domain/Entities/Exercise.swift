import Foundation

/// Exercício associado a um PR (REASONS E — Entities).
public struct Exercise: Codable, Identifiable, Hashable, Sendable {
    public var id: UUID
    public var kind: ActivityKind

    public init(id: UUID = UUID(), kind: ActivityKind) {
        self.id = id
        self.kind = kind
    }
}
