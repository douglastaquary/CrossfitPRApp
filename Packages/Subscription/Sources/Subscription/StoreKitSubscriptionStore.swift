import Foundation
import StoreKit
import Domain

/// Adapter StoreKit 2 — compra e entitlements PRO / Elite.
public struct StoreKitSubscriptionStore: SubscriptionStoreProviding, Sendable {
    public init() {}

    public func fetchProProduct() async throws -> SubscriptionProductInfo? {
        let products = try await fetchSubscriptionProducts()
        return products.first { SubscriptionCatalog.proProductIDs.contains($0.id) }
    }

    public func fetchSubscriptionProducts() async throws -> [SubscriptionProductInfo] {
        let products = try await Product.products(for: SubscriptionCatalog.allProductIDs)
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
            return SubscriptionCatalog.tier(forProductID: transaction.productID) ?? .pro
        case .userCancelled:
            throw SubscriptionError.userCancelled
        case .pending:
            throw SubscriptionError.pending
        @unknown default:
            throw SubscriptionError.purchaseFailed
        }
    }

    public func resolveCurrentTier() async -> SubscriptionTier {
        var resolved: SubscriptionTier = .free
        for await result in Transaction.currentEntitlements {
            guard let transaction = try? Self.checkVerified(result) else { continue }
            guard let tier = SubscriptionCatalog.tier(forProductID: transaction.productID) else { continue }
            if tier == .elite {
                return .elite
            }
            if tier == .pro {
                resolved = .pro
            }
        }
        return resolved
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
        case SubscriptionCatalog.eliteAnnualProductID: return 0
        case SubscriptionCatalog.eliteMonthlyProductID: return 1
        case SubscriptionCatalog.eliteProductID: return 2
        case SubscriptionCatalog.proAnnualProductID: return 3
        case SubscriptionCatalog.proMonthlyProductID: return 4
        case SubscriptionCatalog.proProductID: return 5
        default: return 6
        }
    }
}
