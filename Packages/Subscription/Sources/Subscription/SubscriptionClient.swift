import Foundation
import Combine
import StoreKit
import Domain

/// Cliente de assinatura — orquestra StoreKit 2 via port injetável.
/// Após compra, reconcilia tier com entitlements (dual registration cliente ↔ App Store).
@MainActor
public final class SubscriptionClient: SubscriptionStatusProviding, ObservableObject {
    private let store: any SubscriptionStoreProviding

    @Published public private(set) var currentTier: SubscriptionTier = .free
    @Published public private(set) var proProduct: SubscriptionProductInfo?
    @Published public private(set) var subscriptionProducts: [SubscriptionProductInfo] = []
    @Published public private(set) var isLoadingProduct = false
    @Published public private(set) var isPurchasing = false

    public init(store: any SubscriptionStoreProviding = StoreKitSubscriptionStore()) {
        self.store = store
        if let mock = store as? MockSubscriptionStore {
            currentTier = mock.tier
        }
    }

    public func refreshStatus() async {
        currentTier = await store.resolveCurrentTier()
    }

    public func loadProProduct() async {
        isLoadingProduct = true
        defer { isLoadingProduct = false }

        do {
            proProduct = try await store.fetchProProduct()
        } catch {
            proProduct = nil
        }
    }

    public func loadSubscriptionProducts() async {
        isLoadingProduct = true
        defer { isLoadingProduct = false }

        do {
            subscriptionProducts = try await store.fetchSubscriptionProducts()
            proProduct = subscriptionProducts.first {
                SubscriptionCatalog.proProductIDs.contains($0.id)
            }
        } catch {
            subscriptionProducts = []
            proProduct = nil
        }
    }

    public func purchasePro() async throws {
        try await purchase(productID: SubscriptionCatalog.proProductID)
    }

    /// Compra e sincroniza com entitlements StoreKit (fonte da verdade).
    public func purchase(productID: String) async throws {
        isPurchasing = true
        defer { isPurchasing = false }

        let purchased = try await store.purchase(productID: productID)
        let entitlements = await store.resolveCurrentTier()
        currentTier = Self.reconciledTier(purchaseResult: purchased, entitlements: entitlements)
    }

    /// Restaura entitlements; retorna o tier após sync.
    @discardableResult
    public func restorePurchases() async -> SubscriptionTier {
        await refreshStatus()
        return currentTier
    }

    public func cancelSubscription() async {
        currentTier = .free
    }

    public func canAccess(_ feature: ProFeature) -> Bool {
        currentTier.canAccess(feature)
    }

    public func observeTransactionUpdates() {
        Task {
            for await result in Transaction.updates {
                guard let transaction = try? StoreKitSubscriptionStore.checkVerified(result) else {
                    continue
                }
                guard SubscriptionCatalog.tier(forProductID: transaction.productID) != nil else {
                    continue
                }
                await transaction.finish()
                await refreshStatus()
            }
        }
    }

    /// Elite > PRO > free; se entitlements atrasarem, confia no resultado da compra.
    nonisolated static func reconciledTier(
        purchaseResult: SubscriptionTier,
        entitlements: SubscriptionTier
    ) -> SubscriptionTier {
        let rank: (SubscriptionTier) -> Int = { tier in
            switch tier {
            case .elite: return 2
            case .pro: return 1
            case .free: return 0
            }
        }
        return rank(entitlements) >= rank(purchaseResult) ? entitlements : purchaseResult
    }
}
