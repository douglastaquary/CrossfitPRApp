import Foundation
import Testing
@testable import Subscription
import Domain

@Suite("SubscriptionClient")
struct SubscriptionClientTests {
    @Test("Usuário free não acessa análise detalhada")
    @MainActor
    func freeUserGating() {
        let client = SubscriptionClient(store: MockSubscriptionStore(tier: .free))
        #expect(!client.canAccess(.detailedAIAnalysis))
        #expect(client.canAccess(.basicInsights))
    }

    @Test("Compra PRO libera features premium")
    @MainActor
    func purchaseUnlocksPro() async throws {
        let mock = MockSubscriptionStore(tier: .free)
        let client = SubscriptionClient(store: mock)
        try await client.purchasePro()
        #expect(client.currentTier == .pro)
        #expect(client.canAccess(.detailedAIAnalysis))
    }

    @Test("Cancelamento não altera tier")
    @MainActor
    func cancelKeepsFreeTier() async {
        let mock = MockSubscriptionStore(tier: .free)
        mock.shouldThrowCancelled = true
        let client = SubscriptionClient(store: mock)

        do {
            try await client.purchasePro()
            Issue.record("Expected userCancelled")
        } catch SubscriptionError.userCancelled {
            #expect(client.currentTier == .free)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Restore atualiza tier quando entitlement existe")
    @MainActor
    func restoreProTier() async {
        let mock = MockSubscriptionStore(tier: .pro)
        let client = SubscriptionClient(store: mock)
        await client.restorePurchases()
        #expect(client.currentTier == .pro)
    }

    @Test("Load product popula proProduct")
    @MainActor
    func loadProProduct() async {
        let mock = MockSubscriptionStore()
        let client = SubscriptionClient(store: mock)
        await client.loadProProduct()
        #expect(client.proProduct?.id == SubscriptionCatalog.proProductID)
    }
}

@Suite("MockSubscriptionStore")
struct MockSubscriptionStoreTests {
    @Test("Falha de compra propaga erro")
    func purchaseFailure() async {
        let mock = MockSubscriptionStore()
        mock.shouldFailPurchase = true

        do {
            _ = try await mock.purchase(productID: SubscriptionCatalog.proProductID)
            Issue.record("Expected purchaseFailed")
        } catch SubscriptionError.purchaseFailed {
            #expect(mock.tier == .free)
        } catch {
            Issue.record("Unexpected error")
        }
    }
}
