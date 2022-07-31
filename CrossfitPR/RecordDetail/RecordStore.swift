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
    
    //let objectWillChange = PassthroughSubject<Void, Never>()
        
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
        if isPounds {
            return filteredPrs.map { pr in DataPoint.init(value: Double(pr.poundValue), label: "\(pr.poundValue) lb", legend: validateCategoryInformation(pr)) }
        }
        
        return filteredPrs.map { pr in DataPoint.init(value: Double(pr.kiloValue), label: "\(pr.kiloValue) kg", legend: validateCategoryInformation(pr)) }
    
    }

    var filteredPrs: [PersonalRecord] {
        if let records = dataManager?.recordsArray {
            return records.filter { $0.prName.rawValue.contains(recordType) }.sorted()
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
            evolutionPoints = filteredPrs.map { pr in DataPoint.init(value: Double(pr.poundValue), label: "", legend: validateCategoryInformation(pr))
            }
            return
        }
        evolutionPoints = filteredPrs.map { pr in DataPoint.init(value: Double(pr.kiloValue), label: "", legend: validateCategoryInformation(pr))
            
        }
    }
//
//    private func loadPRInfos() {
//        let max: Int = filteredPrs.map { $0.prValue }.max() ?? 0
//        let min: Int = filteredPrs.map { $0.prValue }.min() ?? 0
//        let evolutionPRselected = filteredPrs.filter { pr in
//            return pr.prValue < max && pr.prValue > min && pr.prName != biggestPRName
//        }.sorted {
//            $0.prValue > $1.prValue
//        }.first
//
//        evolutionPoint = DataPoint.init(value: Double(evolutionPRselected?.prValue ?? 0), label: "\(evolutionPRselected?.prValue ?? 0) lb", legend: Legend(color: .yellow, label: "\(evolutionPRselected?.prName ?? "")", order: 2))
//
//        for pr in prs {
//            if pr.prValue == max {
//                biggestPoint = DataPoint.init(value: Double(pr.prValue), label: "\(pr.prValue) lb", legend: Legend(color: .green, label: "\(pr.prName)", order: 1))
//                biggestPRName = pr.prName
//                biggestPR = pr
//            } else if pr.prValue == min {
//                lowPoint = DataPoint.init(value: Double(pr.prValue), label: "\(pr.prValue) lb", legend: Legend(color: .gray, label: "\(pr.prName)", order: 3))
//            }
//        }
//    }
//
    private func validateCategoryInformation(_ pr: PersonalRecord) -> Legend {
        let biggestPr = Legend(color: .green, label: "Most recent pr", order: 3)
        let evolutionPr = Legend(color: .yellow, label: "PR Evolution", order: 2)
        let lowestRecord = Legend(color: .gray, label: "PR Lowest", order: 1)
        
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
    
}

