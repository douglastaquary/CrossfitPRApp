import Foundation
import Domain

#if canImport(HealthKit)
import HealthKit
#endif

/// Lê workouts recentes do HealthKit (device). No simulador/CI use `MockHealthKitMetricsProvider`.
public struct HealthKitSessionMetricsProvider: HealthKitSessionMetricsProviding, Sendable {
    public init() {}

    public func requestAuthorizationIfNeeded() async -> Bool {
        #if canImport(HealthKit)
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        let store = HKHealthStore()
        let types: Set<HKObjectType> = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        ]
        do {
            try await store.requestAuthorization(toShare: [], read: types)
            return true
        } catch {
            return false
        }
        #else
        return false
        #endif
    }

    public func latestWorkoutMetrics(lookingBack days: Int) async -> SessionBiometrics? {
        #if canImport(HealthKit)
        guard HKHealthStore.isHealthDataAvailable() else { return nil }
        let store = HKHealthStore()
        let calendar = Calendar.current
        let end = Date()
        guard let start = calendar.date(byAdding: .day, value: -days, to: end) else { return nil }

        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: .workoutType(),
                predicate: predicate,
                limit: 1,
                sortDescriptors: [sort]
            ) { _, samples, _ in
                guard let workout = samples?.first as? HKWorkout else {
                    continuation.resume(returning: nil)
                    return
                }
                let active = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie())
                let duration = workout.duration
                // FC média: amostra agregada no intervalo do workout (best-effort).
                Task {
                    let avgHR = await Self.averageHeartRate(store: store, start: workout.startDate, end: workout.endDate)
                    let basal = await Self.sumQuantity(
                        store: store,
                        identifier: .basalEnergyBurned,
                        unit: .kilocalorie(),
                        start: workout.startDate,
                        end: workout.endDate
                    )
                    let total: Double?
                    if let active {
                        total = active + (basal ?? 0)
                    } else {
                        total = basal
                    }
                    continuation.resume(
                        returning: SessionBiometrics(
                            averageHeartRate: avgHR,
                            activeCalories: active,
                            totalCalories: total,
                            exerciseTime: duration
                        )
                    )
                }
            }
            store.execute(query)
        }
        #else
        return nil
        #endif
    }

    #if canImport(HealthKit)
    private static func averageHeartRate(store: HKHealthStore, start: Date, end: Date) async -> Int? {
        guard let hrType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return nil }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: hrType,
                quantitySamplePredicate: predicate,
                options: .discreteAverage
            ) { _, stats, _ in
                let bpm = stats?.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                continuation.resume(returning: bpm.map { Int($0.rounded()) })
            }
            store.execute(query)
        }
    }

    private static func sumQuantity(
        store: HKHealthStore,
        identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        start: Date,
        end: Date
    ) async -> Double? {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return nil }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, stats, _ in
                continuation.resume(returning: stats?.sumQuantity()?.doubleValue(for: unit))
            }
            store.execute(query)
        }
    }
    #endif
}
