import SwiftUI
import Domain
import Subscription
import SharedUI
import Localization

public struct PROUpgradeView: View {
    @EnvironmentObject private var subscriptionClient: SubscriptionClient
    @Environment(\.dismiss) private var dismiss

    @State private var errorMessage: String?

    public init() {}

    private var annualProduct: SubscriptionProductInfo? {
        subscriptionClient.subscriptionProducts.first {
            $0.id == SubscriptionCatalog.proAnnualProductID
        } ?? subscriptionClient.subscriptionProducts.first
    }

    private var monthlyProduct: SubscriptionProductInfo? {
        subscriptionClient.subscriptionProducts.first {
            $0.id == SubscriptionCatalog.proMonthlyProductID
        } ?? subscriptionClient.subscriptionProducts.dropFirst().first
    }

    public var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HStack {
                        Spacer()
                        Button(Strings.NewPR.cancel) { dismiss() }
                            .foregroundStyle(AppDesign.Colors.brand)
                    }
                    .padding([.top, .trailing], 24)

                    if subscriptionClient.isLoadingProduct {
                        LoadingView(messageKey: "loading.view.title")
                    } else if subscriptionClient.isPurchasing {
                        LoadingView(messageKey: "purchase.processing.description")
                    } else {
                        purchaseContent
                    }
                }
            }
            .task {
                await subscriptionClient.loadSubscriptionProducts()
            }
            .onChange(of: subscriptionClient.currentTier) { tier in
                if tier == .pro { dismiss() }
            }
        }
        .brandTint()
    }

    private var purchaseContent: some View {
        VStack(spacing: 12) {
            Text("CrossFitPR PRO")
                .font(.title.weight(.semibold))
                .foregroundStyle(AppDesign.Colors.brand)
                .padding(.top)

            HViewImageAndText(
                image: "gearshape",
                imageColor: AppDesign.Colors.brand,
                title: "purchase.item1.title",
                description: "purchase.item1.description"
            )
            HViewImageAndText(
                image: AppDesign.Icon.tabInsights,
                imageColor: AppDesign.Colors.brand,
                title: "purchase.item2.title",
                description: "purchase.item2.description"
            )
            HViewImageAndText(
                image: "trophy",
                imageColor: AppDesign.Colors.brand,
                title: "purchase.item3.title",
                description: "purchase.item3.description"
            )

            Text(Strings.tr("purchase.tryfree.title"))
                .fontWeight(.bold)
                .padding()

            if let monthly = monthlyProduct {
                Button("\(monthly.displayPrice) / Month") {
                    Task { await purchase(monthly.id) }
                }
                .buttonStyle(OutlineButtonStyle())
            }

            if let annual = annualProduct {
                Button("\(annual.displayPrice) / Year") {
                    Task { await purchase(annual.id) }
                }
                .buttonStyle(FilledButtonStyle(fullWidth: true))
            }

            Text(Strings.tr("purchase.commitment.title"))
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(AppDesign.Colors.error)
            }
        }
        .padding()
    }

    private func purchase(_ productID: String) async {
        errorMessage = nil
        do {
            try await subscriptionClient.purchase(productID: productID)
            dismiss()
        } catch let error as SubscriptionError {
            let message = error.localizedMessage
            if !message.isEmpty { errorMessage = message }
        } catch {
            errorMessage = Strings.PRO.purchaseFallbackError
        }
    }
}
