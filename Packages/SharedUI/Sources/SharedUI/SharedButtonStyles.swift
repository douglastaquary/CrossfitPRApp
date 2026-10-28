import SwiftUI
import Localization

// MARK: - Button Styles (beta baseline)

public struct FilledButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    public var fullWidth: Bool

    public init(fullWidth: Bool = false) {
        self.fullWidth = fullWidth
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding()
            .background(isEnabled ? AppDesign.Colors.brand : .gray)
            .cornerRadius(8)
    }
}

public struct OutlineButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .foregroundColor(configuration.isPressed ? .gray : AppDesign.Colors.brand)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(AppDesign.Colors.brand.opacity(0.15))
            )
    }
}

public struct CardFilledButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    public var fullWidth: Bool

    public init(fullWidth: Bool = false) {
        self.fullWidth = fullWidth
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding()
            .background(isEnabled ? AppDesign.Colors.cardButton : .gray)
            .cornerRadius(8)
    }
}
