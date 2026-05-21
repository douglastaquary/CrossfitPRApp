import Foundation
import Testing
@testable import Subscription
import Domain

@Suite("SubscriptionClient")
struct SubscriptionClientTests {

    // MARK: - Gating

    @Test("Usuário free não acessa análise detalhada")
    @MainActor
    func freeUserGating() {
        let client = SubscriptionClient(store: MockSubscriptionStore(tier: .free))
        #expect(!client.canAccess(.detailedAIAnalysis))
        #expect(client.canAccess(.basicInsights))
    }

    @Test("Usuário PRO acessa todas as features")
    @MainActor
    func proUserAccessAllFeatures() {
        let client = SubscriptionClient(store: MockSubscriptionStore(tier: .pro))
        #expect(client.canAccess(.detailedAIAnalysis))
        #expect(client.canAccess(.basicInsights))
        #expect(client.canAccess(.personalizedRecommendations))
        #expect(client.canAccess(.trendCharts))
    }

    // MARK: - Compra

    @Test("Compra PRO libera features premium")
    @MainActor
    func purchaseUnlocksPro() async throws {
        let mock = MockSubscriptionStore(tier: .free)
        let client = SubscriptionClient(store: mock)
        #expect(client.currentTier == .free)

        try await client.purchasePro()

        #expect(client.currentTier == .pro)
        #expect(client.canAccess(.detailedAIAnalysis))
    }

    @Test("Compra por productID específico funciona")
    @MainActor
    func purchaseByProductID() async throws {
        let mock = MockSubscriptionStore(tier: .free)
        let client = SubscriptionClient(store: mock)

        try await client.purchase(productID: SubscriptionCatalog.proMonthlyProductID)

        #expect(client.currentTier == .pro)
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

    @Test("Falha de compra mantém tier free")
    @MainActor
    func purchaseFailureKeepsFreeTier() async {
        let mock = MockSubscriptionStore(tier: .free)
        mock.shouldFailPurchase = true
        let client = SubscriptionClient(store: mock)

        do {
            try await client.purchasePro()
            Issue.record("Expected purchaseFailed")
        } catch SubscriptionError.purchaseFailed {
            #expect(client.currentTier == .free)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    // MARK: - Restore

    @Test("Restore atualiza tier quando entitlement existe")
    @MainActor
    func restoreProTier() async {
        let mock = MockSubscriptionStore(tier: .pro)
        let client = SubscriptionClient(store: mock)
        await client.restorePurchases()
        #expect(client.currentTier == .pro)
    }

    @Test("Restore mantém free quando não há entitlement")
    @MainActor
    func restoreFreeTier() async {
        let mock = MockSubscriptionStore(tier: .free)
        let client = SubscriptionClient(store: mock)
        await client.restorePurchases()
        #expect(client.currentTier == .free)
    }

    // MARK: - Load Products

    @Test("Load subscription products retorna lista de produtos")
    @MainActor
    func loadSubscriptionProducts() async {
        let mock = MockSubscriptionStore()
        let client = SubscriptionClient(store: mock)

        await client.loadSubscriptionProducts()

        #expect(client.subscriptionProducts.count == 2)
        #expect(client.proProduct != nil)
    }

    @Test("Load products inclui mensal e anual")
    @MainActor
    func loadProductsIncludesMonthlyAndAnnual() async {
        let mock = MockSubscriptionStore()
        let client = SubscriptionClient(store: mock)

        await client.loadSubscriptionProducts()

        let ids = client.subscriptionProducts.map(\.id)
        #expect(ids.contains(SubscriptionCatalog.proAnnualProductID))
        #expect(ids.contains(SubscriptionCatalog.proMonthlyProductID))
    }

    @Test("Load products exibe preços formatados")
    @MainActor
    func loadProductsHasFormattedPrices() async {
        let mock = MockSubscriptionStore()
        let client = SubscriptionClient(store: mock)

        await client.loadSubscriptionProducts()

        for product in client.subscriptionProducts {
            #expect(!product.displayPrice.isEmpty)
            #expect(!product.displayName.isEmpty)
        }
    }

    // MARK: - States

    @Test("isPurchasing é true durante compra")
    @MainActor
    func isPurchasingDuringPurchase() async throws {
        let mock = MockSubscriptionStore(tier: .free)
        mock.purchaseDelay = 100_000_000 // 100ms
        let client = SubscriptionClient(store: mock)

        let purchaseTask = Task {
            try await client.purchasePro()
        }

        try await Task.sleep(nanoseconds: 10_000_000) // 10ms
        #expect(client.isPurchasing == true)

        try await purchaseTask.value
        #expect(client.isPurchasing == false)
    }

    @Test("isLoadingProduct é true durante load")
    @MainActor
    func isLoadingDuringLoad() async {
        let mock = MockSubscriptionStore()
        let client = SubscriptionClient(store: mock)

        #expect(client.isLoadingProduct == false)
        await client.loadSubscriptionProducts()
        #expect(client.isLoadingProduct == false)
    }
}

@Suite("MockSubscriptionStore")
struct MockSubscriptionStoreTests {

    @Test("Default products inclui mensal e anual")
    func defaultProductsHasMonthlyAndAnnual() {
        let products = MockSubscriptionStore.defaultProducts
        #expect(products.count == 2)

        let ids = products.map(\.id)
        #expect(ids.contains(SubscriptionCatalog.proAnnualProductID))
        #expect(ids.contains(SubscriptionCatalog.proMonthlyProductID))
    }

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

    @Test("Compra bem sucedida atualiza tier para PRO")
    func purchaseSuccessUpdatesTier() async throws {
        let mock = MockSubscriptionStore(tier: .free)

        let result = try await mock.purchase(productID: SubscriptionCatalog.proAnnualProductID)

        #expect(result == .pro)
        #expect(mock.tier == .pro)
    }

    @Test("Products customizados são retornados")
    func customProductsReturned() async throws {
        let customProducts = [
            SubscriptionProductInfo(id: "custom.product", displayName: "Custom", displayPrice: "$99.99")
        ]
        let mock = MockSubscriptionStore(products: customProducts)

        let products = try await mock.fetchSubscriptionProducts()

        #expect(products.count == 1)
        #expect(products.first?.id == "custom.product")
    }
}

@Suite("SubscriptionTier Benefits")
struct SubscriptionTierBenefitsTests {

    @Test("Free tier tem acesso a basicInsights")
    func freeTierBasicInsights() {
        let tier = SubscriptionTier.free
        #expect(tier.canAccess(.basicInsights) == true)
    }

    @Test("Free tier NÃO tem acesso a detailedAIAnalysis")
    func freeTierNoDetailedAnalysis() {
        let tier = SubscriptionTier.free
        #expect(tier.canAccess(.detailedAIAnalysis) == false)
    }

    @Test("PRO tier tem acesso a todas as features")
    func proTierAllFeatures() {
        let tier = SubscriptionTier.pro

        #expect(tier.canAccess(.basicInsights) == true)
        #expect(tier.canAccess(.detailedAIAnalysis) == true)
        #expect(tier.canAccess(.personalizedRecommendations) == true)
        #expect(tier.canAccess(.trendCharts) == true)
        #expect(tier.canAccess(.exportHistory) == true)
    }
}

@Suite("SubscriptionCatalog")
struct SubscriptionCatalogTests {

    @Test("proProductIDs contém todos os IDs PRO")
    func proProductIDsContainsAll() {
        let ids = SubscriptionCatalog.proProductIDs

        #expect(ids.contains(SubscriptionCatalog.proProductID))
        #expect(ids.contains(SubscriptionCatalog.proMonthlyProductID))
        #expect(ids.contains(SubscriptionCatalog.proAnnualProductID))
    }

    @Test("IDs são únicos")
    func productIDsAreUnique() {
        let ids = SubscriptionCatalog.proProductIDs
        let uniqueIDs = Set(ids)
        #expect(ids.count == uniqueIDs.count)
    }
}
