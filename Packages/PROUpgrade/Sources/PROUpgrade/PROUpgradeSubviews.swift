import SwiftUI
import Domain
import Subscription
import SharedUI
import Localization

// MARK: - Purchase Content

struct PROUpgradePurchaseContent: View {
    let monthlyProduct: SubscriptionProductInfo?
    let annualProduct: SubscriptionProductInfo?
    let eliteMonthlyProduct: SubscriptionProductInfo?
    let eliteAnnualProduct: SubscriptionProductInfo?
    let hasProducts: Bool
    @Binding var selectedProductID: String?
    @Binding var errorMessage: String?
    let onReloadProducts: () -> Void
    let onPurchase: (String) -> Void
    let onRestore: () -> Void

    /// Pickers da variante B (CPR-014).
    @State var selectedTier: PaywallTierPick = .pro
    @State var selectedPeriod: PaywallPeriodPick = .annual

    var body: some View {
        conversionBody
    }
}

enum PaywallTierPick {
    case pro
    case elite
}

enum PaywallPeriodPick {
    case monthly
    case annual
}

struct PROUpgradeRestoreSection: View {
    let onRestore: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Button(action: onRestore) {
                Text(Strings.Purchase.restore)
                    .font(.subheadline.weight(.semibold))
            }
            .buttonStyle(.bordered)
            .accessibilityIdentifier("pro.upgrade.restore")

            Text(Strings.Purchase.restoreHint)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Text(Strings.Purchase.renewNote)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
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
            Image(systemName: AppDesign.Icon.eliteBadge)
                .font(.system(size: 48))
                .foregroundStyle(AppDesign.Colors.eliteAccent)

            Text(Strings.Elite.competitorMode)
                .font(.caption.bold())
                .foregroundStyle(AppDesign.Colors.eliteAccent)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(AppDesign.Colors.eliteAccent.opacity(0.15))
                .cornerRadius(8)

            Text(Strings.Elite.title)
                .font(.title.bold())

            Text(Strings.Elite.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

struct PROUpgradePlanCompareSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Strings.Elite.sectionCompare)
                .font(.headline)
                .padding(.leading, 4)

            HStack(alignment: .top, spacing: 8) {
                PROUpgradePlanColumn(
                    title: Strings.Elite.planFree,
                    accent: AppDesign.Colors.metadataChip,
                    points: [
                        Strings.ProFeatureCopy.marketingTitle(.basicInsights),
                    ]
                )
                PROUpgradePlanColumn(
                    title: Strings.Elite.planPro,
                    accent: AppDesign.Colors.proAccent,
                    points: [
                        Strings.ProFeatureCopy.marketingTitle(.detailedAIAnalysis),
                        Strings.ProFeatureCopy.marketingTitle(.workoutEngineAnalysis),
                    ]
                )
                PROUpgradePlanColumnElite(
                    title: Strings.Elite.planElite,
                    points: [
                        Strings.Elite.benefitAssessment,
                        Strings.Elite.benefitLimiting,
                        Strings.Elite.benefitDense,
                    ]
                )
            }
        }
    }
}

struct PROUpgradePlanColumn: View {
    let title: String
    let accent: Color
    let points: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(accent)
            ForEach(points, id: \.self) { point in
                Text("• \(point)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(10)
        .background(AppDesign.Colors.cardBackground)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(accent.opacity(0.35), lineWidth: 1)
        )
    }
}

struct PROUpgradePlanColumnElite: View {
    let title: String
    let points: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: AppDesign.Icon.eliteBadge)
                    .font(.caption2)
                Text(title)
                    .font(.caption.bold())
            }
            .foregroundStyle(AppDesign.Colors.eliteAccent)

            ForEach(points, id: \.self) { point in
                Text("• \(point)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(10)
        .background(AppDesign.Colors.eliteAccent.opacity(0.08))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppDesign.Colors.eliteAccent, lineWidth: 1.5)
        )
    }
}

struct PROUpgradeEliteBenefitsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(Strings.Elite.badge)
                .font(.headline)
                .foregroundStyle(AppDesign.Colors.eliteAccent)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                PROUpgradeBenefitRow(
                    icon: AppDesign.Icon.eliteBadge,
                    title: Strings.Elite.benefitAssessment,
                    description: Strings.ProFeatureCopy.marketingTitle(.athleteAssessment),
                    color: AppDesign.Colors.eliteAccent
                )
                Divider().padding(.leading, 52)
                PROUpgradeBenefitRow(
                    icon: "target",
                    title: Strings.Elite.benefitLimiting,
                    description: Strings.ProFeatureCopy.marketingTitle(.limitingFactorAnalysis),
                    color: AppDesign.Colors.eliteAccent
                )
            }
            .padding()
            .background(AppDesign.Colors.cardBackground)
            .cornerRadius(12)
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
    let eliteMonthlyProduct: SubscriptionProductInfo?
    let eliteAnnualProduct: SubscriptionProductInfo?
    @Binding var selectedProductID: String?
    @Binding var errorMessage: String?
    let onPurchase: (String) -> Void
    let onRestore: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Text(Strings.PRO.Upgrade.choosePlan)
                    .font(.headline)

                // PRO primeiro (acima da dobra) — Elite abaixo para scroll.
                if let monthly = monthlyProduct {
                    PROUpgradeProductOption(
                        product: monthly,
                        label: Strings.Purchase.monthlyPlan,
                        badge: Strings.Elite.planPro,
                        badgeColor: AppDesign.Colors.proAccent,
                        isSelected: selectedProductID == monthly.id,
                        onSelect: { select(monthly.id) }
                    )
                }

                if let annual = annualProduct {
                    PROUpgradeProductOption(
                        product: annual,
                        label: Strings.Purchase.annualPlan,
                        badge: Strings.Purchase.bestValueBadge,
                        badgeColor: AppDesign.Colors.proAccent,
                        isSelected: selectedProductID == annual.id,
                        onSelect: { select(annual.id) }
                    )
                }

                PROUpgradeTrialButton(
                    selectedProductID: selectedProductID,
                    errorMessage: $errorMessage,
                    onPurchase: onPurchase
                )

                PROUpgradeRestoreSection(onRestore: onRestore)

                if eliteMonthlyProduct != nil || eliteAnnualProduct != nil {
                    Text(Strings.Elite.chooseElitePlan)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppDesign.Colors.eliteAccent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)
                }

                if let eliteMonthly = eliteMonthlyProduct {
                    PROUpgradeProductOption(
                        product: eliteMonthly,
                        label: Strings.Elite.monthlyPlan,
                        badge: Strings.Elite.badge,
                        badgeColor: AppDesign.Colors.eliteAccent,
                        isSelected: selectedProductID == eliteMonthly.id,
                        onSelect: { select(eliteMonthly.id) }
                    )
                }

                if let eliteAnnual = eliteAnnualProduct {
                    PROUpgradeProductOption(
                        product: eliteAnnual,
                        label: Strings.Elite.annualPlan,
                        badge: Strings.Purchase.bestValueBadge,
                        badgeColor: AppDesign.Colors.eliteAccent,
                        isSelected: selectedProductID == eliteAnnual.id,
                        onSelect: { select(eliteAnnual.id) }
                    )
                }
            }

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
        // Altura alinhada aos CTAs do app (ex.: Insights upsell com `.padding()`).
        // `.borderedProminent` — UI tests de pagamento com tap estável.
        Button(action: tapPurchase) {
            Label(Strings.Purchase.continueToPayment, systemImage: "creditcard.fill")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(selectedProductID != nil ? AppDesign.Colors.brand : .gray)
        .accessibilityIdentifier("pro.upgrade.continue.payment")
    }

    private func tapPurchase() {
        let fallbackID: String? = ProcessInfo.processInfo.environment["UITEST_SKIP_SPLASH"] == "1"
            ? SubscriptionCatalog.proMonthlyProductID
            : nil
        guard let productID = selectedProductID ?? fallbackID else {
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
    var badgeColor: Color = AppDesign.Colors.proAccent
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
                                .background(badgeColor)
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
        // IDs curtos: XCTest interpreta "." em reverse-DNS como path e quebra o query.
        .accessibilityIdentifier(PROUpgradeProductOption.accessibilityID(for: product.id))
    }

    /// Chaves estáveis para UI tests (sem product ID StoreKit completo).
    static func accessibilityID(for productID: String) -> String {
        switch productID {
        case SubscriptionCatalog.proMonthlyProductID:
            return "pro.upgrade.product.proMonthly"
        case SubscriptionCatalog.proAnnualProductID:
            return "pro.upgrade.product.proAnnual"
        case SubscriptionCatalog.eliteMonthlyProductID:
            return "pro.upgrade.product.eliteMonthly"
        case SubscriptionCatalog.eliteAnnualProductID:
            return "pro.upgrade.product.eliteAnnual"
        default:
            return "pro.upgrade.product.other"
        }
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
    var onClosePending: () -> Void = {}

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
                        detail: Strings.Purchase.stateConnectingDetail,
                        isAnimating: true
                    )

                case .processing:
                    PROUpgradeProcessingStep(
                        icon: "creditcard",
                        title: Strings.Purchase.stateProcessing,
                        detail: Strings.Purchase.stateProcessingDetail,
                        isAnimating: true
                    )

                case .confirming:
                    PROUpgradeProcessingStep(
                        icon: "checkmark.shield",
                        title: Strings.Purchase.stateConfirming,
                        detail: Strings.Purchase.stateConfirmingDetail,
                        isAnimating: true
                    )

                case .success:
                    PROUpgradeProcessingStep(
                        icon: "checkmark.circle.fill",
                        title: Strings.Purchase.stateSuccess,
                        detail: Strings.Purchase.stateSuccessDetail,
                        isAnimating: false,
                        color: AppDesign.Colors.brand
                    )

                case .pending:
                    PROUpgradePendingStep(onClose: onClosePending)

                case .error(let title, let message):
                    PROUpgradeProcessingError(
                        title: title,
                        message: message,
                        onRetry: onRetry
                    )
                }
            }
            .padding(40)
        }
        .transition(.opacity)
        .accessibilityIdentifier("pro.upgrade.processing.overlay")
    }
}

struct PROUpgradeProcessingStep: View {
    let icon: String
    let title: String
    var detail: String = ""
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
                .multilineTextAlignment(.center)

            if !detail.isEmpty {
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(isAnimating ? "pro.upgrade.state.title" : "pro.upgrade.success.title")
    }
}

struct PROUpgradePendingStep: View {
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "hourglass")
                .font(.system(size: 48))
                .foregroundStyle(AppDesign.Colors.proAccent)

            Text(Strings.Purchase.statePending)
                .font(.headline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text(Strings.Purchase.statePendingDetail)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))
                .multilineTextAlignment(.center)

            Button(Strings.Purchase.close, action: onClose)
                .buttonStyle(.borderedProminent)
                .tint(AppDesign.Colors.brand)
        }
    }
}

struct PROUpgradeProcessingError: View {
    let title: String
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 48))
                .foregroundStyle(AppDesign.Colors.error)

            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)

            Button(Strings.Purchase.retry, action: onRetry)
                .buttonStyle(.borderedProminent)
                .tint(AppDesign.Colors.brand)
                .accessibilityIdentifier("pro.upgrade.error.retry")
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("pro.upgrade.error.title")
    }
}
