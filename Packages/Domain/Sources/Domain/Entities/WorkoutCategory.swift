import Foundation

/// Categoria de exercício do catálogo CrossFit (beta baseline).
public struct WorkoutCategory: Identifiable, Hashable, Sendable, Codable, Comparable {
    public let id: UUID
    public var title: String
    public var type: RecordMode
    public var group: RecordGroup

    public init(
        id: UUID = UUID(),
        title: String,
        type: RecordMode,
        group: RecordGroup = .barbell
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.group = group
    }

    public static func < (lhs: WorkoutCategory, rhs: WorkoutCategory) -> Bool {
        lhs.title < rhs.title
    }
}
