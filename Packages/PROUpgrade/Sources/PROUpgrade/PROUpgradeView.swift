import SwiftUI
import Domain
import Subscription
import SharedUI
import Localization

public struct PROUpgradeView: View {
    @EnvironmentObject private var subscriptionClient: SubscriptionClient
    @Environment(\.dismiss) private var dismiss

    @State private var errorMessage: String?
    @State private var selectedProductID: String?
    @State private var purchaseState: PurchaseState = .idle

    public init() {}

    private var annualProduct: SubscriptionProductInfo? {
        subscriptionClient.subscriptionProducts.first {
            $0.id == SubscriptionCatalog.proAnnualProductID
        }
    }

    private var monthlyProduct: SubscriptionProductInfo? {
        subscriptionClient.subscriptionProducts.first {
            $0.id == SubscriptionCatalog.proMonthlyProductID
        }
    }

    private var eliteAnnualProduct: SubscriptionProductInfo? {
        subscriptionClient.subscriptionProducts.first {
            $0.id == SubscriptionCatalog.eliteAnnualProductID
        }
    }

    private var eliteMonthlyProduct: SubscriptionProductInfo? {
        subscriptionClient.subscriptionProducts.first {
            $0.id == SubscriptionCatalog.eliteMonthlyProductID
        }
    }

    private var hasProducts: Bool {
        !subscriptionClient.subscriptionProducts.isEmpty
    }

    public var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        PROUpgradeCloseButton(onDismiss: { dismiss() })

                        if subscriptionClient.isLoadingProduct {
                            LoadingView(messageKey: "loading.view.title")
                        } else {
                            PROUpgradePurchaseContent(
                                monthlyProduct: monthlyProduct,
                                annualProduct: annualProduct,
                                eliteMonthlyProduct: eliteMonthlyProduct,
                                eliteAnnualProduct: eliteAnnualProduct,
                                hasProducts: hasProducts,
                                selectedProductID: $selectedProductID,
                                errorMessage: $errorMessage,
                                onReloadProducts: {
                                    Task { await subscriptionClient.loadSubscriptionProducts() }
                                },
                                onPurchase: { productID in
                                    Task { await startPurchase(productID) }
                                },
                                onRestore: {
                                    Task { await startRestore() }
                                }
                            )
                        }
                    }
                }
                .accessibilityIdentifier("pro.upgrade.scroll")
                .disabled(purchaseState != .idle)

                if purchaseState != .idle {
                    PROUpgradeProcessingOverlay(
                        purchaseState: purchaseState,
                        onRetry: { purchaseState = .idle },
                        onClosePending: { dismiss() }
                    )
                }
            }
            .task {
                await subscriptionClient.loadSubscriptionProducts()
                // UI tests: pré-seleciona PRO mensal (SwiftUI .disabled mente isEnabled no XCTest).
                if ProcessInfo.processInfo.environment["UITEST_SKIP_SPLASH"] == "1",
                   selectedProductID == nil {
                    selectedProductID = monthlyProduct?.id
                        ?? annualProduct?.id
                        ?? subscriptionClient.subscriptionProducts.first?.id
                }
            }
            .onChange(of: subscriptionClient.currentTier) { tier in
                handleTierChange(tier)
            }
        }
        .brandTint()
    }

    private func handleTierChange(_ tier: SubscriptionTier) {
        guard tier.isPaid else { return }
        guard purchaseState.isInFlight || purchaseState == .pending else { return }
        withAnimation {
            purchaseState = .success
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            dismiss()
        }
    }

    /// Fluxo alinhado ao StoreKit: conectar → sheet Apple → confirmar entitlements → sucesso.
    private func startPurchase(_ productID: String) async {
        errorMessage = nil

        withAnimation {
            purchaseState = .connecting
        }
        // Breve feedback visual antes do sheet Apple (sem delays artificiais longos).
        try? await Task.sleep(nanoseconds: 250_000_000)

        withAnimation {
            purchaseState = .processing
        }

        do {
            try await subscriptionClient.purchase(productID: productID)

            withAnimation {
                purchaseState = .confirming
            }

            // Garante sync dual (cliente ↔ entitlements) mesmo se o onChange atrasar.
            await subscriptionClient.refreshStatus()

            if subscriptionClient.currentTier.isPaid {
                withAnimation {
                    purchaseState = .success
                }
                try? await Task.sleep(nanoseconds: 1_800_000_000)
                dismiss()
            } else {
                withAnimation {
                    purchaseState = .pending
                }
            }
        } catch let error as SubscriptionError {
            await handleSubscriptionError(error)
        } catch {
            withAnimation {
                purchaseState = .error(
                    title: Strings.Purchase.errorTitle,
                    message: Strings.PRO.purchaseFallbackError
                )
            }
        }
    }

    private func startRestore() async {
        errorMessage = nil
        withAnimation {
            purchaseState = .confirming
        }

        let tier = await subscriptionClient.restorePurchases()
        if tier.isPaid {
            withAnimation {
                purchaseState = .success
            }
            try? await Task.sleep(nanoseconds: 1_800_000_000)
            dismiss()
        } else {
            withAnimation {
                purchaseState = .error(
                    title: Strings.Purchase.restoreNothingFound,
                    message: Strings.Purchase.restoreNothingFoundDetail
                )
            }
        }
    }

    private func handleSubscriptionError(_ error: SubscriptionError) async {
        switch error {
        case .userCancelled:
            withAnimation {
                purchaseState = .idle
            }
        case .pending:
            withAnimation {
                purchaseState = .pending
            }
        case .productUnavailable, .purchaseFailed:
            let message = error.localizedMessage.isEmpty
                ? Strings.PRO.purchaseFallbackError
                : error.localizedMessage
            withAnimation {
                purchaseState = .error(
                    title: Strings.Purchase.errorTitle,
                    message: message
                )
            }
        }
    }
}

enum PurchaseState: Equatable {
    case idle
    case connecting
    case processing
    case confirming
    case success
    case pending
    case error(title: String, message: String)

    var isInFlight: Bool {
        switch self {
        case .connecting, .processing, .confirming:
            return true
        default:
            return false
        }
    }
}
