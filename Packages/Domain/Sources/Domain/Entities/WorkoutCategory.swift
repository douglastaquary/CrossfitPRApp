import Foundation

/// Categoria de exercício do catálogo CrossFit (beta baseline).
public struct WorkoutCategory: Identifiable, Hashable, Sendable, Codable, Comparable {
    public let id: UUID
    /// Chave `Localizable.strings` (`workout.*`) — exibição localizada na UI.
    public let titleKey: String
    /// Título canônico (inglês baseline) persistido em `PersonalRecord.prName`.
    public var title: String
    public var type: RecordMode
    public var group: RecordGroup

    public init(
        id: UUID = UUID(),
        titleKey: String,
        title: String,
        type: RecordMode,
        group: RecordGroup = .barbell
    ) {
        self.id = id
        self.titleKey = titleKey
        self.title = title
        self.type = type
        self.group = group
    }

    public static func < (lhs: WorkoutCategory, rhs: WorkoutCategory) -> Bool {
        lhs.title < rhs.title
    }
}
