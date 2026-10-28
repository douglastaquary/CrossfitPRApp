import Foundation
import Domain

/// Mock do store — testes unitários, preview e UI tests no simulador (sem sheet Apple).
public final class MockSubscriptionStore: SubscriptionStoreProviding, @unchecked Sendable {
    public enum SimulatedPurchaseOutcome: String, Sendable {
        case succeed
        case cancel
        case fail
        case pending
    }

    public var tier: SubscriptionTier
    public var products: [SubscriptionProductInfo]
    public var shouldFailPurchase = false
    public var shouldThrowCancelled = false
    public var purchaseDelay: UInt64 = 0
    /// Controla o resultado da próxima `purchase` (UI tests / cenários).
    public var simulatedPurchaseOutcome: SimulatedPurchaseOutcome = .succeed

    public init(
        tier: SubscriptionTier = .free,
        products: [SubscriptionProductInfo]? = nil,
        simulatedPurchaseOutcome: SimulatedPurchaseOutcome = .succeed
    ) {
        self.tier = tier
        self.products = products ?? Self.defaultProducts
        self.simulatedPurchaseOutcome = simulatedPurchaseOutcome
    }

    public static var defaultProducts: [SubscriptionProductInfo] {
        [
            SubscriptionProductInfo(
                id: SubscriptionCatalog.eliteAnnualProductID,
                displayName: "Elite Anual",
                displayPrice: "R$ 79,90/ano"
            ),
            SubscriptionProductInfo(
                id: SubscriptionCatalog.eliteMonthlyProductID,
                displayName: "Elite Mensal",
                displayPrice: "R$ 19,90/mês"
            ),
            SubscriptionProductInfo(
                id: SubscriptionCatalog.proAnnualProductID,
                displayName: "PRO Anual",
                displayPrice: "R$ 39,90/ano"
            ),
            SubscriptionProductInfo(
                id: SubscriptionCatalog.proMonthlyProductID,
                displayName: "PRO Mensal",
                displayPrice: "R$ 9,90/mês"
            ),
        ]
    }

    public func fetchProProduct() async throws -> SubscriptionProductInfo? {
        products.first { SubscriptionCatalog.proProductIDs.contains($0.id) }
    }

    public func fetchSubscriptionProducts() async throws -> [SubscriptionProductInfo] {
        products
    }

    public func purchase(productID: String) async throws -> SubscriptionTier {
        if purchaseDelay > 0 {
            try? await Task.sleep(nanoseconds: purchaseDelay)
        }

        let outcome: SimulatedPurchaseOutcome
        if shouldThrowCancelled {
            outcome = .cancel
        } else if shouldFailPurchase {
            outcome = .fail
        } else {
            outcome = simulatedPurchaseOutcome
        }

        switch outcome {
        case .cancel:
            throw SubscriptionError.userCancelled
        case .fail:
            throw SubscriptionError.purchaseFailed
        case .pending:
            throw SubscriptionError.pending
        case .succeed:
            let resolved = SubscriptionCatalog.tier(forProductID: productID) ?? .pro
            tier = resolved
            return resolved
        }
    }

    public func resolveCurrentTier() async -> SubscriptionTier {
        tier
    }
}
