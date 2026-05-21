import Foundation

public extension ActivityKind {
    /// Resolve ActivityKind a partir do título do exercício (catálogo beta).
    static func fromTitle(_ title: String) -> ActivityKind? {
        let normalized = title.lowercased()
        return allCases.first { $0.rawValue.lowercased() == normalized }
    }
}
