import Foundation

/// Agrupamento de PRs por exercício (UI — Meus Records).
public struct PRSection: Identifiable, Hashable, Sendable {
    public let id: UUID
    public var name: String
    public var group: RecordGroup
    public var records: [PersonalRecord]

    public init(
        id: UUID = UUID(),
        name: String,
        group: RecordGroup,
        records: [PersonalRecord] = []
    ) {
        self.id = id
        self.name = name
        self.group = group
        self.records = records
    }
}
