import Foundation

/// Sessão de treino CrossFit (WOD/metcon) — CPR-012.
public struct CrossFitWorkoutSession: Identifiable, Hashable, Sendable, Codable {
    public var id: UUID
    public var date: Date
    public var style: WorkoutSessionStyle
    public var title: String
    public var benchmarkName: String?
    public var duration: TimeInterval
    public var score: String
    public var movements: [String]
    public var rpe: Int?
    public var metrics: SessionBiometrics?

    public init(
        id: UUID = UUID(),
        date: Date = Date(),
        style: WorkoutSessionStyle = .custom,
        title: String,
        benchmarkName: String? = nil,
        duration: TimeInterval = 0,
        score: String = "",
        movements: [String] = [],
        rpe: Int? = nil,
        metrics: SessionBiometrics? = nil
    ) {
        self.id = id
        self.date = date
        self.style = style
        self.title = title
        self.benchmarkName = benchmarkName
        self.duration = duration
        self.score = score
        self.movements = movements
        self.rpe = rpe
        self.metrics = metrics
    }
}
