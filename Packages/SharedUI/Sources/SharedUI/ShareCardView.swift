import SwiftUI
import UIKit
import Domain
import Localization

/// Modelo para card exportável de PR (CPR-017).
public struct PRShareCardModel: Equatable, Sendable {
    public var exerciseName: String
    public var valueLine: String
    public var date: Date
    public var tier: SubscriptionTier

    public init(exerciseName: String, valueLine: String, date: Date = Date(), tier: SubscriptionTier = .free) {
        self.exerciseName = exerciseName
        self.valueLine = valueLine
        self.date = date
        self.tier = tier
    }

    public init(record: PersonalRecord, tier: SubscriptionTier, preferPounds: Bool) {
        let value: String
        if record.group == .barbell {
            value = preferPounds ? "\(record.poundValue) lb" : "\(record.kiloValue) kg"
        } else if record.group == .gymnastic {
            value = "\(record.maxReps) reps"
        } else {
            value = "\(record.distance) km · \(record.minTime) min"
        }
        self.init(
            exerciseName: record.prName,
            valueLine: value,
            date: record.recordDate,
            tier: tier
        )
    }
}

/// Card visual de PR para ImageRenderer / ShareLink.
public struct ShareCardView: View {
    let model: PRShareCardModel

    public init(model: PRShareCardModel) {
        self.model = model
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(Strings.Share.cardBrand)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppDesign.Colors.brand)
                Spacer()
                tierBadge
            }
            Text(model.exerciseName)
                .font(.title2.bold())
                .foregroundStyle(.primary)
                .lineLimit(2)
            Text(model.valueLine)
                .font(.system(size: 36, weight: .heavy).monospacedDigit())
                .foregroundStyle(AppDesign.Colors.brand)
            Text(model.date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .frame(width: 320, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    AppDesign.Colors.cardBackground,
                    AppDesign.Colors.brand.opacity(0.12),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(AppDesign.Colors.brand.opacity(0.25), lineWidth: 1)
        )
        .accessibilityIdentifier("share.card")
    }

    @ViewBuilder
    private var tierBadge: some View {
        switch model.tier {
        case .elite:
            EliteSealBadge(style: .unlocked, showsLabel: true)
        case .pro:
            Text(Strings.Elite.planPro)
                .font(AppDesign.Typography.proBadge)
                .foregroundStyle(AppDesign.Colors.proAccent)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Capsule().fill(AppDesign.Colors.proAccent.opacity(0.15)))
        case .free:
            EmptyView()
        }
    }
}

/// Botão ShareLink com PNG temporário do card (iOS 16+).
public struct ShareCardShareButton: View {
    let model: PRShareCardModel
    @State private var shareURL: URL?

    public init(model: PRShareCardModel) {
        self.model = model
    }

    public var body: some View {
        Group {
            if let shareURL {
                ShareLink(item: shareURL) {
                    label
                }
            } else {
                Button {
                    render()
                } label: {
                    label
                }
                .onAppear(perform: render)
            }
        }
        .accessibilityIdentifier("share.card.button")
    }

    private var label: some View {
        Label(Strings.Share.action, systemImage: "square.and.arrow.up")
            .font(.subheadline.weight(.semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(AppDesign.Colors.brand)
            .foregroundStyle(.white)
            .cornerRadius(12)
    }

    @MainActor
    private func render() {
        let renderer = ImageRenderer(content: ShareCardView(model: model))
        renderer.scale = 3
        guard let uiImage = renderer.uiImage, let data = uiImage.pngData() else { return }
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("crossfitpr-share-\(UUID().uuidString).png")
        try? data.write(to: url)
        shareURL = url
    }
}
