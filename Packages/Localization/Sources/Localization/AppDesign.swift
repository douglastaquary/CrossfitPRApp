import SwiftUI

/// Tokens visuais do baseline beta CrossfitPR (fix-for-beta-version).
/// Alterações exigem canvas SPDD + skill design.
public enum AppDesign {
    public enum Colors {
        /// Verde de marca — accent global, tabs, CTAs (.green beta).
        public static let brand = Color.green

        /// Badge PRO e destaques premium.
        public static let proAccent = Color.orange

        /// Mensagens de erro inline.
        public static let error = Color.red

        /// Roxo — chips de peso (RecordDetail).
        public static let weightChip = Color.purple

        /// Cinza — metadados de data.
        public static let metadataChip = Color.gray

        /// Fundo adaptativo (beta Extensions.swift).
        public static let background = Color(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 50 / 255, green: 50 / 255, blue: 54 / 255, alpha: 1)
                : UIColor(red: 239 / 255, green: 239 / 255, blue: 240 / 255, alpha: 1)
        })

        /// Botão card escuro (#151E27).
        public static let cardButton = Color(red: 0.082, green: 0.118, blue: 0.153)

        /// Fundo de cards/seções.
        public static let cardBackground = Color(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor.secondarySystemBackground
                : UIColor.systemBackground
        })
    }

    public enum Icon {
        public static let tabCategories = "square.grid.3x3"
        public static let tabRecords = "trophy.circle.fill"
        public static let tabInsights = "chart.xyaxis.line"
        public static let tabSettings = "gear"
        public static let onboardingHero = "figure.strengthtraining.traditional"
        public static let emptyPRs = "figure.strengthtraining.traditional"
        public static let emptyInsights = "chart.xyaxis.line"
        public static let error = "exclamationmark.triangle"
        public static let proBenefit = "checkmark.seal.fill"
        // Legacy aliases
        public static let tabPRs = tabRecords
    }

    public enum Typography {
        public static let screenTitle = Font.system(size: 36, weight: .heavy)
        public static let sectionTitle = Font.title2.bold()
        public static let rowTitle = Font.title2.weight(.semibold)
        public static let rowSubtitle = Font.caption
        public static let rowValue = Font.subheadline.monospacedDigit()
        public static let bodySecondary = Font.subheadline
        public static let captionSecondary = Font.caption
        public static let proBadge = Font.caption2.bold()
        public static let formField = Font.system(size: 18, weight: .medium)
    }

    public enum Layout {
        public static let onboardingHeroSize: CGFloat = 64
        public static let emptyStateIconSize: CGFloat = 48
        public static let onboardingSpacing: CGFloat = 24
        public static let insightRowSpacing: CGFloat = 8
        public static let proBadgeHorizontalPadding: CGFloat = 6
        public static let proBadgeVerticalPadding: CGFloat = 2
        public static let horizontalPadding: CGFloat = 16
        public static let listLeadingPadding: CGFloat = 22
        public static let onboardingItemWidth: CGFloat = 348
        public static let onboardingItemHeight: CGFloat = 100
        public static let chartHeight: CGFloat = 250
    }
}

public extension View {
    /// Accent de marca aplicado a botões prominentes e TabView.
    func brandTint() -> some View {
        tint(AppDesign.Colors.brand)
    }

    func endEditingOnTap() -> some View {
        onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
    }
}
