import Foundation

/// Família de benchmark CrossFit (CPR-018).
public enum BenchmarkFamily: String, Sendable, Codable, CaseIterable, Identifiable {
    case girls
    case heroes
    case open

    public var id: String { rawValue }
}

/// Entrada de catálogo Girls / Heroes / Open.
public struct CrossfitBenchmark: Identifiable, Hashable, Sendable, Codable {
    public var id: String
    public var name: String
    public var family: BenchmarkFamily
    public var style: WorkoutSessionStyle
    public var openYear: Int?

    public init(
        id: String,
        name: String,
        family: BenchmarkFamily,
        style: WorkoutSessionStyle,
        openYear: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.family = family
        self.style = style
        self.openYear = openYear
    }
}

public enum CrossfitBenchmarkCatalog {
    public static let all: [CrossfitBenchmark] = girls + heroes + openSamples

    public static let girls: [CrossfitBenchmark] = [
        .init(id: "fran", name: "Fran", family: .girls, style: .forTime),
        .init(id: "cindy", name: "Cindy", family: .girls, style: .amrap),
        .init(id: "grace", name: "Grace", family: .girls, style: .forTime),
        .init(id: "helen", name: "Helen", family: .girls, style: .forTime),
        .init(id: "isabel", name: "Isabel", family: .girls, style: .forTime),
    ]

    public static let heroes: [CrossfitBenchmark] = [
        .init(id: "murph", name: "Murph", family: .heroes, style: .forTime),
        .init(id: "dt", name: "DT", family: .heroes, style: .forTime),
        .init(id: "nancy", name: "Nancy", family: .heroes, style: .forTime),
    ]

    public static let openSamples: [CrossfitBenchmark] = [
        .init(id: "open-24-1", name: "24.1", family: .open, style: .forTime, openYear: 2024),
        .init(id: "open-24-2", name: "24.2", family: .open, style: .amrap, openYear: 2024),
        .init(id: "open-25-1", name: "25.1", family: .open, style: .forTime, openYear: 2025),
        .init(id: "open-25-2", name: "25.2", family: .open, style: .amrap, openYear: 2025),
    ]

    /// Melhor sessão do usuário que casa com o benchmark (por `benchmarkName` / título).
    public static func bestMatch(
        for benchmark: CrossfitBenchmark,
        in sessions: [CrossFitWorkoutSession]
    ) -> CrossFitWorkoutSession? {
        let keys = [benchmark.name.lowercased()]
        let matches = sessions.filter { session in
            let name = (session.benchmarkName ?? session.title).lowercased()
            return keys.contains(where: { name == $0 || name.contains($0) })
        }
        return matches.max(by: { $0.date < $1.date })
    }
}
