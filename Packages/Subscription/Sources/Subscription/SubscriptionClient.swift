import Foundation
import Combine
import StoreKit
import Domain

/// Cliente de assinatura — orquestra StoreKit 2 via port injetável.
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
            proProduct = subscriptionProducts.first
        } catch {
            subscriptionProducts = []
            proProduct = nil
        }
    }

    public func purchasePro() async throws {
        try await purchase(productID: SubscriptionCatalog.proProductID)
    }

    public func purchase(productID: String) async throws {
        isPurchasing = true
        defer { isPurchasing = false }
        currentTier = try await store.purchase(productID: productID)
    }

    public func restorePurchases() async {
        await refreshStatus()
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
                guard SubscriptionCatalog.proProductIDs.contains(transaction.productID) else {
                    continue
                }
                await transaction.finish()
                await refreshStatus()
            }
        }
    }
}
