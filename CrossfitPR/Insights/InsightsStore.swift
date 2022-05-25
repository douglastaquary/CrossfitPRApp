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
    @Published var biggestPR: PR?
    
    private enum Keys {
        static let pro = "pro"
    }
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    private let cancellable: Cancellable
    private let defaults: UserDefaults
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }
    
    var isPro: Bool {
        set { defaults.set(newValue, forKey: Keys.pro) }
        get { defaults.bool(forKey: Keys.pro) }
    }
    
    
//    private var max: Int = 0
//    private var min: Int = 0
    let biggestPr = Legend(color: .green, label: "PR Biggest", order: 3)
//
//    @Published var biggestPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .green, label: "", order: 2))
//    @Published var lowPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .gray, label: "", order: 1))
//
//    @Published var barPoints: [DataPoint] = []
//    @Published var limit: DataPoint = DataPoint(value: 0, label: "", legend: Legend(color: .clear, label: ""))
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: PR.entity(), sortDescriptors: [], predicate: NSPredicate(format: "prName != %@", PRType.empty.rawValue))
    
    var prs: FetchedResults<PR>

//    func loadFrom(data: [PR]) {
//        max = data.map { $0.prValue }.max() ?? 0
//        min = data.map { $0.prValue }.min() ?? 0
//        barPoints = data.map { pr in
//            if pr.prValue == max {
//                self.limit = DataPoint(value: Double(self.max) , label: "\(pr.prName)", legend: biggestPr)
//            }
//            return DataPoint.init(value: Double(pr.prValue), label: "", legend: validateCategoryInformation(pr))
//        }
//    }
//
//    func validateCategoryInformation(_ pr: PR) -> Legend {
//        let biggestPr = Legend(color: .green, label: "PR Biggest", order: 3)
//        let evolutionPr = Legend(color: .yellow, label: "PR Evolution", order: 2)
//        let lowestRecord = Legend(color: .gray, label: "PR Lowest", order: 1)
//        if pr.prValue >= max {
//            return biggestPr
//        } else if pr.prValue == min {
//            return lowestRecord
//        } else {
//            return evolutionPr
//        }
//    }
//
//    func loadDetailFrom(prs: [PR]) {
//        for pr in prs {
//            if pr.prValue == max {
//                biggestPoint = DataPoint.init(value: Double(pr.prValue), label: "\(pr.prValue) lb", legend: Legend(color: .green, label: "\(pr.prName)", order: 1))
//            } else if pr.prValue == min {
//                lowPoint = DataPoint.init(value: Double(pr.prValue), label: "\(pr.prValue) lb", legend: Legend(color: .gray, label: "\(pr.prName)", order: 2))
//            }
//        }
//    }
//
    
    private func build() -> [PR] {
        let prs: [PR] = Array(Set(prs.map { $0 }))
        return prs
    }
    
    func loadGraph() {
        let max: Int = prs.map { $0.prValue }.max() ?? 0
        barPoints = prs.map { pr in
            if pr.prValue == max {
                self.limit = DataPoint(value: Double(max) , label: "\(pr.prName)", legend: biggestPr)
            }
            return DataPoint.init(value: Double(pr.prValue), label: "", legend: validateCategoryInformation(pr))
        }
    }
    
    func loadPRInfos() {
        let max: Int = prs.map { $0.prValue }.max() ?? 0
        let min: Int = prs.map { $0.prValue }.min() ?? 0
        let evolutionPRselected = prs.filter { pr in
            return pr.prValue < max && pr.prValue > min && pr.prName != biggestPRName
        }.sorted {
            $0.prValue > $1.prValue
        }.first

        evolutionPoint = DataPoint.init(value: Double(evolutionPRselected?.prValue ?? 0), label: "\(evolutionPRselected?.prValue ?? 0) lb", legend: Legend(color: .yellow, label: "\(evolutionPRselected?.prName ?? "")", order: 2))
        
        for pr in prs {
            if pr.prValue == max {
                biggestPoint = DataPoint.init(value: Double(pr.prValue), label: "\(pr.prValue) lb", legend: Legend(color: .green, label: "\(pr.prName)", order: 1))
                biggestPRName = pr.prName
                biggestPR = pr
            } else if pr.prValue == min {
                lowPoint = DataPoint.init(value: Double(pr.prValue), label: "\(pr.prValue) lb", legend: Legend(color: .gray, label: "\(pr.prName)", order: 3))
            }
        }
    }
    
    private func validateCategoryInformation(_ pr: PR) -> Legend {
        let max: Int = prs.map { $0.prValue }.max() ?? 0
        let min: Int = prs.map { $0.prValue }.min() ?? 0
        let biggestPr = Legend(color: .green, label: "PR Biggest", order: 3)
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
