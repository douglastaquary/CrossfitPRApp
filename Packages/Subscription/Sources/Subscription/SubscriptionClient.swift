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
    @Published public private(set) var isLoadingProduct = false

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

    public func purchasePro() async throws {
        currentTier = try await store.purchase(productID: SubscriptionCatalog.proProductID)
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
                guard transaction.productID == SubscriptionCatalog.proProductID else {
                    continue
                }
                await transaction.finish()
                await refreshStatus()
            }
        }
    }
}
