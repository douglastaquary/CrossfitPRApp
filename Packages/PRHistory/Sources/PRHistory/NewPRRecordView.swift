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
                Section(Strings.NewPR.sectionPR) {
                    CrossfitLevelSegmentView(selectedIndex: $selectedLevelIndex)
                    if category == nil {
                        Picker(Strings.NewPR.pickerExercise, selection: $selectedExerciseIndex) {
                            ForEach(CrossfitCatalog.allCategories.indices, id: \.self) { index in
                                Text(CrossfitCatalog.allCategories[index].title).tag(index)
                            }
                        }
                    } else {
                        Text(activeCategory.title)
                    }
                }

                groupFields

                Section(Strings.NewPR.sectionComment) {
                    TextField(Strings.NewPR.commentPlaceholder, text: $comments, axis: .vertical)
                        .lineLimit(3...6)
                }

                if let saveErrorMessage {
                    Section {
                        Text(saveErrorMessage)
                            .font(.caption)
                            .foregroundStyle(AppDesign.Colors.error)
                    }
                }
            }
            .navigationTitle(activeCategory.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Strings.NewPR.cancel) { dismiss() }
                        .foregroundStyle(AppDesign.Colors.brand)
                        .bold()
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button(Strings.NewPR.save) {
                    Task { await saveRecord() }
                }
                .buttonStyle(FilledButtonStyle(fullWidth: true))
                .disabled(isSaving)
                .padding()
            }
        }
        .brandTint()
    }

    @ViewBuilder
    private var groupFields: some View {
        switch activeCategory.group {
        case .barbell:
            Section(Strings.NewPR.sectionPercentage) {
                numericField(text: $percentageText, suffix: "%")
            }
            Section(Strings.NewPR.sectionWeight) {
                numericField(
                    text: $weightText,
                    suffix: settingsClient.measureTrackingMode == .pounds ? " lb" : " kg"
                )
            }
        case .gymnastic:
            Section(Strings.NewPR.sectionMaxReps) {
                numericField(text: $maxRepsText, suffix: " reps")
            }
            Section(Strings.NewPR.sectionTime) {
                numericField(text: $minTimeText, suffixKey: "newRecord.screen.minutes.description")
            }
        case .endurance:
            Section(Strings.NewPR.sectionDistance) {
                numericField(text: $distanceText, suffix: " Km")
            }
            Section(Strings.NewPR.sectionTime) {
                numericField(text: $minTimeText, suffixKey: "newRecord.screen.minutes.description")
            }
        }
    }

    private func numericField(text: Binding<String>, suffix: String = "", suffixKey: String? = nil) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            TextField("0", text: text)
                .keyboardType(.numberPad)
                .font(AppDesign.Typography.formField)
                .multilineTextAlignment(.center)
                .accentColor(AppDesign.Colors.brand)
            if !text.wrappedValue.isEmpty {
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
