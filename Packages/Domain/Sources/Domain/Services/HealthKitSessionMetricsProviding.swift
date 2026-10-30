import Foundation

/// Port — métricas de workout via HealthKit (CPR-009). Implementações em Application/Persistence.
public protocol HealthKitSessionMetricsProviding: Sendable {
    /// Solicita autorização quando necessário. Retorna `false` se negado/indisponível.
    func requestAuthorizationIfNeeded() async -> Bool

    /// Últimas métricas de workout no intervalo, ou `nil` se sem dados/permissão.
    func latestWorkoutMetrics(lookingBack days: Int) async -> SessionBiometrics?
}
