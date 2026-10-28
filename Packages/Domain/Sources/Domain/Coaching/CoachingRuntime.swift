import Foundation

/// Onde a inferência do coach PRO roda (CPR-007).
public enum CoachingRuntime: String, Sendable, Codable {
    case onDeviceApple
    case cloud
    case summarizedLocal
}
