import Foundation

/// Ponto de evolução para gráficos (RecordDetail / Insights).
public struct RecordPoint: Identifiable, Hashable, Sendable {
    public var id: UUID
    public var name: String
    public var date: String
    public var legend: String
    public var value: Double

    public init(
        id: UUID = UUID(),
        name: String,
        date: String,
        legend: String,
        value: Double
    ) {
        self.id = id
        self.name = name
        self.date = date
        self.legend = legend
        self.value = value
    }
}
