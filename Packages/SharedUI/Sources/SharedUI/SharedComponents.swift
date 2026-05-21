import SwiftUI
import Domain
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

// MARK: - Shared Components

public struct HViewImageAndText: View {
    let image: String
    let imageColor: Color
    let title: String
    let description: String

    public init(image: String, imageColor: Color, title: String, description: String) {
        self.image = image
        self.imageColor = imageColor
        self.title = title
        self.description = description
    }

    public var body: some View {
        HStack(alignment: .center) {
            HStack {
                Image(systemName: image)
                    .font(.system(size: 24))
                    .foregroundColor(imageColor)
                    .padding()

                VStack(alignment: .leading, spacing: 8) {
                    Text(Strings.tr(title))
                    Text(Strings.tr(description))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: AppDesign.Layout.onboardingItemWidth, height: AppDesign.Layout.onboardingItemHeight)
        }
    }
}

public struct CategoryItemView: View {
    let title: String
    let groupKey: String

    public init(title: String, groupKey: String) {
        self.title = title
        self.groupKey = groupKey
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(AppDesign.Typography.rowTitle)
                .foregroundStyle(.primary)
                .padding(.top, 8)
                .padding(.leading, AppDesign.Layout.listLeadingPadding)
            Text(Strings.tr(groupKey))
                .font(AppDesign.Typography.rowSubtitle)
                .foregroundStyle(.secondary)
                .padding(.leading, AppDesign.Layout.listLeadingPadding)
            Divider()
        }
    }
}

public struct PlainGroupBoxStyle: GroupBoxStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
    }
}

public struct CardGroupView: View {
    let cardTitle: String
    let cardDescription: String
    let buttonTitle: String
    let iconSystemName: String

    public init(
        cardTitle: String,
        cardDescription: String,
        buttonTitle: String,
        iconSystemName: String
    ) {
        self.cardTitle = cardTitle
        self.cardDescription = cardDescription
        self.buttonTitle = buttonTitle
        self.iconSystemName = iconSystemName
    }

    public var body: some View {
        GroupBox(
            label: Label(Strings.tr(cardTitle), systemImage: iconSystemName)
                .foregroundStyle(AppDesign.Colors.brand)
        ) {
            VStack {
                HStack {
                    Text(Strings.tr(cardDescription))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 2)
                        .foregroundStyle(.primary)
                    Spacer()
                }
                HStack {
                    Text(Strings.tr(buttonTitle))
                        .foregroundStyle(AppDesign.Colors.brand)
                    Spacer()
                }
                .padding(.top, 2)
            }
        }
        .groupBoxStyle(PlainGroupBoxStyle())
    }
}

public struct HSubtitleView: View {
    let imageSystemName: String?
    let titleKey: String
    let subtitle: String
    let foregroundColor: Color

    public init(
        imageSystemName: String? = nil,
        titleKey: String,
        subtitle: String,
        foregroundColor: Color = AppDesign.Colors.brand
    ) {
        self.imageSystemName = imageSystemName
        self.titleKey = titleKey
        self.subtitle = subtitle
        self.foregroundColor = foregroundColor
    }

    public var body: some View {
        HStack {
            if let imageSystemName {
                Image(systemName: imageSystemName)
                    .foregroundStyle(foregroundColor)
            }
            VStack(alignment: .leading) {
                Text(Strings.tr(titleKey))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(subtitle)
                    .font(.body.weight(.semibold))
            }
            Spacer()
        }
        .padding(.vertical, 4)
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
                Text(record.prName)
                    .bold()
                Spacer()
            }
            .frame(height: 42)

            HStack(spacing: 12) {
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

public struct CategorySegmentView: View {
    let items: [String]
    @Binding var selectedIndex: Int

    public init(items: [String], selectedIndex: Binding<Int>) {
        self.items = items
        _selectedIndex = selectedIndex
    }

    public var body: some View {
        Picker("", selection: $selectedIndex) {
            ForEach(items.indices, id: \.self) { index in
                Text(items[index]).tag(index)
            }
        }
        .pickerStyle(.segmented)
    }
}

public struct CrossfitLevelSegmentView: View {
    @Binding var selectedIndex: Int

    public init(selectedIndex: Binding<Int>) {
        _selectedIndex = selectedIndex
    }

    private let levels = CrossfitLevel.allCases.map(\.rawValue)

    public var body: some View {
        Picker("", selection: $selectedIndex) {
            ForEach(levels.indices, id: \.self) { index in
                Text(levels[index]).tag(index)
            }
        }
        .pickerStyle(.segmented)
    }
}

public struct RingProgressView: View {
    let progress: Float

    public init(progress: Float) {
        self.progress = progress
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.2)
                .foregroundStyle(AppDesign.Colors.brand)
            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1)))
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .foregroundStyle(AppDesign.Colors.brand)
                .rotationEffect(.degrees(-90))
            Text("\(Int(progress * 100))%")
                .font(.caption.bold())
        }
        .frame(width: 56, height: 56)
    }
}
