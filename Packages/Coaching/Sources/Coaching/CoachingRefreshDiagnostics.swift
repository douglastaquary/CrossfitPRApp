import Foundation
import Domain
import os

/// Telemetria local anonimizada (CPR-007 — calibrar custo PRO).
public struct CoachingRefreshDiagnostics: Sendable, Equatable {
    public var runtime: CoachingRuntime
    public var estimatedInputTokens: Int
    public var cacheHit: Bool

    public init(runtime: CoachingRuntime, estimatedInputTokens: Int, cacheHit: Bool) {
        self.runtime = runtime
        self.estimatedInputTokens = estimatedInputTokens
        self.cacheHit = cacheHit
    }
}

public enum CoachingDiagnostics {
    private static let log = Logger(subsystem: "com.douglast.CrossfitPR", category: "Coaching")

    public static func record(_ diagnostics: CoachingRefreshDiagnostics) {
        log.info(
            "coach refresh runtime=\(diagnostics.runtime.rawValue, privacy: .public) tokens=\(diagnostics.estimatedInputTokens, privacy: .public) cacheHit=\(diagnostics.cacheHit, privacy: .public)"
        )
    }
}
