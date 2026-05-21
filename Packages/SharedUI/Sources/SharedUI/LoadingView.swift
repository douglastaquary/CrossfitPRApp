import SwiftUI
import Localization

public struct LoadingView: View {
    let messageKey: String?

    public init(messageKey: String? = nil) {
        self.messageKey = messageKey
    }

    public var body: some View {
        VStack(spacing: 16) {
            ProgressView()
            if let messageKey {
                Text(Strings.tr(messageKey))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
