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

@MainActor final class RecordDetailViewModel: ObservableObject {
    private static let logger = Logger(
        subsystem: "com.dabtlab.crossfitprapp",
        category: String(describing: RecordDetailViewModel.self)
    )
    @Published var evolutionPoints: [DataPoint] = []
    @Published var records: [PersonalRecord] = []
    @Published private var dataManager: DataManager?
    var anyCancellable: AnyCancellable? = nil
    private var prSection: PRSection?
    private let defaults: UserDefaults
    private var prEvolution = Legend(color: .yellow, label: "record.view.category.evolution.title", order: 3)
    private var mostRecent = Legend(color: .green, label: "record.view.category.recent.title", order: 4)
    private var lowestPR = Legend(color: .gray, label: "record.view.category.lowest.title", order: 2)
    
    init(prSection: PRSection? = nil, defaults: UserDefaults = .standard, dataManager: DataManager = DataManager.shared) {
        self.prSection = prSection
        self.defaults = defaults
        self.dataManager = dataManager
        self.category = prSection
        
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    @Published var category: PRSection?
    
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
    
    func getPoints() -> [RecordPoint] {
        let isPounds = measureTrackingMode == .pounds
        let sortedPoints = filteredPrs.sorted(by: {$0.recordDate.compare($1.recordDate) == .orderedAscending })
        guard let prSection = self.prSection else { return [] }
        switch prSection.group {
        case .barbell:
            if isPounds {
                return sortedPoints.map { pr in
                    RecordPoint.init(
                        name: pr.prName,
                        date: pr.dateFormatter,
                        legend: "\(pr.percentage)",
                        value: Double(pr.poundValue)
                    )
                }
            }
            return sortedPoints.map { pr in
                RecordPoint.init(
                    name: pr.prName,
                    date: pr.dateFormatter,
                    legend: "\(pr.percentage)",
                    value: Double(pr.kiloValue)
                )
            }
        case .endurance:
            return sortedPoints.map { pr in
                RecordPoint.init(
                    name: pr.prName,
                    date: pr.dateFormatter,
                    legend: "\(pr.minTime)",
                    value: Double(pr.distance)
                )
            }
        case .gymnastic:
            return sortedPoints.map { pr in
                RecordPoint.init(
                    name: pr.prName,
                    date: pr.dateFormatter,
                    legend: "\(pr.minTime)",
                    value: Double(pr.maxReps)
                )
            }
        }
    }
    
    var allRecords: [PersonalRecord] {
        if let records = dataManager?.recordsArray {
//            guard let category = self.recordCategory else { return [] }
//            let sortedRecords = records.filter {
//                if let group = $0.group {
//                    return group.rawValue.contains(category.group.rawValue)
//                }
//                return false
//            }.sorted()
//            let categoryRecords = sortedRecords.filter { $0.prName.contains(category.title) }
//            let records = categoryRecords.sorted(by: {$0.recordDate?.compare($1.recordDate ?? Date()) == .orderedDescending })

            return records.sorted()
        }
        return []
    }
    
    var sections: [PRSection] {
        if let records = dataManager?.recordsArray {
            let recordsCache = records.unique{ $0.prName }
            let sections = recordsCache.map { record in
                PRSection(name: record.prName, group: record.group ?? .barbell)
            }
            return sections
        }
        return []
    }
    
//    func filteredPRs(byName: String) {
//        if let records = dataManager?.recordsArray {
//            let sortedRecords = records.filter {
//                return $0.prName.lowercased().contains(byName.lowercased())
//            }.sorted()
//            let records = sortedRecords.sorted(by: {$0.recordDate?.compare($1.recordDate ?? Date()) == .orderedDescending })
//            //filteredPrs.append(contentsOf: records)
//        }
//    }
//    
    var filteredPrs: [PersonalRecord] {
        if let records = dataManager?.recordsArray {
            let prName = prSection?.name ?? ""
            let sortedRecords = records.filter {
                $0.prName.lowercased().contains(prName.lowercased())
            }.sorted()
            let records = sortedRecords.sorted(by: {$0.recordDate.compare($1.recordDate) == .orderedDescending })
            return records
        }
        return []
    }

    func getMaxRecord(prs: [PersonalRecord]) -> PersonalRecord {
        if prs.isEmpty {
            return PersonalRecord()
        }
        guard let section = prSection else { return PersonalRecord() }
        switch section.group {
        case .barbell:
            if measureTrackingMode == .pounds {
                let max: Int = prs.map { Int($0.poundValue) }.max() ?? 0
                let biggestPR = prs.filter { Int($0.poundValue) == max }.first ?? PersonalRecord()
                return biggestPR
            }
            let max: Int = prs.map { Int($0.kiloValue) }.max() ?? 0
            let biggestPR = prs.filter { Int($0.kiloValue)  == max }.first ?? PersonalRecord()
            return biggestPR
        case .endurance:
            let max: Int = prs.map { Int($0.distance) }.max() ?? 0
            let maxRepsPR = prs.filter { Int($0.distance)  == max }.first ?? PersonalRecord()
            return maxRepsPR
        case .gymnastic:
            let max: Int = prs.map { Int($0.maxReps) }.max() ?? 0
            let maxRepsPR = prs.filter { Int($0.maxReps)  == max }.first ?? PersonalRecord()
            return maxRepsPR
        }
    }
    
    private func getMinRecord(prs: [PersonalRecord]) -> PersonalRecord {
        if prs.isEmpty {
            return PersonalRecord()
        }
        guard let section = prSection else { return PersonalRecord() }
        switch section.group {
        case .barbell:
            if measureTrackingMode == .pounds {
                let min: Int = prs.map { Int($0.poundValue)  }.min() ?? 0
                let lowerPr = prs.filter { Int($0.poundValue) == min }.first ?? PersonalRecord()
                return lowerPr
            }
            let min: Int = prs.map { Int($0.kiloValue) }.min() ?? 0
            let lowerPr = prs.filter { Int($0.kiloValue) == min }.first ?? PersonalRecord()
            return lowerPr
        case .endurance:
            let min: Int = prs.map { Int($0.distance) }.min() ?? 0
            let minRepsPR = prs.filter { Int($0.distance) == min }.first ?? PersonalRecord()
            return minRepsPR
        case .gymnastic:
            let max: Int = prs.map { Int($0.maxReps) }.max() ?? 0
            let maxRepsPR = prs.filter { Int($0.maxReps)  == max }.first ?? PersonalRecord()
            return maxRepsPR
        }
    }
    
    func loadGraph() {
        guard let section = prSection else { return }
        switch section.group {
        case .barbell:
            if measureTrackingMode == .pounds {
                evolutionPoints = filteredPrs.map { pr in
                    DataPoint.init(value: Double(pr.poundValue), label: "", legend: validateCategoryInformation(pr))
                }
                return
            }
            evolutionPoints = filteredPrs.map { pr in
                DataPoint.init(value: Double(pr.kiloValue), label: "", legend: validateCategoryInformation(pr))
            }
        case .endurance:
            evolutionPoints = filteredPrs.map { pr in
                DataPoint.init(value: Double(pr.distance), label: "\(pr.minTime)", legend: validateCategoryInformation(pr))
            }
        case .gymnastic:
            evolutionPoints = filteredPrs.map { pr in
                DataPoint.init(value: Double(pr.maxReps), label: "\(pr.minTime)", legend: validateCategoryInformation(pr))
            }
        }
    }

    private func validateCategoryInformation(_ pr: PersonalRecord) -> Legend {
        guard let section = prSection else {
            return Legend(color: .red, label: "record.view.category.recent.title", order: 3)
        }
        
        let evolutionPr = Legend(color: .yellow, label: "record.view.category.evolution.title", order: 2)
        let lowestRecord = Legend(color: .gray, label: "record.view.category.lowest.title", order: 1)
        switch section.group {
        case .barbell:
            if measureTrackingMode == .pounds {
                let max: Int = filteredPrs.map { Int($0.poundValue) }.max() ?? 0
                let recordPound =  pr.poundValue
                if recordPound >= max {
                    return evolutionPr
                } else {
                    return lowestRecord
                }
            }
            
            let max: Int = filteredPrs.map { Int($0.kiloValue) }.max() ?? 0
            let recordPound =  pr.kiloValue
            if recordPound >= max {
                return evolutionPr
            } else {
                return lowestRecord
            }
        case .endurance:
            let max: Int = filteredPrs.map { Int($0.distance) }.max() ?? 0
            let recordPound =  pr.distance
            if recordPound >= max {
                return evolutionPr
            } else {
                return lowestRecord
            }
        case .gymnastic:
            let max: Int = filteredPrs.map { Int($0.maxReps) }.max() ?? 0
            let recordPound =  pr.maxReps
            if recordPound >= max {
                return evolutionPr
            } else {
                return lowestRecord
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            self.dataManager?.delete(record: dataManager?.recordsArray[index] ?? PersonalRecord.recordMock)
        }
    }
    
}
