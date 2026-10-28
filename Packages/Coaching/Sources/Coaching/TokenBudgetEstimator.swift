import Foundation
import Domain

/// Estimativa conservadora chars/4 — calibração cloud (CPR-007).
public enum TokenBudgetEstimator {
    public static func estimatedInputTokens(for snapshot: CoachingContextSnapshot) -> Int {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        guard let data = try? encoder.encode(snapshot) else { return 0 }
        return max(1, data.count / 4)
    }
}
