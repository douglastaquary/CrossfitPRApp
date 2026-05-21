import Foundation
import Domain

/// Mock do store — testes unitários e preview sem App Store.
public final class MockSubscriptionStore: SubscriptionStoreProviding, @unchecked Sendable {
    public var tier: SubscriptionTier
    public var products: [SubscriptionProductInfo]
    public var shouldFailPurchase = false
    public var shouldThrowCancelled = false
    public var purchaseDelay: UInt64 = 0

    public init(
        tier: SubscriptionTier = .free,
        products: [SubscriptionProductInfo]? = nil
    ) {
        self.tier = tier
        self.products = products ?? Self.defaultProducts
    }

    public static var defaultProducts: [SubscriptionProductInfo] {
        [
            SubscriptionProductInfo(
                id: SubscriptionCatalog.proAnnualProductID,
                displayName: "PRO Anual",
                displayPrice: "R$ 39,90/ano"
            ),
            SubscriptionProductInfo(
                id: SubscriptionCatalog.proMonthlyProductID,
                displayName: "PRO Mensal",
                displayPrice: "R$ 9,90/mês"
            )
        ]
    }

    public func fetchProProduct() async throws -> SubscriptionProductInfo? {
        products.first
    }

    public func fetchSubscriptionProducts() async throws -> [SubscriptionProductInfo] {
        products
    }

    public func purchase(productID: String) async throws -> SubscriptionTier {
        if purchaseDelay > 0 {
            try? await Task.sleep(nanoseconds: purchaseDelay)
        }
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
