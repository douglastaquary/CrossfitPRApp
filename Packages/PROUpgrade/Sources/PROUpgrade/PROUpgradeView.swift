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
                        closeButton

                        if subscriptionClient.isLoadingProduct {
                            LoadingView(messageKey: "loading.view.title")
                        } else {
                            purchaseContent
                        }
                    }
                }
                .disabled(purchaseState != .idle)

                if purchaseState != .idle {
                    processingOverlay
                }
            }
            .task {
                await subscriptionClient.loadSubscriptionProducts()
            }
            .onChange(of: subscriptionClient.currentTier) { tier in
                if tier == .pro {
                    purchaseState = .success
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                    }
                }
            }
        }
        .brandTint()
    }

    // MARK: - Processing Overlay

    private var processingOverlay: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                switch purchaseState {
                case .idle:
                    EmptyView()

                case .connecting:
                    processingStep(
                        icon: "wifi",
                        title: "Conectando à App Store...",
                        isAnimating: true
                    )

                case .processing:
                    processingStep(
                        icon: "creditcard",
                        title: "Processando pagamento...",
                        isAnimating: true
                    )

                case .confirming:
                    processingStep(
                        icon: "checkmark.shield",
                        title: "Confirmando assinatura...",
                        isAnimating: true
                    )

                case .success:
                    processingStep(
                        icon: "checkmark.circle.fill",
                        title: "Assinatura ativada!",
                        isAnimating: false,
                        color: AppDesign.Colors.brand
                    )

                case .error(let message):
                    VStack(spacing: 16) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(AppDesign.Colors.error)

                        Text("Ops, algo deu errado")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Text(message)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                            .multilineTextAlignment(.center)

                        Button("Tentar novamente") {
                            purchaseState = .idle
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(AppDesign.Colors.brand)
                    }
                }
            }
            .padding(40)
        }
        .transition(.opacity)
    }

    private func processingStep(
        icon: String,
        title: String,
        isAnimating: Bool,
        color: Color = .white
    ) -> some View {
        VStack(spacing: 20) {
            ZStack {
                if isAnimating {
                    Circle()
                        .stroke(color.opacity(0.3), lineWidth: 4)
                        .frame(width: 80, height: 80)

                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(color, lineWidth: 4)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                        .animation(
                            .linear(duration: 1).repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }

                Image(systemName: icon)
                    .font(.system(size: isAnimating ? 28 : 48))
                    .foregroundStyle(color)
            }

            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
        }
    }

    // MARK: - Close Button

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

    // MARK: - Purchase Content

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

    // MARK: - Pricing Section

    private var pricingSection: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Text("Escolha seu plano")
                    .font(.headline)

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

            trialButton

            Text(Strings.tr("purchase.lessthancoffe"))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var trialButton: some View {
        Button {
            guard let productID = selectedProductID else {
                errorMessage = "Selecione um plano para continuar"
                return
            }
            Task { await startPurchase(productID) }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "gift")
                    .font(.title3)
                Text(Strings.tr("purchase.tryfree.title"))
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(selectedProductID != nil ? AppDesign.Colors.brand : Color.gray)
            .foregroundStyle(.white)
            .cornerRadius(12)
        }
        .disabled(selectedProductID == nil)
    }

    private func productOption(
        product: SubscriptionProductInfo,
        label: String,
        badge: String?,
        isSelected: Bool
    ) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedProductID = product.id
                errorMessage = nil
            }
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

    // MARK: - Purchase Flow

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

// MARK: - Purchase State

enum PurchaseState: Equatable {
    case idle
    case connecting
    case processing
    case confirming
    case success
    case error(String)
}
