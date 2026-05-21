import SwiftUI
import Domain
import Application
import Localization

public struct NewPRRecordView: View {
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @Environment(\.dismiss) private var dismiss

    @State private var selectedExerciseIndex = 0
    @State private var pounds: Double = 45
    @State private var date = Date.now
    @State private var isSaving = false
    @State private var saveErrorMessage: String?

    private var selectedExercise: Exercise {
        CrossfitCatalog.selectableExercises[selectedExerciseIndex]
    }

    public init() {}

    public var body: some View {
        NavigationStack {
            Form {
                Section(Strings.NewPR.sectionExercise) {
                    Picker(Strings.NewPR.pickerExercise, selection: $selectedExerciseIndex) {
                        ForEach(CrossfitCatalog.selectableExercises.indices, id: \.self) { index in
                            Text(CrossfitCatalog.selectableExercises[index].kind.localizedName)
                                .tag(index)
                        }
                    }
                }

                Section(Strings.NewPR.sectionPR) {
                    Stepper(value: $pounds, in: 0...999, step: 5) {
                        Text(Strings.NewPR.weight(Int(pounds)))
                    }
                    DatePicker(Strings.NewPR.dateLabel, selection: $date, displayedComponents: .date)
                }

                if let saveErrorMessage {
                    Section {
                        Text(saveErrorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(Strings.NewPR.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Strings.NewPR.cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(Strings.NewPR.save) {
                        Task { await saveRecord() }
                    }
                    .disabled(isSaving)
                }
            }
        }
    }

    private func saveRecord() async {
        isSaving = true
        saveErrorMessage = nil
        defer { isSaving = false }

        let record = PersonalRecord(
            exercise: selectedExercise,
            date: date,
            pounds: pounds,
            goalDuration: 0
        )

        let success = await personalRecordClient.save(record)
        if success {
            dismiss()
        } else {
            saveErrorMessage = personalRecordClient.lastError ?? Strings.NewPR.saveFallbackError
        }
    }
}
