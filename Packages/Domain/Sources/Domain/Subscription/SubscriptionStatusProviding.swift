import Foundation

/// Port — status de assinatura (implementado em Subscription).
public protocol SubscriptionStatusProviding: Sendable {
    var currentTier: SubscriptionTier { get async }
    func refreshStatus() async
    func purchasePro() async throws
}

public enum SubscriptionError: Error, Sendable, Equatable {
    case purchaseFailed
    case productUnavailable
    case userCancelled
    case pending
}
