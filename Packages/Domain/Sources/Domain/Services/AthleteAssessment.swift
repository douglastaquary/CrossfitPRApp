import Foundation

/// Domínios de fitness usados no assessment Elite (CPR-008 / personas Mayhem).
public enum AthleteDomain: String, Sendable, Codable, CaseIterable, Identifiable {
    case strength
    case olympic
    case gymnastics
    case engine

    public var id: String { rawValue }
}

/// Score 0…1 por domínio — cobertura de PRs + progresso recente.
public struct DomainScore: Hashable, Sendable, Codable {
    public var domain: AthleteDomain
    public var coverage: Double
    public var progress: Double
    public var score: Double

    public init(domain: AthleteDomain, coverage: Double, progress: Double, score: Double) {
        self.domain = domain
        self.coverage = coverage
        self.progress = progress
        self.score = score
    }
}

/// Resultado do assessment vs. padrões competitivos (heurística local).
public struct AthleteAssessment: Hashable, Sendable, Codable {
    public var scores: [DomainScore]
    public var limitingFactor: AthleteDomain?
    public var assessedRecordCount: Int

    public init(
        scores: [DomainScore],
        limitingFactor: AthleteDomain?,
        assessedRecordCount: Int
    ) {
        self.scores = scores
        self.limitingFactor = limitingFactor
        self.assessedRecordCount = assessedRecordCount
    }
}
