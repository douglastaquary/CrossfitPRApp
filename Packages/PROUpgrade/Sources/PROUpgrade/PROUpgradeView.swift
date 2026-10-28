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
                                hasProducts: hasProducts,
                                selectedProductID: $selectedProductID,
                                errorMessage: $errorMessage,
                                onReloadProducts: {
                                    Task { await subscriptionClient.loadSubscriptionProducts() }
                                },
                                onPurchase: { productID in
                                    Task { await startPurchase(productID) }
                                }
                            )
                        }
                    }
                }
                .disabled(purchaseState != .idle)

                if purchaseState != .idle {
                    PROUpgradeProcessingOverlay(
                        purchaseState: purchaseState,
                        onRetry: { purchaseState = .idle }
                    )
                }
            }
            .task {
                await subscriptionClient.loadSubscriptionProducts()
            }
            .onChange(of: subscriptionClient.currentTier) { tier in
                handleTierChange(tier)
            }
        }
        .brandTint()
    }

    private func handleTierChange(_ tier: SubscriptionTier) {
        guard tier == .pro else { return }
        purchaseState = .success
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }

    private func startPurchase(_ productID: String) async {
        errorMessage = nil

        withAnimation {
            purchaseState = .connecting
        }

        try? await Task.sleep(nanoseconds: 800_000_000)

        withAnimation {
            purchaseState = .processing
        }

        try? await Task.sleep(nanoseconds: 600_000_000)

        withAnimation {
            purchaseState = .confirming
        }

        do {
            try await subscriptionClient.purchase(productID: productID)
        } catch let error as SubscriptionError {
            withAnimation {
                purchaseState = .error(error.localizedMessage)
            }
        } catch {
            withAnimation {
                purchaseState = .error(Strings.PRO.purchaseFallbackError)
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
    case error(String)
}
