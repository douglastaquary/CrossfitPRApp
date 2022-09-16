//
//  InsightsStore.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 25/04/22.
//

import Foundation
import SwiftUI
import Combine
import CoreData
import SwiftUICharts

final class InsightsStore: ObservableObject {
    @Published var biggestPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .green, label: "", order: 1))
    @Published var evolutionPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .yellow, label: "", order: 2))
    @Published var lowPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .gray, label: "", order: 3))
    @Published var limit: DataPoint = DataPoint(value: 0, label: "", legend: Legend(color: .clear, label: ""))
    @Published var barPoints: [DataPoint] = []
    @Published var biggestPRName: String = ""
    @Published var biggestPR: PersonalRecord?
    @Published private var dataManager: DataManager?
    
    // Barbell
    @Published var barbellBiggestPRName: String = ""
    @Published var barbellBiggestRecord: PersonalRecord?
    @Published var barbellRecords: [PersonalRecord] = []
    @Published var barbellBarPoints: [DataPoint] = []
    @Published var barbellBiggestPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .green, label: "", order: 1))
    @Published var barbellEvolutionPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .yellow, label: "", order: 2))
    @Published var barbellLowPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .gray, label: "", order: 3))
    var barbellHorizontalBarList: [DataPoint] = []
    
    // Gymnastic
    @Published var gymnasticRecords: [PersonalRecord] = []
    @Published var gymnasticBiggestPRName: String = ""
    @Published var gymnasticBiggestRecord: PersonalRecord?
    @Published var hangstandWalkRecord: PersonalRecord?
    @Published var hangstandWalkPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .brown, label: "", order: 4))
    @Published var gymnasticBiggestPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .green, label: "", order: 1))
    @Published var gymnasticEvolutionPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .yellow, label: "", order: 2))
    @Published var gymnasticLowPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .gray, label: "", order: 3))
    var gynmnasticHorizontalBarList: [DataPoint] = []
    
    // Endurance
    @Published var enduranceRecords: [PersonalRecord] = []
    @Published var enduranceBiggestPRName: String = ""
    @Published var enduranceBiggestRecord: PersonalRecord?
    @Published var enduranceBarPoints: [DataPoint] = []
    @Published var enduranceBiggestPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .green, label: "", order: 1))
    @Published var enduranceEvolutionPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .yellow, label: "", order: 2))
    @Published var enduranceLowPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .gray, label: "", order: 3))
    var enduranceHorizontalBarList: [DataPoint] = []
    
    private let defaults: UserDefaults
    let biggestPr = Legend(color: .green, label: "PR Biggest", order: 3)
    
    var anyCancellable: AnyCancellable? = nil
    var measureTrackingMode: MeasureTrackingMode {
        get {
            return defaults.string(forKey: SettingStoreKeys.measureTrackingMode)
                .flatMap { MeasureTrackingMode(rawValue: $0) } ?? .pounds
        }
    }
    
    var isPro: Bool {
        set { defaults.set(newValue, forKey: SettingStoreKeys.pro) }
        get { defaults.bool(forKey: SettingStoreKeys.pro) }
    }
    
    var records: [PersonalRecord] {
        if let records = dataManager?.recordsArray {
            return records
        }
        return []
    }
    
    init(dataManager: DataManager = DataManager.shared, defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        loadBarbellRecords()
        loadBabellHorizontalBar()
        loadGymnasticRecords()
        loadEnduranceRecords()
    }
    
    // Barbell methods
    func loadBarbellRecords() {
        barbellRecords = getAllRecordsFor(recordGroup: .barbell)
    }
    
    private func loadBabellHorizontalBar() {
        if measureTrackingMode == .pounds {
            if validateIfOnlyOneRecord(for: barbellRecords), let barbellEvolution = barbellRecords.first {
                barbellBiggestPoint = DataPoint.init(
                    value: Double(barbellEvolution.poundValue),
                    label: "\(barbellEvolution.poundValue) lb",
                    legend: Legend(color: .green, label: "\(barbellEvolution.prName)", order: 1)
                )
                barbellBiggestPRName = barbellEvolution.prName
                barbellBiggestRecord = barbellEvolution
                barbellHorizontalBarList.append(barbellBiggestPoint)
                return
            }
            
            let max: Int = barbellRecords.map { $0.poundValue }.max() ?? 0
            let min: Int = barbellRecords.map { $0.poundValue }.min() ?? 0
            let evolutionPRselected = barbellRecords.filter { pr in
                return pr.poundValue < max && pr.poundValue > min && pr.prName != biggestPRName
            }.sorted {
                $0.poundValue > $1.poundValue
            }.first
            
            barbellEvolutionPoint = DataPoint.init(
                value: Double(evolutionPRselected?.poundValue ?? 0),
                label: "\(evolutionPRselected?.poundValue ?? 0) lb",
                legend: Legend(color: .yellow, label: "\(evolutionPRselected?.prName ?? "")", order: 2)
            )
            for pr in barbellRecords {
                if pr.poundValue == max {
                    barbellBiggestPoint = DataPoint.init(
                        value: Double(pr.poundValue),
                        label: "\(pr.poundValue) lb",
                        legend: Legend(color: .green, label: "\(pr.prName)", order: 1)
                    )
                    barbellBiggestPRName = pr.prName
                    barbellBiggestRecord = pr
                    barbellHorizontalBarList.append(barbellBiggestPoint)
                    if barbellRecords.count > 2 {
                        barbellHorizontalBarList.append(barbellEvolutionPoint)
                    }
                }
                
            }
            for pr in barbellRecords {
                if pr.poundValue == min {
                    barbellLowPoint = DataPoint.init(
                        value: Double(pr.poundValue),
                        label: "\(pr.poundValue) lb",
                        legend: Legend(color: .gray, label: "\(pr.prName)", order: 3)
                    )
                    barbellHorizontalBarList.append(barbellLowPoint)
                }
            }
        } else {
            if validateIfOnlyOneRecord(for: barbellRecords), let barbellEvolution = barbellRecords.first {
                barbellBiggestPoint = DataPoint.init(
                    value: Double(barbellEvolution.kiloValue),
                    label: "\(barbellEvolution.kiloValue) kg",
                    legend: Legend(color: .green, label: "\(barbellEvolution.prName)", order: 1)
                )
                barbellBiggestPRName = barbellEvolution.prName
                barbellBiggestRecord = barbellEvolution
                barbellHorizontalBarList.append(barbellBiggestPoint)
                return
            }
            
            let max: Int = barbellRecords.map { $0.kiloValue }.max() ?? 0
            let min: Int = barbellRecords.map { $0.kiloValue }.min() ?? 0
            let evolutionPRselected = barbellRecords.filter { pr in
                return pr.kiloValue < max && pr.kiloValue > min && pr.prName != biggestPRName
            }.sorted {
                $0.kiloValue > $1.kiloValue
            }.first
            
            barbellEvolutionPoint = DataPoint.init(
                value: Double(evolutionPRselected?.kiloValue ?? 0),
                label: "\(evolutionPRselected?.kiloValue ?? 0) kg",
                legend: Legend(color: .yellow, label: "\(evolutionPRselected?.prName ?? "")", order: 2)
            )
            for pr in barbellRecords {
                if pr.kiloValue == max {
                    barbellBiggestPoint = DataPoint.init(
                        value: Double(pr.kiloValue),
                        label: "\(pr.kiloValue) kg",
                        legend: Legend(color: .green, label: "\(pr.prName)", order: 1)
                    )
                    barbellBiggestPRName = pr.prName
                    barbellBiggestRecord = pr
                    barbellHorizontalBarList.append(barbellBiggestPoint)
                    if barbellRecords.count > 2 {
                        barbellHorizontalBarList.append(barbellEvolutionPoint)
                    }
                }
                
            }
            for pr in barbellRecords {
                if pr.kiloValue == min {
                    barbellLowPoint = DataPoint.init(
                        value: Double(pr.kiloValue),
                        label: "\(pr.kiloValue) kg",
                        legend: Legend(color: .gray, label: "\(pr.prName)", order: 3)
                    )
                    barbellHorizontalBarList.append(barbellLowPoint)
                }
            }
        }
    }
    
    // Gymnastic methods
    func loadGymnasticRecords() {
        gymnasticRecords = getAllRecordsFor(recordGroup: .gymnastic)
        loadGymnasticHorizontalBars()
    }
    
    func loadGymnasticHorizontalBars() {
        if validateIfOnlyOneRecord(for: gymnasticRecords), let gymnasticEvolution = gymnasticRecords.first {
            let handstandWalk = gymnasticRecords.filter { record in
                if let recordMode = record.recordMode {
                    return recordMode.rawValue.contains(RecordMode.maxDistance.rawValue)
                }
                return false
            }.first
            if let handstand = handstandWalk {
                hangstandWalkPoint = DataPoint.init(
                    value: Double(handstand.distance),
                    label: "\(handstand.distance) m",
                    legend: Legend(color: .green, label: "\(handstand.prName)", order: 1)
                )
                gymnasticBiggestPRName = handstand.prName
                gymnasticBiggestRecord = handstand
                gynmnasticHorizontalBarList.append(hangstandWalkPoint)
                return
            }
            gymnasticBiggestPoint = DataPoint.init(
                value: Double(gymnasticEvolution.maxReps),
                label: "\(gymnasticEvolution.maxReps) reps",
                legend: Legend(color: .green, label: "\(gymnasticEvolution.prName)", order: 1)
            )
            gymnasticBiggestPRName = gymnasticEvolution.prName
            gymnasticBiggestRecord = gymnasticEvolution
            return
        }
        let maxRepsRecords = gymnasticRecords.filter { record in
            if let recordMode = record.recordMode {
                return recordMode.rawValue.contains(RecordMode.maxRepetition.rawValue)
            }
            return false
        }
        let maxGymnastic: Int = maxRepsRecords.map { $0.maxReps }.max() ?? 0
        let minGymnastic: Int = maxRepsRecords.map { $0.maxReps }.min() ?? 0
        let handstandWalk = gymnasticRecords.filter { record in
            if let recordMode = record.recordMode {
                return recordMode.rawValue.contains(RecordMode.maxDistance.rawValue)
            }
            return false
        }.first ?? PersonalRecord()
        if handstandWalk.distance > 0 {
            hangstandWalkRecord = handstandWalk
            hangstandWalkPoint = DataPoint.init(
                value: Double(handstandWalk.distance),
                label: "\(handstandWalk.distance) km",
                legend: Legend(color: .yellow, label: "\(handstandWalk.prName)", order: 4)
            )
        }
        
        let maxRepEvolution = maxRepsRecords.filter { pr in
            return pr.maxReps < maxGymnastic && pr.maxReps > minGymnastic //&& pr.prName != biggestPRName
        }.sorted {
            $0.maxReps > $1.maxReps
        }.first
        
        // So tenho dois itens e um deles é handstand
        if gymnasticRecords.count == 2, handstandWalk.distance > 0 {
            
        }
        
        gymnasticEvolutionPoint = DataPoint.init(
            value: Double(maxRepEvolution?.maxReps ?? 0),
            label: "\(maxRepEvolution?.maxReps ?? 0) reps",
            legend: Legend(color: .yellow, label: "\(maxRepEvolution?.prName ?? "")", order: 2)
        )
        
        for pr in maxRepsRecords {
            if pr.maxReps == maxGymnastic {
                gymnasticBiggestPoint = DataPoint.init(
                    value: Double(pr.maxReps),
                    label: "\(pr.maxReps) reps",
                    legend: Legend(color: .green, label: "\(pr.prName)", order: 1)
                )
                barbellBiggestPRName = pr.prName
                barbellBiggestRecord = pr
                gynmnasticHorizontalBarList.append(gymnasticBiggestPoint)
                // So tenho dois itens e um deles é handstand
                if gymnasticRecords.count == 2, handstandWalk.distance > 0 {
                    gynmnasticHorizontalBarList.append(hangstandWalkPoint)
                } else if gymnasticRecords.count > 2 {
                    gynmnasticHorizontalBarList.append(gymnasticEvolutionPoint)
                }
            }
        }
        
        if gymnasticRecords.count == 2, handstandWalk.distance > 0 {
            return
        }
        
        for pr in maxRepsRecords {
            if pr.maxReps == minGymnastic {
                gymnasticLowPoint = DataPoint.init(
                    value: Double(pr.maxReps),
                    label: "\(pr.maxReps) reps",
                    legend: Legend(color: .gray, label: "\(pr.prName)", order: 3)
                )
                gynmnasticHorizontalBarList.append(gymnasticLowPoint)
            }
            
        }
    }
    
    // Endurance methods
    func loadEnduranceRecords() {
        enduranceRecords = getAllRecordsFor(recordGroup: .endurance)
        loadEnduranceHorizontalBars()
    }
    
    func loadEnduranceHorizontalBars() {
        let maxEndurance: Int = enduranceRecords.map { $0.distance }.max() ?? 0
        let minEndurance: Int = enduranceRecords.map { $0.distance }.min() ?? 0
        if validateIfOnlyOneRecord(for: enduranceRecords), let enduranceEvolution = enduranceRecords.first {
            enduranceBiggestPoint = DataPoint.init(
                value: Double(enduranceEvolution.distance),
                label: "\(enduranceEvolution.distance) km",
                legend: Legend(color: .green, label: "\(enduranceEvolution.prName)", order: 1)
            )
            enduranceBiggestPRName = enduranceEvolution.prName
            enduranceBiggestRecord = enduranceEvolution
            enduranceHorizontalBarList.append(enduranceBiggestPoint)
            return
        }
        if enduranceRecords.count == 2 {
            let sortedRecords = enduranceRecords.sorted {
                $0.distance < $1.distance
            }
            
            enduranceEvolutionPoint = DataPoint.init(
                value: Double(sortedRecords[0].distance),
                label: "\(sortedRecords[0].distance) km",
                legend: Legend(color: .yellow, label: "\(sortedRecords[0].prName)", order: 2)
            )
            
            enduranceBiggestPRName = sortedRecords[0].prName
            enduranceBiggestRecord = sortedRecords[0]
            
            enduranceBiggestPoint = DataPoint.init(
                value: Double(sortedRecords[1].distance),
                label: "\(sortedRecords[1].distance) km",
                legend: Legend(color: .green, label: "\(sortedRecords[1].prName)", order: 1)
            )
            
            enduranceHorizontalBarList.append(enduranceBiggestPoint)
            enduranceHorizontalBarList.append(enduranceEvolutionPoint)
            return
        } else {
            let enduranceEvolution = enduranceRecords.filter { pr in
                return pr.distance < maxEndurance && pr.distance > minEndurance
            }.sorted {
                $0.distance > $1.distance
            }.first ?? PersonalRecord()
            
            enduranceEvolutionPoint = DataPoint.init(
                value: Double(enduranceEvolution.distance),
                label: "\(enduranceEvolution.distance) km",
                legend: Legend(color: .yellow, label: "\(enduranceEvolution.prName)", order: 2)
            )
            for pr in enduranceRecords {
                if pr.distance == maxEndurance {
                    enduranceBiggestPoint = DataPoint.init(
                        value: Double(pr.distance),
                        label: "\(pr.distance) km",
                        legend: Legend(color: .green, label: "\(pr.prName)", order: 1)
                    )
                    enduranceBiggestPRName = pr.prName
                    enduranceBiggestRecord = pr
                    enduranceHorizontalBarList.append(enduranceBiggestPoint)
                    enduranceHorizontalBarList.append(enduranceEvolutionPoint)
                }
            }
            
            for pr in enduranceRecords {
                if pr.distance == minEndurance {
                    enduranceLowPoint = DataPoint.init(
                        value: Double(pr.distance),
                        label: "\(pr.distance) km",
                        legend: Legend(color: .gray, label: "\(pr.prName)", order: 3)
                    )
                    enduranceHorizontalBarList.append(enduranceLowPoint)
                }
            }
        }
    }
    
    private func validateIfOnlyOneRecord(for data: [PersonalRecord]) -> Bool {
        if data.count == 1 {
            return true
        }
        return false
    }
    
    private func getAllRecordsFor(recordGroup: RecordGroup) -> [PersonalRecord] {
        let groupRecords = self.records.filter { record in
            if let group = record.group {
                return group.rawValue.contains(recordGroup.rawValue)
            }
            return false
        }
        let records = groupRecords.sorted(by: {$0.recordDate?.compare($1.recordDate ?? Date()) == .orderedAscending })
        return records
    }
    
    private func validateCategoryInformationPounds(_ pr: PersonalRecord) -> Legend {
        let max: Int = records.map { $0.poundValue }.max() ?? 0
        let min: Int = records.map { $0.poundValue }.min() ?? 0
        let biggestPr = Legend(color: .green, label: "PR Biggest", order: 3)
        let evolutionPr = Legend(color: .yellow, label: "PR Evolution", order: 2)
        let lowestRecord = Legend(color: .gray, label: "PR Lowest", order: 1)
        if pr.poundValue >= max {
            return biggestPr
        } else if pr.poundValue == min {
            return lowestRecord
        } else {
            return evolutionPr
        }
    }
    
    private func validateCategoryInformationKilos(_ pr: PersonalRecord) -> Legend {
        let max: Int = records.map { $0.kiloValue }.max() ?? 0
        let min: Int = records.map { $0.kiloValue }.min() ?? 0
        let biggestPr = Legend(color: .green, label: "PR Biggest", order: 3)
        let evolutionPr = Legend(color: .yellow, label: "PR Evolution", order: 2)
        let lowestRecord = Legend(color: .gray, label: "PR Lowest", order: 1)
        if pr.kiloValue >= max {
            return biggestPr
        } else if pr.kiloValue == min {
            return lowestRecord
        } else {
            return evolutionPr
        }
    }
}

extension InsightsStore {
    func unlockPro() {
        // You can do your in-app transactions here
        isPro = true
    }
    
    func restorePurchase() {
        // You can do you in-app purchase restore here
        isPro = false
    }
}
