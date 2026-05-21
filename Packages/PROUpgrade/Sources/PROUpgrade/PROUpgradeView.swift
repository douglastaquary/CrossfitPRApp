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
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    closeButton

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
                if selectedProductID == nil, let annual = annualProduct {
                    selectedProductID = annual.id
                }
            }
            .onChange(of: subscriptionClient.currentTier) { tier in
                if tier == .pro { dismiss() }
            }
        }
        .brandTint()
    }

    private var closeButton: some View {
        HStack {
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding([.top, .trailing], 20)
    }

    private var purchaseContent: some View {
        VStack(spacing: 24) {
            headerSection

            benefitsSection

            if hasProducts {
                pricingSection
            } else {
                noProductsSection
            }

            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(AppDesign.Colors.error)
                    .padding(.horizontal)
            }

            commitmentSection
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(AppDesign.Colors.proAccent)

            Text(Strings.tr("pro.title"))
                .font(.title.bold())

            Text(Strings.tr("pro.subtitle"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }

    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(Strings.tr("pro.sectionBenefits"))
                .font(.headline)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                benefitRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: Strings.tr("purchase.item1.title"),
                    description: Strings.tr("purchase.item1.description"),
                    color: AppDesign.Colors.brand
                )
                Divider().padding(.leading, 52)
                benefitRow(
                    icon: "sparkles",
                    title: Strings.tr("purchase.item2.title"),
                    description: Strings.tr("purchase.item2.description"),
                    color: .purple
                )
                Divider().padding(.leading, 52)
                benefitRow(
                    icon: "trophy.fill",
                    title: Strings.tr("purchase.item3.title"),
                    description: Strings.tr("purchase.item3.description"),
                    color: .orange
                )
            }
            .padding()
            .background(AppDesign.Colors.cardBackground)
            .cornerRadius(12)
        }
    }

    private func benefitRow(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 28, height: 28)
                .foregroundStyle(color)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 12)
    }

    private var pricingSection: some View {
        VStack(spacing: 20) {
            trialButton

            Text(Strings.tr("purchase.lessthancoffe"))
                .font(.caption)
                .foregroundStyle(.secondary)

            VStack(spacing: 12) {
                Text("Escolha seu plano")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)

                if let monthly = monthlyProduct {
                    productOption(
                        product: monthly,
                        label: "Mensal",
                        badge: nil,
                        isSelected: selectedProductID == monthly.id
                    )
                }

                if let annual = annualProduct {
                    productOption(
                        product: annual,
                        label: "Anual",
                        badge: "Melhor valor",
                        isSelected: selectedProductID == annual.id
                    )
                }
            }

            subscribeButton
        }
    }

    private var trialButton: some View {
        Button {
            if let annual = annualProduct {
                selectedProductID = annual.id
                Task { await purchase(annual.id) }
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "gift")
                    .font(.title3)
                Text(Strings.tr("purchase.tryfree.title"))
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(AppDesign.Colors.brand)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppDesign.Colors.brand, lineWidth: 2)
            )
        }
    }

    private func productOption(
        product: SubscriptionProductInfo,
        label: String,
        badge: String?,
        isSelected: Bool
    ) -> some View {
        Button {
            selectedProductID = product.id
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        Text(label)
                            .font(.subheadline.weight(.semibold))
                        if let badge {
                            Text(badge)
                                .font(.caption2.bold())
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(AppDesign.Colors.proAccent)
                                .foregroundStyle(.white)
                                .cornerRadius(4)
                        }
                    }
                    Text(product.displayPrice)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? AppDesign.Colors.brand : .secondary)
            }
            .padding()
            .background(AppDesign.Colors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppDesign.Colors.brand : Color.secondary.opacity(0.2), lineWidth: isSelected ? 2 : 1)
            )
        }
        .foregroundStyle(.primary)
    }

    private var subscribeButton: some View {
        Button {
            guard let productID = selectedProductID else { return }
            Task { await purchase(productID) }
        } label: {
            Text("Assinar agora")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppDesign.Colors.brand)
                .foregroundStyle(.white)
                .cornerRadius(12)
        }
        .disabled(selectedProductID == nil)
    }

    private var noProductsSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text("Produtos indisponíveis")
                .font(.headline)
            Text("Não foi possível carregar os planos. Tente novamente.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Tentar novamente") {
                Task { await subscriptionClient.loadSubscriptionProducts() }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }

    private var commitmentSection: some View {
        Text(Strings.tr("purchase.commitment.title"))
            .font(.caption)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .padding(.top, 8)
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
