import SwiftUI
import Domain
import Application
import SharedUI
import Localization

public struct NewPRRecordView: View {
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @EnvironmentObject private var settingsClient: SettingsClient
    @Environment(\.dismiss) private var dismiss

    private let category: WorkoutCategory?

    @State private var selectedLevelIndex = 0
    @State private var percentageText = "80"
    @State private var weightText = "45"
    @State private var maxRepsText = "0"
    @State private var minTimeText = "0"
    @State private var distanceText = "0"
    @State private var comments = ""
    @State private var selectedExerciseIndex = 0
    @State private var isSaving = false
    @State private var saveErrorMessage: String?

    public init(category: WorkoutCategory? = nil) {
        self.category = category
    }

    private var activeCategory: WorkoutCategory {
        category ?? CrossfitCatalog.allCategories[selectedExerciseIndex]
    }

    public var body: some View {
        NavigationStack {
            Form {
                NewPRRecordPRSection(
                    category: category,
                    activeCategoryTitle: activeCategory.localizedTitle,
                    selectedLevelIndex: $selectedLevelIndex,
                    selectedExerciseIndex: $selectedExerciseIndex
                )

                NewPRRecordGroupFields(
                    group: activeCategory.group,
                    measureTrackingMode: settingsClient.measureTrackingMode,
                    percentageText: $percentageText,
                    weightText: $weightText,
                    maxRepsText: $maxRepsText,
                    minTimeText: $minTimeText,
                    distanceText: $distanceText
                )

                Section(Strings.NewPR.sectionComment) {
                    TextField(Strings.NewPR.commentPlaceholder, text: $comments, axis: .vertical)
                        .lineLimit(3...6)
                }

                if let saveErrorMessage {
                    NewPRRecordErrorSection(message: saveErrorMessage)
                }
            }
            .navigationTitle(activeCategory.localizedTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Strings.NewPR.cancel) { dismiss() }
                        .foregroundStyle(AppDesign.Colors.brand)
                        .bold()
                }
            }
            .safeAreaInset(edge: .bottom) {
                NewPRRecordSaveBar(isSaving: isSaving) {
                    Task { await saveRecord() }
                }
            }
        }
        .brandTint()
    }

    private func saveRecord() async {
        isSaving = true
        saveErrorMessage = nil
        defer { isSaving = false }

        let level = CrossfitLevel.allCases[selectedLevelIndex]
        let pounds = Int(weightText) ?? 0
        let record = PersonalRecord(
            prName: activeCategory.title,
            recordDate: Date(),
            kiloValue: settingsClient.measureTrackingMode == .pounds ? Int(Double(pounds) * 0.453592) : pounds,
            poundValue: settingsClient.measureTrackingMode == .pounds ? pounds : Int(Double(pounds) / 0.453592),
            distance: Int(distanceText) ?? 0,
            percentage: Float(percentageText) ?? 10,
            crossfitLevel: level,
            recordMode: activeCategory.type,
            group: activeCategory.group,
            maxReps: Int(maxRepsText) ?? 0,
            minTime: Int(minTimeText) ?? 0,
            comments: comments
        )

        let success = await personalRecordClient.save(record)
        if success {
            dismiss()
        } else {
            saveErrorMessage = personalRecordClient.lastError ?? Strings.NewPR.saveFallbackError
        }
    }
}

// MARK: - Form sections

private struct NewPRRecordPRSection: View {
    let category: WorkoutCategory?
    let activeCategoryTitle: String
    @Binding var selectedLevelIndex: Int
    @Binding var selectedExerciseIndex: Int

    var body: some View {
        Section(Strings.NewPR.sectionPR) {
            CrossfitLevelSegmentView(selectedIndex: $selectedLevelIndex)
            if category == nil {
                Picker(Strings.NewPR.pickerExercise, selection: $selectedExerciseIndex) {
                    ForEach(CrossfitCatalog.allCategories.indices, id: \.self) { index in
                        Text(CrossfitCatalog.allCategories[index].localizedTitle).tag(index)
                    }
                }
            } else {
                Text(activeCategoryTitle)
            }
        }
    }
}

private struct NewPRRecordGroupFields: View {
    let group: RecordGroup
    let measureTrackingMode: MeasureTrackingMode
    @Binding var percentageText: String
    @Binding var weightText: String
    @Binding var maxRepsText: String
    @Binding var minTimeText: String
    @Binding var distanceText: String

    var body: some View {
        switch group {
        case .barbell:
            Section(Strings.NewPR.sectionPercentage) {
                NewPRRecordNumericField(text: $percentageText, suffix: "%")
            }
            Section(Strings.NewPR.sectionWeight) {
                NewPRRecordNumericField(
                    text: $weightText,
                    suffix: measureTrackingMode == .pounds ? " lb" : " kg"
                )
            }
        case .gymnastic:
            Section(Strings.NewPR.sectionMaxReps) {
                NewPRRecordNumericField(text: $maxRepsText, suffix: " reps")
            }
            Section(Strings.NewPR.sectionTime) {
                NewPRRecordNumericField(text: $minTimeText, suffixKey: "newRecord.screen.minutes.description")
            }
        case .endurance:
            Section(Strings.NewPR.sectionDistance) {
                NewPRRecordNumericField(text: $distanceText, suffix: " Km")
            }
            Section(Strings.NewPR.sectionTime) {
                NewPRRecordNumericField(text: $minTimeText, suffixKey: "newRecord.screen.minutes.description")
            }
        }
    }
}

private struct NewPRRecordNumericField: View {
    @Binding var text: String
    var suffix: String = ""
    var suffixKey: String?

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            TextField("0", text: $text)
                .keyboardType(.numberPad)
                .font(AppDesign.Typography.formField)
                .multilineTextAlignment(.center)
                .accentColor(AppDesign.Colors.brand)
            if !text.isEmpty {
                if let suffixKey {
                    Text(Strings.tr(suffixKey))
                        .font(AppDesign.Typography.formField)
                } else {
                    Text(suffix)
                        .font(AppDesign.Typography.formField)
                }
            }
        }
    }
}

private struct NewPRRecordErrorSection: View {
    let message: String

    var body: some View {
        Section {
            Text(message)
                .font(.caption)
                .foregroundStyle(AppDesign.Colors.error)
        }
    }
}

private struct NewPRRecordSaveBar: View {
    let isSaving: Bool
    let onSave: () -> Void

    var body: some View {
        Button(Strings.NewPR.save, action: onSave)
            .buttonStyle(FilledButtonStyle(fullWidth: true))
            .disabled(isSaving)
            .padding()
    }
}
