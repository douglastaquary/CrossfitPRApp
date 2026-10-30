import SwiftUI
import Domain
import Subscription
import SharedUI
import Localization

// MARK: - CPR-014 — 3 layouts de conversão (sheet com respiro)

extension PROUpgradePurchaseContent {
    @ViewBuilder
    var conversionBody: some View {
        switch PROUpgradeLayoutVariant.current {
        case .a:
            variantA
        case .b:
            variantB
        case .c:
            variantC
        }
    }

    // MARK: A — Hero + 2 cards (só anuais à vista)

    private var variantA: some View {
        VStack(spacing: 32) {
            paywallHero(
                badge: nil,
                title: Strings.PRO.title,
                subtitle: Strings.PRO.subtitle
            )

            VStack(spacing: 16) {
                planPickCard(
                    title: Strings.Elite.planPro,
                    subtitle: annualProduct?.displayPrice ?? "—",
                    detail: Strings.Purchase.annualPlan,
                    accent: AppDesign.Colors.proAccent,
                    productID: annualProduct?.id ?? SubscriptionCatalog.proAnnualProductID,
                    isSelected: isSelected(annualProduct?.id ?? SubscriptionCatalog.proAnnualProductID)
                )

                planPickCard(
                    title: Strings.Elite.planElite,
                    subtitle: eliteAnnualProduct?.displayPrice ?? "—",
                    detail: Strings.Elite.annualPlan,
                    accent: AppDesign.Colors.eliteAccent,
                    productID: eliteAnnualProduct?.id ?? SubscriptionCatalog.eliteAnnualProductID,
                    isSelected: isSelected(eliteAnnualProduct?.id ?? SubscriptionCatalog.eliteAnnualProductID)
                )
            }

            shortBenefits(points: [
                Strings.tr("purchase.item1.title"),
                Strings.tr("purchase.item2.title"),
                Strings.Elite.benefitAssessment,
            ])

            purchaseFooter
            monthlyLinks
            errorBanner
            legalFooter
            hiddenProductAnchors
        }
        .padding(.horizontal, 28)
        .padding(.top, 12)
        .padding(.bottom, 40)
    }

    // MARK: B — Passos (plano → período → CTA)

    private var variantB: some View {
        VStack(spacing: 36) {
            paywallHero(
                badge: Strings.Elite.competitorMode,
                title: Strings.Elite.title,
                subtitle: Strings.Elite.subtitle
            )

            VStack(spacing: 22) {
                VStack(alignment: .leading, spacing: 12) {
                    stepLabel("1 · \(Strings.PRO.Upgrade.choosePlan)")
                    HStack(spacing: 12) {
                        tierChip(
                            title: Strings.Elite.planPro,
                            selected: selectedTier == .pro,
                            accent: AppDesign.Colors.proAccent
                        ) {
                            selectedTier = .pro
                            syncSelectionFromPickers()
                        }
                        tierChip(
                            title: Strings.Elite.planElite,
                            selected: selectedTier == .elite,
                            accent: AppDesign.Colors.eliteAccent
                        ) {
                            selectedTier = .elite
                            syncSelectionFromPickers()
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    stepLabel("2 · \(Strings.Purchase.annualPlan) / \(Strings.Purchase.monthlyPlan)")
                    HStack(spacing: 12) {
                        tierChip(
                            title: Strings.Purchase.monthlyPlan,
                            selected: selectedPeriod == .monthly,
                            accent: AppDesign.Colors.brand
                        ) {
                            selectedPeriod = .monthly
                            syncSelectionFromPickers()
                        }
                        tierChip(
                            title: Strings.Purchase.annualPlan,
                            selected: selectedPeriod == .annual,
                            accent: AppDesign.Colors.brand
                        ) {
                            selectedPeriod = .annual
                            syncSelectionFromPickers()
                        }
                    }
                }

                if let price = selectedProductPrice {
                    Text(price)
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)
                }
            }

            purchaseFooter
            errorBanner
            legalFooter
            hiddenProductAnchors
        }
        .padding(.horizontal, 28)
        .padding(.top, 12)
        .padding(.bottom, 40)
        .onAppear { syncSelectionFromPickers() }
    }

    // MARK: C — Compare leve + 2 CTAs de preço

    private var variantC: some View {
        VStack(spacing: 32) {
            paywallHero(
                badge: nil,
                title: Strings.Elite.title,
                subtitle: Strings.PRO.subtitle
            )

            lightCompareRow

            VStack(spacing: 14) {
                planPickCard(
                    title: Strings.Elite.planPro,
                    subtitle: annualProduct?.displayPrice ?? "—",
                    detail: Strings.Purchase.bestValueBadge,
                    accent: AppDesign.Colors.proAccent,
                    productID: annualProduct?.id ?? SubscriptionCatalog.proAnnualProductID,
                    isSelected: isSelected(annualProduct?.id ?? SubscriptionCatalog.proAnnualProductID)
                )
                planPickCard(
                    title: Strings.Elite.planElite,
                    subtitle: eliteAnnualProduct?.displayPrice ?? "—",
                    detail: Strings.Elite.badge,
                    accent: AppDesign.Colors.eliteAccent,
                    productID: eliteAnnualProduct?.id ?? SubscriptionCatalog.eliteAnnualProductID,
                    isSelected: isSelected(eliteAnnualProduct?.id ?? SubscriptionCatalog.eliteAnnualProductID)
                )
            }

            purchaseFooter
            monthlyLinks
            errorBanner
            legalFooter
            hiddenProductAnchors
        }
        .padding(.horizontal, 28)
        .padding(.top, 12)
        .padding(.bottom, 40)
    }

    // MARK: Shared

    private func paywallHero(badge: String?, title: String, subtitle: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: AppDesign.Icon.eliteBadge)
                .font(.system(size: 44))
                .foregroundStyle(AppDesign.Colors.brand)
                .padding(.top, 8)

            if let badge {
                Text(badge)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppDesign.Colors.eliteAccent)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppDesign.Colors.eliteAccent.opacity(0.12))
                    .clipShape(Capsule())
            }

            Text(title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity)
    }

    private func shortBenefits(points: [String]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(points, id: \.self) { point in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(AppDesign.Colors.brand)
                    Text(point)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                }
            }
        }
    }

    private func planPickCard(
        title: String,
        subtitle: String,
        detail: String,
        accent: Color,
        productID: String,
        isSelected: Bool
    ) -> some View {
        Button {
            selectProduct(productID)
        } label: {
            HStack(alignment: .center, spacing: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(accent)
                    Text(subtitle)
                        .font(.title3.bold())
                        .foregroundStyle(.primary)
                    Text(detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? AppDesign.Colors.brand : .secondary)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(accent.opacity(isSelected ? 0.12 : 0.06))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? accent : accent.opacity(0.25), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(PROUpgradeProductOption.accessibilityID(for: productID))
    }

    private var lightCompareRow: some View {
        HStack(alignment: .top, spacing: 10) {
            compareChip(title: Strings.Elite.planFree, accent: AppDesign.Colors.metadataChip, lines: ["PRs", "Teaser"])
            compareChip(title: Strings.Elite.planPro, accent: AppDesign.Colors.proAccent, lines: ["Coach", "Engine"])
            compareChip(title: Strings.Elite.planElite, accent: AppDesign.Colors.eliteAccent, lines: ["Assessment", "Limiting"])
        }
    }

    private func compareChip(title: String, accent: Color, lines: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(accent)
            ForEach(lines, id: \.self) { line in
                HStack(spacing: 4) {
                    Image(systemName: "checkmark")
                        .font(.caption2.bold())
                        .foregroundStyle(accent)
                    Text(line)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(AppDesign.Colors.cardBackground)
        .cornerRadius(14)
    }

    private func stepLabel(_ text: String) -> some View {
        Text(text)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
    }

    private func tierChip(
        title: String,
        selected: Bool,
        accent: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(selected ? accent.opacity(0.18) : AppDesign.Colors.cardBackground)
                .foregroundStyle(selected ? accent : .primary)
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(selected ? accent : Color.secondary.opacity(0.2), lineWidth: selected ? 2 : 1)
                )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var purchaseFooter: some View {
        if hasProducts {
            PROUpgradeTrialButton(
                selectedProductID: selectedProductID,
                errorMessage: $errorMessage,
                onPurchase: onPurchase
            )
            PROUpgradeRestoreSection(onRestore: onRestore)
        } else {
            PROUpgradeNoProductsSection(onReload: onReloadProducts)
            PROUpgradeRestoreSection(onRestore: onRestore)
        }
    }

    private var monthlyLinks: some View {
        HStack(spacing: 16) {
            if let monthly = monthlyProduct {
                Button(Strings.Purchase.monthlyPlan + " PRO") {
                    selectProduct(monthly.id)
                }
                .font(.caption.weight(.semibold))
            }
            if let eliteMonthly = eliteMonthlyProduct {
                Button(Strings.Purchase.monthlyPlan + " Elite") {
                    selectProduct(eliteMonthly.id)
                }
                .font(.caption.weight(.semibold))
            }
        }
        .foregroundStyle(.secondary)
    }

    private var hiddenProductAnchors: some View {
        // IDs não cobertos pelos cards visíveis (UI tests de pagamento).
        let visible: Set<String> = {
            switch PROUpgradeLayoutVariant.current {
            case .a, .c:
                return Set([
                    annualProduct?.id ?? SubscriptionCatalog.proAnnualProductID,
                    eliteAnnualProduct?.id ?? SubscriptionCatalog.eliteAnnualProductID,
                ].compactMap { $0 })
            case .b:
                return []
            }
        }()
        let hidden = allProductIDs.filter { !visible.contains($0) }
        return VStack(spacing: 0) {
            ForEach(hidden, id: \.self) { productID in
                Button(action: { selectProduct(productID) }) {
                    Color.clear.frame(width: 1, height: 1)
                }
                .accessibilityIdentifier(PROUpgradeProductOption.accessibilityID(for: productID))
            }
        }
        .frame(height: 1)
        .opacity(0.02)
    }

    @ViewBuilder
    private var errorBanner: some View {
        if let errorMessage {
            Text(errorMessage)
                .font(.caption)
                .foregroundStyle(AppDesign.Colors.error)
                .multilineTextAlignment(.center)
        }
    }

    private var legalFooter: some View {
        Text(Strings.Purchase.renewNote)
            .font(.caption2)
            .foregroundStyle(.tertiary)
            .multilineTextAlignment(.center)
            .padding(.top, 8)
    }

    private func isSelected(_ id: String) -> Bool {
        selectedProductID == id
    }

    private func selectProduct(_ id: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedProductID = id
            errorMessage = nil
            if id == SubscriptionCatalog.eliteMonthlyProductID
                || id == SubscriptionCatalog.eliteAnnualProductID {
                selectedTier = .elite
            } else {
                selectedTier = .pro
            }
            if id == SubscriptionCatalog.proAnnualProductID
                || id == SubscriptionCatalog.eliteAnnualProductID {
                selectedPeriod = .annual
            } else {
                selectedPeriod = .monthly
            }
        }
    }

    private func syncSelectionFromPickers() {
        let id: String?
        switch (selectedTier, selectedPeriod) {
        case (.pro, .monthly):
            id = monthlyProduct?.id ?? SubscriptionCatalog.proMonthlyProductID
        case (.pro, .annual):
            id = annualProduct?.id ?? SubscriptionCatalog.proAnnualProductID
        case (.elite, .monthly):
            id = eliteMonthlyProduct?.id ?? SubscriptionCatalog.eliteMonthlyProductID
        case (.elite, .annual):
            id = eliteAnnualProduct?.id ?? SubscriptionCatalog.eliteAnnualProductID
        }
        selectedProductID = id
        errorMessage = nil
    }

    private var selectedProductPrice: String? {
        guard let id = selectedProductID else { return nil }
        return [monthlyProduct, annualProduct, eliteMonthlyProduct, eliteAnnualProduct]
            .compactMap { $0 }
            .first { $0.id == id }?
            .displayPrice
    }

    private var allProductIDs: [String] {
        [
            SubscriptionCatalog.proMonthlyProductID,
            SubscriptionCatalog.proAnnualProductID,
            SubscriptionCatalog.eliteMonthlyProductID,
            SubscriptionCatalog.eliteAnnualProductID,
        ]
    }
}
