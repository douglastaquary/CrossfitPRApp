import SwiftUI
import Domain
import Localization

public struct RankingCardView: View {
    let record: PersonalRecord
    let measureMode: MeasureTrackingMode
    let accentColor: Color

    public init(
        record: PersonalRecord,
        measureMode: MeasureTrackingMode,
        accentColor: Color = AppDesign.Colors.brand
    ) {
        self.record = record
        self.measureMode = measureMode
        self.accentColor = accentColor
    }

    private var market: (text: String, numeric: Double) {
        InsightsRanking.marketValue(for: record, measureMode: measureMode)
    }

    public var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(accentColor)
                .frame(width: 168, height: 96)
                .overlay {
                    VStack(alignment: .leading) {
                        Text(record.prName)
                            .foregroundStyle(.white)
                            .font(.headline)
                            .padding(.top, 6)

                        HStack {
                            Image(systemName: "dumbbell")
                                .foregroundStyle(.white)
                                .frame(width: 16, height: 16)
                            Text(market.text)
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                            Spacer()
                            if record.evolutionPercentage > 0 {
                                Image(systemName: "arrow.up.forward")
                                    .foregroundStyle(.white)
                                Text("\(record.evolutionPercentage)%")
                                    .foregroundStyle(.white)
                            }
                        }

                        GeometryReader { bounds in
                            Capsule(style: .circular)
                                .fill(.white.opacity(0.3))
                                .overlay(alignment: .leading) {
                                    Capsule(style: .circular)
                                        .fill(.white)
                                        .frame(width: bounds.size.width * progressWidth)
                                }
                                .clipShape(Capsule(style: .circular))
                        }
                        .frame(height: 15)
                    }
                    .padding([.leading, .trailing, .bottom], 10)
                }
        }
    }

    private var progressWidth: CGFloat {
        CGFloat(min(max(market.numeric / 100.0, 0.05), 1.0))
    }
}

public enum RankingAccent {
    public static func color(for index: Int) -> Color {
        switch index {
        case 0: return AppDesign.Colors.brand
        case 1: return AppDesign.Colors.proAccent
        default: return AppDesign.Colors.metadataChip
        }
    }
}
