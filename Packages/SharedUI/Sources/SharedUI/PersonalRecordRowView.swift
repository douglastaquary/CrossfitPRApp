import SwiftUI
import Domain
import Localization

public struct PersonalRecordRowView: View {
    let record: PersonalRecord
    let isPounds: Bool

    public init(record: PersonalRecord, isPounds: Bool) {
        self.record = record
        self.isPounds = isPounds
    }

    public var body: some View {
        VStack {
            HStack {
                Text(record.prName.localizedWorkoutTitle)
                    .bold()
                Spacer()
            }
            .frame(height: 42)

            HStack(spacing: 12) {
                PersonalRecordRowMetricChips(record: record, isPounds: isPounds)
                RecordImageInformationView(
                    imageSystemName: "calendar",
                    title: record.formattedShortDate,
                    foregroundColor: AppDesign.Colors.metadataChip
                )
                Spacer()
            }
        }
        .padding(.leading, 12)
    }
}

struct PersonalRecordRowMetricChips: View {
    let record: PersonalRecord
    let isPounds: Bool

    var body: some View {
        Group {
            switch record.group {
            case .barbell:
                RecordImageInformationView(
                    imageSystemName: "bolt.fill",
                    title: isPounds ? "\(record.poundValue) lb" : "\(record.kiloValue) kg",
                    foregroundColor: AppDesign.Colors.weightChip
                )
                RecordImageInformationView(
                    imageSystemName: "chart.bar.fill",
                    title: "\(Int(record.percentage))%",
                    foregroundColor: AppDesign.Colors.proAccent
                )
            case .endurance:
                RecordImageInformationView(
                    imageSystemName: "point.filled.topleft.down.curvedto.point.bottomright.up",
                    title: "\(record.distance) km",
                    foregroundColor: AppDesign.Colors.weightChip
                )
                RecordImageInformationView(
                    imageSystemName: "timer",
                    title: "\(record.minTime) min",
                    foregroundColor: AppDesign.Colors.proAccent
                )
            case .gymnastic:
                RecordImageInformationView(
                    imageSystemName: "flame",
                    title: "\(record.maxReps) reps",
                    foregroundColor: AppDesign.Colors.weightChip
                )
                RecordImageInformationView(
                    imageSystemName: "timer",
                    title: "\(record.minTime) min",
                    foregroundColor: AppDesign.Colors.proAccent
                )
            }
        }
    }
}

public struct RecordImageInformationView: View {
    let imageSystemName: String
    let title: String
    let foregroundColor: Color

    public init(imageSystemName: String, title: String, foregroundColor: Color = AppDesign.Colors.brand) {
        self.imageSystemName = imageSystemName
        self.title = title
        self.foregroundColor = foregroundColor
    }

    public var body: some View {
        HStack {
            Image(systemName: imageSystemName)
                .foregroundStyle(foregroundColor)
            Text(title)
                .font(.callout)
                .foregroundStyle(foregroundColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(foregroundColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
