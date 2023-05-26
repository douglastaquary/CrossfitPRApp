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

final class InsightsViewModel: ObservableObject {

    @Published var uiState = UserPurchaseState.loading
    @Published var biggestPRName: String = ""
    @Published var biggestPR: PersonalRecord?
    @Published private var dataManager: DataManager?
    private var storeKitTaskHandle: Task<Void, Error>?

    // Barbell
    @Published var barbellBiggestPRName: String = ""
    @Published var barbellBiggestRecord: PersonalRecord?
    @Published var barbellRecords: [PersonalRecord] = []
    @Published var barbellBarPoints: [DataPoint] = []
    @Published var barbellBiggestPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .green, label: "", order: 1))
    @Published var barbellEvolutionPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .yellow, label: "", order: 2))
    @Published var barbellLowPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .gray, label: "", order: 3))
    var barbellHorizontalBarList: [DataPoint] = []
    var topRakingBarbellRecords: [PersonalRecord] = []
    
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
    var topRakingGynmnasticRecords: [PersonalRecord] = []
    
    // Endurance
    @Published var enduranceRecords: [PersonalRecord] = []
    @Published var enduranceBiggestPRName: String = ""
    @Published var enduranceBiggestRecord: PersonalRecord?
    @Published var enduranceBarPoints: [DataPoint] = []
    @Published var enduranceBiggestPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .green, label: "", order: 1))
    @Published var enduranceEvolutionPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .yellow, label: "", order: 2))
    @Published var enduranceLowPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .gray, label: "", order: 3))
    var enduranceHorizontalBarList: [DataPoint] = []
    var topRakingEnduranceRecords: [PersonalRecord] = []
    
    private let defaults: UserDefaults
    private let storeKitService: StoreKitManager
    let biggestPr = Legend(color: .green, label: "PR Biggest", order: 3)
    
    var anyCancellable: AnyCancellable? = nil
    var measureTrackingMode: MeasureTrackingMode {
        get {
            return defaults.string(forKey: SettingStoreKeys.measureTrackingMode)
                .flatMap { MeasureTrackingMode(rawValue: $0)} ?? .pounds
        }
    }

    var records: [PersonalRecord] {
        if let records = dataManager?.recordsArray {
            return records
        }
        return []
    }
    
    init(dataManager: DataManager = DataManager.shared, defaults: UserDefaults, storeKitService: StoreKitManager) {
        self.defaults = defaults
        self.dataManager = dataManager
        self.storeKitService = storeKitService
        self.uiState = storeKitService.uiState
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        startStoreKitListener()
//        
//        Task {
//            await updatePurchases()
//        }
        
        loadBarbellRecords()
        loadGymnasticRecords()
        loadEnduranceRecords()
        
        switch measureTrackingMode {
        case .pounds:
            performTopRankingBarbellRecordsForPounds()
        case .kilos:
            performTopRankingBarbellRecordsForKilos()
        }
        
        performTopRankingGymnasticRecords()
        performTopRankingEnduranceRecords()
        buildLastPercentage()
    }
    
    // Call this early in the app's lifecycle.
    private func startStoreKitListener() {
        storeKitTaskHandle = StoreKitManager.listenForStoreKitUpdates()
    }
    
    // Barbell methods
    func loadBarbellRecords() {
        barbellRecords = getAllRecordsFor(recordGroup: .barbell)
    }
    
    func performTopRankingBarbellRecordsForKilos() {
        let max: Int = barbellRecords.map { $0.kiloValue }.max() ?? 0
        let maxPR = barbellRecords.filter { pr in pr.kiloValue == max }.first ?? PersonalRecord()
        barbellBiggestPRName = maxPR.prName
        topRakingBarbellRecords.append(maxPR)
        
        let min: Int = barbellRecords.filter { pr in
            pr.kiloValue < max
        }.filter { pr in
            pr.prName != barbellBiggestPRName
        }.sorted {
            $0.percentage > $1.percentage
        }.map {
            $0.kiloValue
        }.min() ?? 0
        let minPR = barbellRecords.filter { pr in pr.kiloValue == min }.first ?? PersonalRecord()
        
        let evolutionPR = barbellRecords.filter { pr in
            return pr.kiloValue < max && pr.kiloValue > min && pr.prName != barbellBiggestPRName && pr.prName != minPR.prName
        }.sorted {
            $0.kiloValue > $1.kiloValue
        }.first
        
        guard var barbellRvolutionPR  = evolutionPR else { return }
        barbellRvolutionPR.legend = .yellow
        topRakingBarbellRecords.append(barbellRvolutionPR)
        
        for barbell in barbellRecords {
            if barbell.kiloValue == min, barbell.prName != barbellBiggestPRName {
                var minArrayRecords: [PersonalRecord] = []
                minArrayRecords.append(barbell)
                if var lowerRecordToshow = minArrayRecords.first {
                    lowerRecordToshow.legend = .red
                    topRakingBarbellRecords.append(lowerRecordToshow)
                }
                
            }
        }
        let sortedTopBarbellRecordsRanking = topRakingBarbellRecords.sorted { $0.kiloValue > $1.kiloValue }
        topRakingBarbellRecords = sortedTopBarbellRecordsRanking
    }
    
    func performTopRankingBarbellRecordsForPounds() {
        let max: Int = barbellRecords.map { $0.poundValue }.max() ?? 0
        let maxPR = barbellRecords.filter {
            pr in pr.poundValue == max
        }.sorted {
            $0.recordDate < $1.recordDate
        }.first ?? PersonalRecord()
        barbellBiggestPRName = maxPR.prName
        topRakingBarbellRecords.append(maxPR)
        
        let min: Int = barbellRecords.filter { pr in
            pr.poundValue < max
        }.filter { pr in
            pr.prName != barbellBiggestPRName
        }.sorted {
            $0.percentage > $1.percentage
        }.map {
            $0.poundValue
        }.min() ?? 0
        let minPR = barbellRecords.filter { pr in pr.poundValue == min }.first ?? PersonalRecord()
        
        let evolutionPR = barbellRecords.filter { pr in
            return pr.poundValue < max && pr.poundValue > min && pr.prName != barbellBiggestPRName && pr.prName != minPR.prName
        }.sorted {
            $0.poundValue > $1.poundValue
        }.first
        
        
        guard var barbellRvolutionPR = evolutionPR else { return }
        barbellRvolutionPR.legend = .yellow
        topRakingBarbellRecords.append(barbellRvolutionPR)
        
        for barbell in barbellRecords {
            if barbell.poundValue == min, barbell.prName != barbellBiggestPRName {
                var minArrayRecords: [PersonalRecord] = []
                minArrayRecords.append(barbell)
                if var lowerRecordToshow = minArrayRecords.first {
                    lowerRecordToshow.legend = .red
                    topRakingBarbellRecords.append(lowerRecordToshow)
                }
                
                
                
                var minRecord = barbell
                minRecord.legend = .red
                topRakingBarbellRecords.append(minRecord)
            }
        }
        let sortedTopBarbellRecordsRanking = topRakingBarbellRecords.sorted { $0.poundValue > $1.poundValue }
        topRakingBarbellRecords = sortedTopBarbellRecordsRanking
    }
    
    // Gymnastic methods
    func loadGymnasticRecords() {
        gymnasticRecords = getAllRecordsFor(recordGroup: .gymnastic)
    }
    
    func performTopRankingGymnasticRecords() {
        let max: Int = gymnasticRecords.map { $0.maxReps }.max() ?? 0
        let maxPR = gymnasticRecords.filter { pr in pr.maxReps == max }.first ?? PersonalRecord()
        gymnasticBiggestPRName = maxPR.prName
        topRakingGynmnasticRecords.append(maxPR)
        
        let min: Int = gymnasticRecords.filter { pr in
            pr.maxReps < max
        }.filter { pr in
            pr.prName != gymnasticBiggestPRName
        }.sorted {
            $0.minTime > $1.minTime
        }.map {
            $0.maxReps
        }.min() ?? 0
        let minPR = gymnasticRecords.filter { pr in pr.maxReps == min }.first ?? PersonalRecord()
        
        let evolutionPR = gymnasticRecords.filter { pr in
            return pr.maxReps < max && pr.maxReps > min && pr.prName != gymnasticBiggestPRName && pr.prName != minPR.prName
        }.sorted {
            $0.maxReps > $1.maxReps
        }.first
        
        guard let gymEvolutionPR = evolutionPR else { return }
        topRakingGynmnasticRecords.append(gymEvolutionPR)
        
        for barbell in gymnasticRecords {
            if barbell.kiloValue == min, barbell.prName != gymnasticBiggestPRName {
                topRakingGynmnasticRecords.append(barbell)
            }
        }
        let sortedTopGymRecordsRanking = topRakingGynmnasticRecords.sorted { $0.maxReps > $1.maxReps }
        topRakingGynmnasticRecords = sortedTopGymRecordsRanking
    }
    
    
    // Endurance methods
    func loadEnduranceRecords() {
        enduranceRecords = getAllRecordsFor(recordGroup: .endurance)
    }
    
    func buildLastPercentage() {
        for i in 0..<topRakingBarbellRecords.count {
            let mostRecents = barbellRecords.filter {
                pr in pr.prName == topRakingBarbellRecords[i].prName
            }
            
            if mostRecents.count > 1 {
                let sorted = mostRecents.sorted { $0.recordDate.timeIntervalSince1970 > $1.recordDate.timeIntervalSince1970 }
                let firstRecordPoundValue = sorted[0].poundValue
                let secondRecordPoundValue = sorted[1].poundValue
                let evolutionValue = firstRecordPoundValue - secondRecordPoundValue
                topRakingBarbellRecords[i].evolutionPercentage =  evolutionValue
                print("topRakingBarbellRecords \(i) = \(evolutionValue)%")
            } else {
                topRakingBarbellRecords[i].evolutionPercentage = mostRecents.first?.evolutionPercentage ?? 0
            }
        }
    }

    func performTopRankingEnduranceRecords() {
        let max: Int = enduranceRecords.map { $0.distance }.max() ?? 0
        let maxPR = enduranceRecords.filter { pr in pr.distance == max }.first ?? PersonalRecord()
        enduranceBiggestPRName = maxPR.prName
        topRakingEnduranceRecords.append(maxPR)
        
        let min: Int = enduranceRecords.filter { pr in
            pr.distance < max
        }.filter { pr in
            pr.prName != enduranceBiggestPRName
        }.sorted {
            $0.minTime > $1.minTime
        }.map {
            $0.distance
        }.min() ?? 0
        let minPR = enduranceRecords.filter { pr in pr.distance == min }.first ?? PersonalRecord()
        
        let evolutionPR = enduranceRecords.filter { pr in
            return pr.distance < max && pr.distance > min && pr.prName != enduranceBiggestPRName && pr.prName != minPR.prName
        }.sorted {
            $0.minTime > $1.minTime
        }.first
        
        guard let enduranceRvolutionPR = evolutionPR else { return }
        topRakingEnduranceRecords.append(enduranceRvolutionPR)
        
        for barbell in enduranceRecords {
            if barbell.distance == min, barbell.prName != enduranceBiggestPRName {
                topRakingEnduranceRecords.append(barbell)
            }
        }
        let sortedTopEnduranceRecordsRanking = topRakingEnduranceRecords.sorted { $0.distance > $1.distance }
        topRakingEnduranceRecords = sortedTopEnduranceRecordsRanking
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
        let records = groupRecords.sorted(by: {$0.recordDate.compare($1.recordDate) == .orderedAscending })
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

extension InsightsViewModel {
    func updatePurchases() async {
        var isPRO: Bool { get { defaults.bool(forKey: SettingStoreKeys.pro) } }
        if isPRO {
            DispatchQueue.main.async {
                self.uiState = .isPRO
            }
        } else {
            DispatchQueue.main.async {
                self.uiState = .blockPro
            }
        }
    }
}
