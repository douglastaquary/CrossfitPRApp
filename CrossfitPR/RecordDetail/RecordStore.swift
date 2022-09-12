//
//  RecordStore.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 11/05/22.
//

import Foundation
import SwiftUI
import Combine
import SwiftUICharts
import os

@MainActor final class RecordStore: ObservableObject {
    private static let logger = Logger(
        subsystem: "com.dabtlab.crossfitprapp",
        category: String(describing: RecordStore.self)
    )
    
    @Published var evolutionPoints: [DataPoint] = []
    @Published var records: [PersonalRecord] = []
    @Published private var dataManager: DataManager?
    var anyCancellable: AnyCancellable? = nil
    
    private let defaults: UserDefaults
    private var recordType: String = ""
    
    private var prEvolution = Legend(color: .yellow, label: "PR evolution", order: 3)
    private var mostRecent = Legend(color: .green, label: "Most recent pr", order: 4)
    private var lowestPR = Legend(color: .gray, label: "Lowest pr", order: 2)
    
    init(recordType: String = "", defaults: UserDefaults = .standard, dataManager: DataManager = DataManager.shared) {
        self.recordType = recordType
        self.defaults = defaults
        self.dataManager = dataManager
        
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    var isPro: Bool {
        get { defaults.bool(forKey: SettingStoreKeys.pro) }
    }
    
    var measureTrackingMode: MeasureTrackingMode {
        get {
            return defaults.string(forKey: SettingStoreKeys.measureTrackingMode)
                .flatMap { MeasureTrackingMode(rawValue: $0) } ?? .pounds
        }
    }
    
    var record: PersonalRecord {
        getMaxRecord(prs: filteredPrs)
    }
    
    var points: [DataPoint] {
        let isPounds = measureTrackingMode == .pounds
        let sortedPoints = filteredPrs.sorted(by: {$0.recordDate?.compare($1.recordDate ?? Date()) == .orderedAscending })
        if isPounds {
            return sortedPoints.map { pr in
                DataPoint.init(
                    value: Double(pr.poundValue),
                    label: "\(pr.poundValue) lb",
                    legend: validateCategoryInformation(pr))
            }
        }
        
        return sortedPoints.map { pr in
            DataPoint.init(value: Double(pr.kiloValue), label: "\(pr.kiloValue) kg", legend: validateCategoryInformation(pr))
        }
    
    }

    var filteredPrs: [PersonalRecord] {
        if let records = dataManager?.recordsArray {
            let sortedRecords = records.sorted(by:{ $0.recordDate?.compare($1.recordDate ?? Date()) == .orderedDescending })
            return sortedRecords.filter { $0.prName.rawValue.contains(recordType) }.sorted()
        }
        return []
    }
    
    private func getMaxRecord(prs: [PersonalRecord]) -> PersonalRecord {
        if prs.isEmpty {
            return PersonalRecord()
        }
        if measureTrackingMode == .pounds {
            let max: Int = prs.map { Int($0.poundValue) }.max() ?? 0
            let biggestPR = prs.filter { Int($0.poundValue) == max }.first ?? PersonalRecord()
            return biggestPR
        }
        let max: Int = prs.map { Int($0.kiloValue) }.max() ?? 0
        let biggestPR = prs.filter { Int($0.kiloValue)  == max }.first ?? PersonalRecord()
        
        return biggestPR
    }
    
    private func getMinRecord(prs: [PersonalRecord]) -> PersonalRecord {
        if prs.isEmpty {
            return PersonalRecord()
        }
        if measureTrackingMode == .pounds {
            let min: Int = prs.map { Int($0.poundValue)  }.min() ?? 0
            let biggestPr = prs.filter { Int($0.poundValue) == min }.first ?? PersonalRecord()
            return biggestPr
        }
        let min: Int = prs.map { Int($0.kiloValue) }.min() ?? 0
        let biggestPr = prs.filter { Int($0.kiloValue) == min }.first ?? PersonalRecord()
        return biggestPr
    }
    
    func loadGraph() {
        if measureTrackingMode == .pounds {
            evolutionPoints = filteredPrs.map { pr in
                DataPoint.init(value: Double(pr.poundValue), label: "", legend: validateCategoryInformation(pr))
            }
            return
        }
        evolutionPoints = filteredPrs.map { pr in
            DataPoint.init(value: Double(pr.kiloValue), label: "", legend: validateCategoryInformation(pr))
        }
    }

    private func validateCategoryInformation(_ pr: PersonalRecord) -> Legend {
        let biggestPr = Legend(color: .green, label: "record.view.category.recent.title", order: 3)
        let evolutionPr = Legend(color: .yellow, label: "record.view.category.evolution.title", order: 2)
        let lowestRecord = Legend(color: .gray, label: "record.view.category.lowest.title", order: 1)
        
        if measureTrackingMode == .pounds {
            let max: Int = filteredPrs.map { Int($0.poundValue) }.max() ?? 0
            let min: Int = filteredPrs.map { Int($0.poundValue) }.min() ?? 0
            let recordPound =  pr.poundValue
            if recordPound >= max {
                return biggestPr
            } else if recordPound == min {
                return lowestRecord
            } else {
                return evolutionPr
            }
        }
        let max: Int = filteredPrs.map { Int($0.kiloValue) }.max() ?? 0
        let min: Int = filteredPrs.map { Int($0.kiloValue) }.min() ?? 0
        let recordKilo =  pr.kiloValue
        if recordKilo >= max {
            return biggestPr
        } else if recordKilo == min {
            return lowestRecord
        } else {
            return evolutionPr
        }
    }
    
    func delete(at offsets: IndexSet) {
            for index in offsets {
                self.dataManager?.delete(record: dataManager?.recordsArray[index] ?? PersonalRecord.recordMock)
            }
        }
    
}

