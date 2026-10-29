import Foundation

/// Datasets nomeados para Previews, UITest seed e demos — CPR-011 / CPR-012.
public enum DemoDataFixtures {
    public struct Bundle: Sendable {
        public var records: [PersonalRecord]
        public var sessions: [CrossFitWorkoutSession]
        public var watchEvents: [WatchSessionEvent]
        public var healthMetrics: SessionBiometrics?

        public init(
            records: [PersonalRecord] = [],
            sessions: [CrossFitWorkoutSession] = [],
            watchEvents: [WatchSessionEvent] = [],
            healthMetrics: SessionBiometrics? = nil
        ) {
            self.records = records
            self.sessions = sessions
            self.watchEvents = watchEvents
            self.healthMetrics = healthMetrics
        }
    }

    public static func bundle(for scenario: DemoDataScenario) -> Bundle {
        switch scenario {
        case .empty:
            return Bundle()
        case .freeTeaser:
            return Bundle(
                records: freeTeaserRecords(),
                sessions: [sampleSession(daysAgo: 2, withMetrics: false)]
            )
        case .proRich:
            return Bundle(
                records: proRichRecords(),
                sessions: [
                    sampleSession(daysAgo: 1, withMetrics: true),
                    sampleSession(daysAgo: 5, withMetrics: true, title: "Fran", style: .forTime, score: "4:12")
                ],
                watchEvents: sampleWatchEvents(),
                healthMetrics: sampleBiometrics()
            )
        case .eliteRich:
            return Bundle(
                records: eliteRichRecords(),
                sessions: [
                    sampleSession(daysAgo: 1, withMetrics: true),
                    sampleSession(daysAgo: 3, withMetrics: true, title: "Cindy", style: .amrap, score: "18 rounds")
                ],
                watchEvents: sampleWatchEvents(),
                healthMetrics: sampleBiometrics()
            )
        case .watchLinked:
            return Bundle(
                records: proRichRecords(),
                sessions: [sampleSession(daysAgo: 0, withMetrics: true)],
                watchEvents: sampleWatchEvents(),
                healthMetrics: sampleBiometrics()
            )
        }
    }

    // MARK: - Records

    private static func day(_ offset: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -offset, to: Date()) ?? Date()
    }

    private static func barbell(
        _ name: String,
        pounds: Int,
        daysAgo: Int,
        evolution: Int = 0
    ) -> PersonalRecord {
        PersonalRecord(
            prName: name,
            recordDate: day(daysAgo),
            kiloValue: Int(Double(pounds) * 0.453592),
            poundValue: pounds,
            recordMode: .maxWeight,
            group: .barbell,
            evolutionPercentage: evolution
        )
    }

    private static func gymnastic(_ name: String, reps: Int, daysAgo: Int) -> PersonalRecord {
        PersonalRecord(
            prName: name,
            recordDate: day(daysAgo),
            recordMode: .maxRepetition,
            group: .gymnastic,
            maxReps: reps
        )
    }

    private static func endurance(_ name: String, km: Int, daysAgo: Int) -> PersonalRecord {
        PersonalRecord(
            prName: name,
            recordDate: day(daysAgo),
            distance: km,
            recordMode: .maxDistance,
            group: .endurance
        )
    }

    private static func freeTeaserRecords() -> [PersonalRecord] {
        [
            barbell("Back Squat", pounds: 185, daysAgo: 40),
            barbell("Back Squat", pounds: 205, daysAgo: 20, evolution: 11),
            barbell("Deadlift", pounds: 275, daysAgo: 30),
            barbell("Deadlift", pounds: 295, daysAgo: 10, evolution: 7),
            barbell("Clean", pounds: 135, daysAgo: 25),
            barbell("Clean", pounds: 155, daysAgo: 5, evolution: 15),
            gymnastic("Pull-ups", reps: 12, daysAgo: 8),
            endurance("Row", km: 2, daysAgo: 12)
        ]
    }

    private static func proRichRecords() -> [PersonalRecord] {
        var records = freeTeaserRecords()
        // Plateau: 3 PRs mesmo peso
        records += [
            barbell("Front Squat", pounds: 185, daysAgo: 21),
            barbell("Front Squat", pounds: 185, daysAgo: 14),
            barbell("Front Squat", pounds: 185, daysAgo: 7),
            barbell("Clean & Jerk", pounds: 175, daysAgo: 18),
            barbell("Clean & Jerk", pounds: 185, daysAgo: 4, evolution: 6),
            barbell("Snatch", pounds: 135, daysAgo: 15),
            barbell("Snatch", pounds: 145, daysAgo: 3, evolution: 7),
            gymnastic("Handstand Push-ups", reps: 8, daysAgo: 9),
            gymnastic("Toes-to-Bar", reps: 20, daysAgo: 6),
            endurance("Run", km: 5, daysAgo: 11),
            endurance("Bike", km: 10, daysAgo: 2)
        ]
        return records
    }

    private static func eliteRichRecords() -> [PersonalRecord] {
        var records = proRichRecords()
        records += [
            barbell("Back Squat", pounds: 315, daysAgo: 2, evolution: 12),
            barbell("Deadlift", pounds: 405, daysAgo: 1, evolution: 10),
            barbell("Clean & Jerk", pounds: 225, daysAgo: 2, evolution: 8),
            barbell("Snatch", pounds: 175, daysAgo: 1, evolution: 9),
            gymnastic("Muscle-ups", reps: 6, daysAgo: 4),
            gymnastic("Pull-ups", reps: 25, daysAgo: 3),
            endurance("Row", km: 5, daysAgo: 2),
            endurance("Run", km: 10, daysAgo: 5)
        ]
        return records
    }

    // MARK: - Sessions / Watch / HK

    public static func sampleBiometrics() -> SessionBiometrics {
        SessionBiometrics(
            averageHeartRate: 145,
            activeCalories: 317,
            totalCalories: 375,
            exerciseTime: 36 * 60 + 14
        )
    }

    public static func sampleSession(
        daysAgo: Int,
        withMetrics: Bool,
        title: String = "Cross Training",
        style: WorkoutSessionStyle = .amrap,
        score: String = "14 rounds"
    ) -> CrossFitWorkoutSession {
        CrossFitWorkoutSession(
            date: day(daysAgo),
            style: style,
            title: title,
            benchmarkName: title == "Fran" || title == "Cindy" ? title : nil,
            duration: withMetrics ? (52 * 60 + 17) : (40 * 60),
            score: score,
            movements: ["thruster", "pull-up", "box jump"],
            rpe: 7,
            metrics: withMetrics ? sampleBiometrics() : nil
        )
    }

    public static func sampleWatchEvents() -> [WatchSessionEvent] {
        [
            WatchSessionEvent(phase: "session", movement: "thruster", rpe: 7, durationSec: 90, recordedAt: day(0)),
            WatchSessionEvent(phase: "rest", durationSec: 120, recordedAt: day(0).addingTimeInterval(-200)),
            WatchSessionEvent(phase: "breath", durationSec: 60, recordedAt: day(0).addingTimeInterval(-80))
        ]
    }
}
