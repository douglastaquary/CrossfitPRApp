import SwiftUI
import Localization

/// Selo Elite discreto (CPR-008 Design) — só em superfícies Elite-only / teaser.
public struct EliteSealBadge: View {
    public enum Style {
        /// Conteúdo desbloqueado (assessment, limiting, award Elite).
        case unlocked
        /// Teaser PRO — medalha outlined, sem rótulo “Elite” ativo.
        case lockedHint
    }

    private let style: Style
    private let showsLabel: Bool

    public init(style: Style = .unlocked, showsLabel: Bool = true) {
        self.style = style
        self.showsLabel = showsLabel
    }

    public var body: some View {
        HStack(spacing: 4) {
            Image(systemName: iconName)
                .font(.caption2.weight(.semibold))
            if showsLabel, style == .unlocked {
                Text(Strings.Elite.badge)
                    .font(AppDesign.Typography.proBadge)
            }
        }
        .foregroundStyle(AppDesign.Colors.eliteAccent)
        .padding(.horizontal, style == .unlocked && showsLabel ? 6 : 0)
        .padding(.vertical, style == .unlocked && showsLabel ? 2 : 0)
        .background {
            if style == .unlocked, showsLabel {
                Capsule()
                    .fill(AppDesign.Colors.eliteAccent.opacity(0.14))
            }
        }
        .accessibilityLabel(Strings.Elite.badge)
        .accessibilityIdentifier(style == .unlocked ? "elite.seal.unlocked" : "elite.seal.lockedHint")
    }

    private var iconName: String {
        switch style {
        case .unlocked:
            return AppDesign.Icon.eliteBadge
        case .lockedHint:
            return "medal"
        }
    }
}
