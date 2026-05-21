import Foundation

/// Port — operações StoreKit (implementado em Subscription).
public protocol SubscriptionStoreProviding: Sendable {
    func fetchProProduct() async throws -> SubscriptionProductInfo?
    func fetchSubscriptionProducts() async throws -> [SubscriptionProductInfo]
    func purchase(productID: String) async throws -> SubscriptionTier
    func resolveCurrentTier() async -> SubscriptionTier
}
