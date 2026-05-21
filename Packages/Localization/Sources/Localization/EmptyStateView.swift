import SwiftUI

/// Estado vazio/erro — aparência equivalente a `ContentUnavailableView` (baseline CPR-001, iOS 16+).
public struct EmptyStateView: View {
    private let title: String
    private let systemImage: String
    private let message: String
    private let actionTitle: String?
    private let action: (() -> Void)?

    public init(
        title: String,
        systemImage: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.systemImage = systemImage
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        ContentUnavailableLayout(
            title: title,
            systemImage: systemImage,
            message: message,
            actionTitle: actionTitle,
            action: action
        )
    }
}

/// Layout compartilhado — espelha `ContentUnavailableView` do iOS 17.
struct ContentUnavailableLayout: View {
    let title: String
    let systemImage: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: AppDesign.Layout.emptyStateIconSize))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.secondary)

                Text(title)
                    .font(.title2)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
                    .brandTint()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
