import Foundation
import StoreKit
import Domain

/// Adapter StoreKit 2 — compra e entitlements PRO.
public struct StoreKitSubscriptionStore: SubscriptionStoreProviding, Sendable {
    public init() {}

    public func fetchProProduct() async throws -> SubscriptionProductInfo? {
        let products = try await fetchSubscriptionProducts()
        return products.first
    }

    public func fetchSubscriptionProducts() async throws -> [SubscriptionProductInfo] {
        let products = try await Product.products(for: SubscriptionCatalog.proProductIDs)
        let mapped = products.map { product in
            SubscriptionProductInfo(
                id: product.id,
                displayName: product.displayName,
                displayPrice: product.displayPrice
            )
        }
        return mapped.sorted { lhs, rhs in
            sortRank(for: lhs.id) < sortRank(for: rhs.id)
        }
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
            if SubscriptionCatalog.proProductIDs.contains(transaction.productID) {
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

    private func sortRank(for productID: String) -> Int {
        switch productID {
        case SubscriptionCatalog.proAnnualProductID: return 0
        case SubscriptionCatalog.proMonthlyProductID: return 1
        default: return 2
        }
    }
}
