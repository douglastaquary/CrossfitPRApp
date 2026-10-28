import SwiftUI
import Domain
import Subscription
import SharedUI
import Localization

// MARK: - Purchase Content

struct PROUpgradePurchaseContent: View {
    let monthlyProduct: SubscriptionProductInfo?
    let annualProduct: SubscriptionProductInfo?
    let hasProducts: Bool
    @Binding var selectedProductID: String?
    @Binding var errorMessage: String?
    let onReloadProducts: () -> Void
    let onPurchase: (String) -> Void

    var body: some View {
        VStack(spacing: 24) {
            PROUpgradeHeaderSection()
            PROUpgradeBenefitsSection()

            if hasProducts {
                PROUpgradePricingSection(
                    monthlyProduct: monthlyProduct,
                    annualProduct: annualProduct,
                    selectedProductID: $selectedProductID,
                    errorMessage: $errorMessage,
                    onPurchase: onPurchase
                )
            } else {
                PROUpgradeNoProductsSection(onReload: onReloadProducts)
            }

            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(AppDesign.Colors.error)
                    .padding(.horizontal)
            }

            PROUpgradeCommitmentSection()
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }
}

struct PROUpgradeCloseButton: View {
    let onDismiss: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .accessibilityIdentifier("pro.upgrade.close")
        }
        .padding([.top, .trailing], 20)
    }
}

struct PROUpgradeHeaderSection: View {
    var body: some View {
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
}

struct PROUpgradeBenefitsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(Strings.tr("pro.sectionBenefits"))
                .font(.headline)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                PROUpgradeBenefitRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: Strings.tr("purchase.item1.title"),
                    description: Strings.tr("purchase.item1.description"),
                    color: AppDesign.Colors.brand
                )
                Divider().padding(.leading, 52)
                PROUpgradeBenefitRow(
                    icon: "sparkles",
                    title: Strings.tr("purchase.item2.title"),
                    description: Strings.tr("purchase.item2.description"),
                    color: .purple
                )
                Divider().padding(.leading, 52)
                PROUpgradeBenefitRow(
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
}

struct PROUpgradeBenefitRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
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
}

struct PROUpgradePricingSection: View {
    let monthlyProduct: SubscriptionProductInfo?
    let annualProduct: SubscriptionProductInfo?
    @Binding var selectedProductID: String?
    @Binding var errorMessage: String?
    let onPurchase: (String) -> Void

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Text(Strings.PRO.Upgrade.choosePlan)
                    .font(.headline)

                if let monthly = monthlyProduct {
                    PROUpgradeProductOption(
                        product: monthly,
                        label: Strings.Purchase.monthlyPlan,
                        badge: nil,
                        isSelected: selectedProductID == monthly.id,
                        onSelect: { select(monthly.id) }
                    )
                }

                if let annual = annualProduct {
                    PROUpgradeProductOption(
                        product: annual,
                        label: Strings.Purchase.annualPlan,
                        badge: Strings.Purchase.bestValueBadge,
                        isSelected: selectedProductID == annual.id,
                        onSelect: { select(annual.id) }
                    )
                }
            }

            PROUpgradeTrialButton(
                selectedProductID: selectedProductID,
                errorMessage: $errorMessage,
                onPurchase: onPurchase
            )

            Text(Strings.tr("purchase.lessthancoffe"))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func select(_ productID: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedProductID = productID
            errorMessage = nil
        }
    }
}

struct PROUpgradeTrialButton: View {
    let selectedProductID: String?
    @Binding var errorMessage: String?
    let onPurchase: (String) -> Void

    var body: some View {
        Button(action: tapPurchase) {
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

    private func tapPurchase() {
        guard let productID = selectedProductID else {
            errorMessage = Strings.Purchase.selectPlanRequired
            return
        }
        onPurchase(productID)
    }
}

struct PROUpgradeProductOption: View {
    let product: SubscriptionProductInfo
    let label: String
    let badge: String?
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
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
                    .stroke(
                        isSelected ? AppDesign.Colors.brand : Color.secondary.opacity(0.2),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .foregroundStyle(.primary)
    }
}

struct PROUpgradeNoProductsSection: View {
    let onReload: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(Strings.PRO.Upgrade.productsUnavailableTitle)
                .font(.headline)
            Text(Strings.PRO.Upgrade.productsUnavailableMessage)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button(Strings.Purchase.retry, action: onReload)
                .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct PROUpgradeCommitmentSection: View {
    var body: some View {
        Text(Strings.tr("purchase.commitment.title"))
            .font(.caption)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .padding(.top, 8)
    }
}

// MARK: - Processing Overlay

struct PROUpgradeProcessingOverlay: View {
    let purchaseState: PurchaseState
    let onRetry: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                switch purchaseState {
                case .idle:
                    EmptyView()

                case .connecting:
                    PROUpgradeProcessingStep(
                        icon: "wifi",
                        title: Strings.Purchase.stateConnecting,
                        isAnimating: true
                    )

                case .processing:
                    PROUpgradeProcessingStep(
                        icon: "creditcard",
                        title: Strings.Purchase.stateProcessing,
                        isAnimating: true
                    )

                case .confirming:
                    PROUpgradeProcessingStep(
                        icon: "checkmark.shield",
                        title: Strings.Purchase.stateConfirming,
                        isAnimating: true
                    )

                case .success:
                    PROUpgradeProcessingStep(
                        icon: "checkmark.circle.fill",
                        title: Strings.Purchase.stateSuccess,
                        isAnimating: false,
                        color: AppDesign.Colors.brand
                    )

                case .error(let message):
                    PROUpgradeProcessingError(message: message, onRetry: onRetry)
                }
            }
            .padding(40)
        }
        .transition(.opacity)
    }
}

struct PROUpgradeProcessingStep: View {
    let icon: String
    let title: String
    let isAnimating: Bool
    var color: Color = .white

    var body: some View {
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
}

struct PROUpgradeProcessingError: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 48))
                .foregroundStyle(AppDesign.Colors.error)

            Text(Strings.PRO.Upgrade.genericError)
                .font(.headline)
                .foregroundStyle(.white)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)

            Button(Strings.Purchase.retry, action: onRetry)
                .buttonStyle(.borderedProminent)
                .tint(AppDesign.Colors.brand)
        }
    }
}
