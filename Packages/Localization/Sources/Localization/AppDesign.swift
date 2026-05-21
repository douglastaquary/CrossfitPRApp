import SwiftUI

/// Tokens visuais congelados do baseline CrossfitPR (CPR-001).
/// Alterações exigem canvas SPDD + skill design.
public enum AppDesign {
    public enum Colors {
        /// Verde de marca — onboarding, CTA, accent global (#34C759).
        public static let brand = Color(red: 0.204, green: 0.780, blue: 0.349)

        /// Badge PRO e destaques premium (#FF9500 @ 20% opacidade no fundo).
        public static let proAccent = Color.orange

        /// Mensagens de erro inline.
        public static let error = Color.red
    }

    public enum Icon {
        public static let onboardingHero = "figure.strengthtraining.traditional"
        public static let tabPRs = "list.bullet"
        public static let tabInsights = "chart.line.uptrend.xyaxis"
        public static let emptyPRs = "figure.strengthtraining.traditional"
        public static let emptyInsights = "chart.line.uptrend.xyaxis"
        public static let error = "exclamationmark.triangle"
        public static let proBenefit = "checkmark.seal.fill"
    }

    public enum Typography {
        public static let screenTitle = Font.title.bold()
        public static let sectionTitle = Font.title2.bold()
        public static let rowTitle = Font.headline
        public static let rowSubtitle = Font.caption
        public static let rowValue = Font.subheadline.monospacedDigit()
        public static let bodySecondary = Font.subheadline
        public static let captionSecondary = Font.caption
        public static let proBadge = Font.caption2.bold()
    }

    public enum Layout {
        public static let onboardingHeroSize: CGFloat = 64
        public static let emptyStateIconSize: CGFloat = 48
        public static let onboardingSpacing: CGFloat = 24
        public static let insightRowSpacing: CGFloat = 8
        public static let proBadgeHorizontalPadding: CGFloat = 6
        public static let proBadgeVerticalPadding: CGFloat = 2
    }
}

public extension View {
    /// Accent de marca aplicado a botões prominentes e TabView.
    func brandTint() -> some View {
        tint(AppDesign.Colors.brand)
    }
}
