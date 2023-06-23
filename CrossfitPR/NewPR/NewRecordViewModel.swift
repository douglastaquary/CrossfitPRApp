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
    
    var crossfitLevelList = CrossfitLevel.allCases.map { $0.rawValue }
    var personalRecordTypeList: [Category] = []
    var anyCancellable: AnyCancellable? = nil
    private let handstandWalkString = "Handstand walk"

    @Published var editingRecord: PersonalRecord
    @Published var editingCategory: Category
    @Published var prPercentage: Float = 0.0
    @Published var isWeightInPounds: Bool = false
    @Published var isMaxRepetitions: Bool = false
    @Published var isMaxDistance: Bool = false
    @Published var selectedCategory: Int = 0
    @Published var selectedCategoryItem: Int = 0
    @Published var selectedPercentage: String = ""
    @Published var selectedInitialPounds: String = ""
    @Published var selectedMaxReps: String = ""
    @Published var selectedMinTime: String = ""
    @Published var selectedDistance: String = ""
    var isSaving: Bool {
        !selectedPercentage.isEmpty && !selectedInitialPounds.isEmpty || !selectedMinTime.isEmpty && !selectedMaxReps.isEmpty || !selectedMinTime.isEmpty && !selectedDistance.isEmpty
    }

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
    
    init(
        record: PersonalRecord? = nil,
        dataManager: DataManager = DataManager.shared,
        settings: UserDefaults = .standard,
        category: Category? = nil
    ) {
        self.dataManager = dataManager
        self.settings = settings
        
        if let newRecord = record {
            self.editingRecord = newRecord
        } else if let category = category {
            self.editingCategory = category
            self.editingRecord = PersonalRecord(prName: category.title, recordMode: category.type, group: category.group)
            self.selectedCategory = category.type.index
        } else {
            self.editingRecord = PersonalRecord()
        }
        
        self.personalRecordTypeList = Category.list.sorted()
        self.editingCategory = category ?? Category(title: "", type: .maxWeight)
        
        anyCancellable = dataManager.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        setupCategoryForEditingRecord()
    }
    
    func setupCategoryForEditingRecord() {
        selectedCategory = editingCategory.type.index
    }
    
    func displayNavigationTitle(for text: String) -> String {
        return personalRecordTypeList.filter {
            $0.title.contains(text)
        }.first?.title ?? ""
    }
      

    func saveRecord() {
        editingRecord.recordDate = .now
        editingRecord.crossfitLevel = CrossfitLevel.allCases[selectedCategoryItem]
        if isMaxRepetitions {
            editingRecord.recordMode = .maxRepetition
        } else if isMaxDistance {
            editingRecord.recordMode = .maxDistance
        } else {
            editingRecord.recordMode = .maxWeight
        }
        guard let group = editingRecord.group else {
            print("\n🆘 Error: Record mode is empty when save new recors!\n")
            return
        }
        switch group {
        case .gymnastic:
            editingRecord.maxReps = Int(selectedMaxReps) ?? 0
            editingRecord.minTime = Int(selectedMinTime) ?? 0
        case .barbell:
            editingRecord.percentage = Float(selectedPercentage) ?? 0.0
            if measureTrackingMode == .pounds {
                editingRecord.poundValue = Int(selectedInitialPounds) ?? 0
                let valueInKilos = (editingRecord.poundValue / Int(2.2))
                editingRecord.kiloValue = valueInKilos
            } else {
                editingRecord.kiloValue = Int(selectedInitialPounds) ?? 0
                let valueInPounds = (editingRecord.kiloValue * Int(2.2))
                editingRecord.poundValue = valueInPounds
            }
        case .endurance:
            if personalRecordTypeList[selectedCategory].title.contains(handstandWalkString) {
                editingRecord.maxReps = Int(selectedDistance) ?? 0
            }
            editingRecord.distance = Int(selectedDistance) ?? 0
            editingRecord.minTime = Int(selectedMinTime) ?? 0
        }
        dataManager.saveNewRecord(record: editingRecord)
    }
}
