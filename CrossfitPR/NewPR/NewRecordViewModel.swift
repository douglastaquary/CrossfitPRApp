//
//  NewPRViewModel.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import Foundation
import Combine
import os

@MainActor final class NewRecordViewModel: ObservableObject {
    private static let logger = Logger(
        subsystem: "com.douglast.mycrossfitpr",
        category: String(describing: NewRecordViewModel.self)
    )
    
    let crossfitLevelList = CrossfitLevel.allCases.map { $0.rawValue }
    let personalRecordTypeList = Category.list.sorted()
    var anyCancellable: AnyCancellable? = nil
    private let handstandWalkString = "Handstand walk"

    @Published var editingRecord: PersonalRecord
    @Published var prPercentage: Float = 0.0
    @Published var isWeightInPounds: Bool = false
    @Published var isMaxRepetitions: Bool = false
    @Published var isMaxDistance: Bool = false
    @Published var selectedCategory: Int = 0
    @Published var selectedCategoryItem: Int = 0
    @Published var selectedPercentage: Int = 0
    @Published var selectedInitialPounds: Int = 0
    @Published var selectedMaxReps: Int = 0
    @Published var selectedMinTime: Int = 0
    @Published var selectedDistance: Int = 0
    @Published private(set) var isSaving = false
    @Published private var dataManager: DataManager
    @Published private var settings: UserDefaults
    
    var measureTrackingMode: MeasureTrackingMode {
        get {
            return settings.string(
                forKey: SettingStoreKeys.measureTrackingMode
            ).flatMap {
                MeasureTrackingMode(rawValue: $0)
            } ?? .pounds
        }
    }
    
    init(record: PersonalRecord? = nil, dataManager: DataManager = DataManager.shared, settings: UserDefaults = .standard) {
        self.dataManager = dataManager
        self.settings = settings
        if let newRecord = record {
            self.editingRecord = newRecord
        } else {
            self.editingRecord = PersonalRecord()
        }
        anyCancellable = dataManager.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    func saveRecord() {
        editingRecord.prName = personalRecordTypeList[selectedCategory].title
        editingRecord.group = personalRecordTypeList[selectedCategory].group 
        editingRecord.recordDate = .now
        editingRecord.category = CrossfitLevel.allCases[selectedCategoryItem]
        if isMaxRepetitions {
            editingRecord.recordMode = .maxRepetition
        } else if isMaxDistance {
            editingRecord.recordMode = .maxDistance
        } else {
            editingRecord.recordMode = .maxWeight
        }
        guard let recordMode = editingRecord.recordMode else {
            print("\n🆘 Error: Record mode is empty when save new recors!\n")
            return
        }
        switch recordMode {
        case .maxRepetition:
            editingRecord.maxReps = selectedMaxReps
            editingRecord.minTime = selectedMinTime
        case .maxWeight:
            editingRecord.percentage = Float(selectedPercentage)
            if measureTrackingMode == .pounds {
                editingRecord.poundValue = selectedInitialPounds
                let valueInKilos = (selectedInitialPounds / Int(2.2))
                editingRecord.kiloValue = valueInKilos
            } else {
                editingRecord.kiloValue = Int(selectedInitialPounds)
                let valueInPounds = (selectedInitialPounds * Int(2.2))
                editingRecord.poundValue = valueInPounds
            }
        case .maxDistance:
            if personalRecordTypeList[selectedCategory].title.contains(handstandWalkString) {
                editingRecord.maxReps = selectedDistance
            }
            editingRecord.distance = selectedDistance
            editingRecord.minTime = selectedMinTime
        }
        dataManager.saveNewRecord(record: editingRecord)
    }
}
