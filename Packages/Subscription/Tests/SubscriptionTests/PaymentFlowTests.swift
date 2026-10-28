import Foundation
import Testing
@testable import Subscription
import Domain

/// Fluxo de pagamento automatizado (mock) — compra, cancel, fail, pending, restore.
/// Espelha os cenários de `docs/STOREKIT-PAYMENTS.md` e alimenta CI sem sheet Apple.
@Suite("Payment flow")
struct PaymentFlowTests {

    @Test("Compra PRO mensal registra tier no cliente após reconcile")
    @MainActor
    func purchaseProMonthlySucceeds() async throws {
        let mock = MockSubscriptionStore(tier: .free, simulatedPurchaseOutcome: .succeed)
        let client = SubscriptionClient(store: mock)

        try await client.purchase(productID: SubscriptionCatalog.proMonthlyProductID)

        #expect(client.currentTier == .pro)
        #expect(client.canAccess(.detailedAIAnalysis))
        #expect(!client.canAccess(.athleteAssessment))
    }

    @Test("Compra Elite mensal libera assessment")
    @MainActor
    func purchaseEliteMonthlySucceeds() async throws {
        let mock = MockSubscriptionStore(tier: .free, simulatedPurchaseOutcome: .succeed)
        let client = SubscriptionClient(store: mock)

        try await client.purchase(productID: SubscriptionCatalog.eliteMonthlyProductID)

        #expect(client.currentTier == .elite)
        #expect(client.canAccess(.athleteAssessment))
    }

    @Test("Cancelar sheet (userCancelled) mantém free")
    @MainActor
    func purchaseCancelKeepsFree() async {
        let mock = MockSubscriptionStore(tier: .free, simulatedPurchaseOutcome: .cancel)
        let client = SubscriptionClient(store: mock)

        do {
            try await client.purchase(productID: SubscriptionCatalog.proAnnualProductID)
            Issue.record("Expected userCancelled")
        } catch SubscriptionError.userCancelled {
            #expect(client.currentTier == .free)
        } catch {
            Issue.record("Unexpected \(error)")
        }
    }

    @Test("Falha de pagamento mantém free")
    @MainActor
    func purchaseFailKeepsFree() async {
        let mock = MockSubscriptionStore(tier: .free, simulatedPurchaseOutcome: .fail)
        let client = SubscriptionClient(store: mock)

        do {
            try await client.purchase(productID: SubscriptionCatalog.proMonthlyProductID)
            Issue.record("Expected purchaseFailed")
        } catch SubscriptionError.purchaseFailed {
            #expect(client.currentTier == .free)
        } catch {
            Issue.record("Unexpected \(error)")
        }
    }

    @Test("Pending não altera tier até entitlement")
    @MainActor
    func purchasePendingKeepsFree() async {
        let mock = MockSubscriptionStore(tier: .free, simulatedPurchaseOutcome: .pending)
        let client = SubscriptionClient(store: mock)

        do {
            try await client.purchase(productID: SubscriptionCatalog.proMonthlyProductID)
            Issue.record("Expected pending")
        } catch SubscriptionError.pending {
            #expect(client.currentTier == .free)
        } catch {
            Issue.record("Unexpected \(error)")
        }
    }

    @Test("Restore sem compra retorna free")
    @MainActor
    func restoreWithoutPurchase() async {
        let mock = MockSubscriptionStore(tier: .free)
        let client = SubscriptionClient(store: mock)

        let tier = await client.restorePurchases()

        #expect(tier == .free)
        #expect(client.currentTier == .free)
    }

    @Test("Restore com entitlement PRO")
    @MainActor
    func restoreWithProEntitlement() async {
        let mock = MockSubscriptionStore(tier: .pro)
        let client = SubscriptionClient(store: mock)

        let tier = await client.restorePurchases()

        #expect(tier == .pro)
        #expect(client.currentTier == .pro)
    }

    @Test("Flags legadas shouldThrowCancelled ainda funcionam")
    @MainActor
    func legacyCancelFlag() async {
        let mock = MockSubscriptionStore(tier: .free)
        mock.shouldThrowCancelled = true
        let client = SubscriptionClient(store: mock)

        do {
            try await client.purchasePro()
            Issue.record("Expected userCancelled")
        } catch SubscriptionError.userCancelled {
            #expect(client.currentTier == .free)
        } catch {
            Issue.record("Unexpected \(error)")
        }
    }
}
