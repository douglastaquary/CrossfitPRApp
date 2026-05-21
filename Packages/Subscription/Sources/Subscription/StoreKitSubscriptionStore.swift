import Foundation
import StoreKit
import Domain

/// Adapter StoreKit 2 — compra e entitlements PRO.
public struct StoreKitSubscriptionStore: SubscriptionStoreProviding, Sendable {
    public init() {}

    public func fetchProProduct() async throws -> SubscriptionProductInfo? {
        let products = try await Product.products(for: [SubscriptionCatalog.proProductID])
        guard let product = products.first else { return nil }
        return SubscriptionProductInfo(
            id: product.id,
            displayName: product.displayName,
            displayPrice: product.displayPrice
        )
    }

    public func purchase(productID: String) async throws -> SubscriptionTier {
        let products = try await Product.products(for: [productID])
        guard let product = products.first else {
            throw SubscriptionError.productUnavailable
        }

        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            let transaction = try Self.checkVerified(verification)
            await transaction.finish()
            return .pro
        case .userCancelled:
            throw SubscriptionError.userCancelled
        case .pending:
            throw SubscriptionError.pending
        @unknown default:
            throw SubscriptionError.purchaseFailed
        }
    }

    public func resolveCurrentTier() async -> SubscriptionTier {
        for await result in Transaction.currentEntitlements {
            guard let transaction = try? Self.checkVerified(result) else { continue }
            if transaction.productID == SubscriptionCatalog.proProductID {
                return .pro
            }
        }
        return .free
    }

    static func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw SubscriptionError.purchaseFailed
        case .verified(let value):
            return value
        }
    }
}
