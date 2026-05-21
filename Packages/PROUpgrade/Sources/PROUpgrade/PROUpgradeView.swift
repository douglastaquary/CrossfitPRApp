import SwiftUI
import Domain
import Subscription
import Localization

public struct PROUpgradeView: View {
    @EnvironmentObject private var subscriptionClient: SubscriptionClient
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false
    @State private var errorMessage: String?

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(Strings.PRO.productName)
                            .font(.title2.bold())
                        Text(Strings.PRO.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                }

                Section(Strings.PRO.sectionBenefits) {
                    ForEach(ProFeature.allCases.filter { !$0.isAvailableInFreeTier }, id: \.self) { feature in
                        Label(feature.localizedMarketingTitle, systemImage: "checkmark.seal.fill")
                    }
                }

                Section {
                    Button {
                        Task { await purchase() }
                    } label: {
                        HStack {
                            Spacer()
                            if isPurchasing {
                                ProgressView()
                            } else {
                                Text(Strings.PRO.unlockButton)
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                    }
                    .disabled(isPurchasing)
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle(Strings.PRO.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Strings.PRO.close) { dismiss() }
                }
            }
        }
    }

    private func purchase() async {
        isPurchasing = true
        errorMessage = nil
        defer { isPurchasing = false }

        do {
            try await subscriptionClient.purchasePro()
            dismiss()
        } catch let error as SubscriptionError {
            let message = error.localizedMessage
            if !message.isEmpty {
                errorMessage = message
            }
        } catch {
            errorMessage = Strings.PRO.purchaseFallbackError
        }
    }
}
