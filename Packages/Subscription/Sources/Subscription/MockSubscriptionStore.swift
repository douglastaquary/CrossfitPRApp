import Foundation
import Domain

/// Mock do store — testes unitários sem App Store.
public final class MockSubscriptionStore: SubscriptionStoreProviding, @unchecked Sendable {
    public var tier: SubscriptionTier
    public var product: SubscriptionProductInfo?
    public var shouldFailPurchase = false
    public var shouldThrowCancelled = false

    public init(
        tier: SubscriptionTier = .free,
        product: SubscriptionProductInfo? = SubscriptionProductInfo(
            id: SubscriptionCatalog.proProductID,
            displayName: "CrossfitPR PRO",
            displayPrice: "R$ 9,90"
        )
    ) {
        self.tier = tier
        self.product = product
    }

    public func fetchProProduct() async throws -> SubscriptionProductInfo? {
        product
    }

    public func purchase(productID: String) async throws -> SubscriptionTier {
        if shouldThrowCancelled {
            throw SubscriptionError.userCancelled
        }
        if shouldFailPurchase {
            throw SubscriptionError.purchaseFailed
        }
        tier = .pro
        return .pro
    }

    public func resolveCurrentTier() async -> SubscriptionTier {
        tier
    }
}
