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
    
    private enum Keys {
        static let pro = "pro"
        static let enabledSortedByValue = "enabled_sorted_by_value"
    }
    
    @Published var evolutionPoints: [DataPoint] = []
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    private let cancellable: Cancellable
    private let defaults: UserDefaults
    private var records: FetchedResults<PR>
    private var recordType: String = ""
    private var prEvolution = Legend(color: .yellow, label: "PR evolution", order: 3)
    private var mostRecent = Legend(color: .green, label: "Most recent pr", order: 4)
    private var lowestPR = Legend(color: .gray, label: "Lowest pr", order: 2)
    
    init(records: FetchedResults<PR>, recordType: String = "", defaults: UserDefaults = .standard) {
        self.records = records
        self.recordType = recordType
        self.defaults = defaults
        
        defaults.register(defaults: [
            Keys.enabledSortedByValue: false,
        ])

        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
        
    }
    
    var isPro: Bool {
        set { defaults.set(newValue, forKey: Keys.pro) }
        get { defaults.bool(forKey: Keys.pro) }
    }
    
    var record: PR {
        getMaxRecord(prs: filteredPrs)
    }
    
    var points: [DataPoint] {
        filteredPrs.map { pr in DataPoint.init(value: Double(pr.prValue), label: "\(pr.prValue) lb", legend: validateCategoryInformation(pr)) }
    }
    
    var filteredPrs: [PR] {
        records.filter { $0.prName.contains(recordType) }.sorted()
    }
    
    private func getMaxRecord(prs: [PR]) -> PR {
        let max: Int = prs.map { $0.prValue }.max() ?? 0
        let biggestPR = prs.filter { $0.prValue == max }.first ?? PersistenceController.emptyRecord
        return biggestPR
    }
    
    private func getMinRecord(prs: [PR]) -> PR {
        let min: Int = prs.map { $0.prValue }.min() ?? 0
        let biggestPr = prs.filter { $0.prValue == min }.first ?? PersistenceController.emptyRecord
        return biggestPr
    }
    
    func loadGraph() {
        evolutionPoints = filteredPrs.map { pr in DataPoint.init(value: Double(pr.prValue), label: "", legend: validateCategoryInformation(pr)) }
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
    private func validateCategoryInformation(_ pr: PR) -> Legend {
        let max: Int = filteredPrs.map { $0.prValue }.max() ?? 0
        let min: Int = filteredPrs.map { $0.prValue }.min() ?? 0
        let biggestPr = Legend(color: .green, label: "Most recent pr", order: 3)
        let evolutionPr = Legend(color: .yellow, label: "PR Evolution", order: 2)
        let lowestRecord = Legend(color: .gray, label: "PR Lowest", order: 1)
        if pr.prValue >= max {
            return biggestPr
        } else if pr.prValue == min {
            return lowestRecord
        } else {
            return evolutionPr
        }
    }
    
}
