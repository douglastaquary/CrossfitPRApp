//
//  InsightsStore.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 25/04/22.
//

import Foundation
import SwiftUI
import CoreData
import SwiftUICharts

final class InsightsStore: ObservableObject {
    private var max: Int = 0
    private var min: Int = 0
    let biggestPr = Legend(color: .green, label: "PR Biggest", order: 3)

    @Published var biggestPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .green, label: "", order: 2))
    @Published var lowPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .gray, label: "", order: 1))
    
    @Published var barPoints: [DataPoint] = []
    @Published var limit: DataPoint = DataPoint(value: 0, label: "", legend: Legend(color: .clear, label: ""))

    func loadFrom(data: [PR]) {
        max = data.map { $0.prValue }.max() ?? 0
        min = data.map { $0.prValue }.min() ?? 0
        barPoints = data.map { pr in
            if pr.prValue == max {
                self.limit = DataPoint(value: Double(self.max) , label: "\(pr.prName)", legend: biggestPr)
            }
            return DataPoint.init(value: Double(pr.prValue), label: "", legend: validateCategoryInformation(pr))
        }
    }
    
    func validateCategoryInformation(_ pr: PR) -> Legend {
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
    
    func loadDetailFrom(prs: [PR]) {
        for pr in prs {
            if pr.prValue == max {
                biggestPoint = DataPoint.init(value: Double(pr.prValue), label: "\(pr.prValue) lb", legend: Legend(color: .green, label: "\(pr.prName)", order: 1))
            } else if pr.prValue == min {
                lowPoint = DataPoint.init(value: Double(pr.prValue), label: "\(pr.prValue) lb", legend: Legend(color: .gray, label: "\(pr.prName)", order: 2))
            }
        }
    }
    
}
