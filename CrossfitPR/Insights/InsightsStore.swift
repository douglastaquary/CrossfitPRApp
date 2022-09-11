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
        loadPRInfos()
    }

    private func loadGraph() {
        if measureTrackingMode == .pounds {
            let max: Int = records.map { $0.poundValue }.max() ?? 0
            barPoints = records.map { pr in
                if pr.poundValue == max {
                    self.limit = DataPoint(value: Double(max) , label: "\(pr.prName.rawValue)", legend: biggestPr)
                }
                return DataPoint.init(value: Double(pr.poundValue), label: "", legend: validateCategoryInformationPounds(pr))
            }
        } else {
            let max: Int = records.map { $0.kiloValue }.max() ?? 0
            barPoints = records.map { pr in
                if pr.kiloValue == max {
                    self.limit = DataPoint(value: Double(max) , label: "\(pr.prName.rawValue)", legend: biggestPr)
                }
                return DataPoint.init(value: Double(pr.kiloValue), label: "", legend: validateCategoryInformationKilos(pr))
            }
        }

    }
    
    func loadPRInfos() {
        loadGraph()
        if measureTrackingMode == .pounds {
            let max: Int = records.map { $0.poundValue }.max() ?? 0
            let min: Int = records.map { $0.poundValue }.min() ?? 0
            let evolutionPRselected = records.filter { pr in
                return pr.poundValue < max && pr.poundValue > min && pr.prName.rawValue != biggestPRName
            }.sorted {
                $0.poundValue > $1.poundValue
            }.first
            
            evolutionPoint = DataPoint.init(
                value: Double(evolutionPRselected?.poundValue ?? 0),
                label: "\(evolutionPRselected?.poundValue ?? 0) lb",
                legend: Legend(color: .yellow, label: "\(evolutionPRselected?.prName.rawValue ?? "")", order: 2)
            )
            for pr in records {
                if pr.poundValue == max {
                    biggestPoint = DataPoint.init(
                        value: Double(pr.poundValue),
                        label: "\(pr.poundValue) lb",
                        legend: Legend(color: .green, label: "\(pr.prName.rawValue)", order: 1)
                    )
                    biggestPRName = pr.prName.rawValue
                    biggestPR = pr
                } else if pr.poundValue == min {
                    lowPoint = DataPoint.init(
                        value: Double(pr.poundValue),
                        label: "\(pr.poundValue) lb",
                        legend: Legend(color: .gray, label: "\(pr.prName.rawValue)", order: 3)
                    )
                }
            }
        } else {
            let max: Int = records.map { $0.kiloValue }.max() ?? 0
            let min: Int = records.map { $0.kiloValue }.min() ?? 0
            let evolutionPRselected = records.filter { pr in
                return pr.kiloValue < max && pr.kiloValue > min && pr.prName.rawValue != biggestPRName
            }.sorted {
                $0.kiloValue > $1.kiloValue
            }.first
            
            evolutionPoint = DataPoint.init(
                value: Double(evolutionPRselected?.kiloValue ?? 0),
                label: "\(evolutionPRselected?.kiloValue ?? 0) kg",
                legend: Legend(color: .yellow, label: "\(evolutionPRselected?.prName.rawValue ?? "")", order: 2)
            )
            for pr in records {
                if pr.kiloValue == max {
                    biggestPoint = DataPoint.init(
                        value: Double(pr.kiloValue),
                        label: "\(pr.kiloValue) kg",
                        legend: Legend(color: .green, label: "\(pr.prName.rawValue)", order: 1)
                    )
                    biggestPRName = pr.prName.rawValue
                    biggestPR = pr
                } else if pr.kiloValue == min {
                    lowPoint = DataPoint.init(
                        value: Double(pr.kiloValue),
                        label: "\(pr.kiloValue) kg",
                        legend: Legend(color: .gray, label: "\(pr.prName.rawValue)", order: 3)
                    )
                }
            }
        }
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
