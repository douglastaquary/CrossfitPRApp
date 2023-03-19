//
//  SimpleBarProgressView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 04/12/22.
//

import SwiftUI

struct SimpleBarProgressView: View {
    let progress: CGFloat
    
    private let bgColor = Color.green.opacity(0.2)
    private let fillColor = Color.green
    
    var body: some View {
        VStack {
            GeometryReader { bounds in
                Capsule(style: .circular)
                    .fill(bgColor)
                    .overlay {
                        HStack {
                            Capsule(style: .circular)
                                .fill(fillColor)
                                .frame(width: bounds.size.width * progress)
                            
                            Spacer(minLength: 0)
                        }
                    }
                    .clipShape(Capsule(style: .circular))
            }
            .frame(height: 15)
        }
    }
}


struct SimpleBarProgressView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleBarProgressView(progress: 0.1)
    }
    
}

struct RankingView: View {
    @EnvironmentObject var viewModel: RankingViewModel
    @State var capsuleBackgroundColor = Color.green.opacity(0.2)
    @State var capsuleFillColor = Color.green
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Text(viewModel.record.prName).font(.headline)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(viewModel.marketValue).font(.headline)
                    HStack {
                        Image(systemName: "arrow.up.forward").foregroundColor(.green)
                        Text("\(viewModel.percentageEvolutionValue)")
                    }
                }
            }
            
            GeometryReader { bounds in
                Capsule(style: .circular)
                    .fill(viewModel.legendBackground)
                    .overlay {
                        HStack {
                            Capsule(style: .circular)
                                .fill(viewModel.legend)
                                .frame(width: bounds.size.width * CGFloat(viewModel.marketValueDouble/100.0))
                            
                            Spacer(minLength: 0)
                        }
                    }
                    .clipShape(Capsule(style: .circular))
            }
            .frame(height: 15)
            
            HStack {
                Text("ranking.screen.evolution.percentage \(viewModel.percentageEvolutionValue)")
                    .font(.caption)
                    .lineLimit(3)
                    .foregroundColor(.secondary)
            }
        }
        
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView()
            .environmentObject(RankingViewModel(record: PersonalRecord.recordMock, measure: .pounds, legend: .yellow))
    }
}



final class RankingViewModel: ObservableObject {

    @Published var record: PersonalRecord
    @Published var marketValue: String = ""
    @Published var percentageEvolutionValue: String = ""
    @Published var measureValueText: String = ""
    @Published var marketValueDouble: Double = 0.0
    @Published var measure: MeasureTrackingMode
    @Published var legendText: String = ""
    @Published var legend: Color = .green
    @Published var legendBackground: Color = .green
    
    init(record: PersonalRecord, measure: MeasureTrackingMode, percentageEvolutionValue: String = "80", legend: Color = .green) {
        self.record = record
        self.measure = measure
        self.percentageEvolutionValue = "\(percentageEvolutionValue)%"
        self.legend = legend
        self.legendBackground = legend.opacity(0.2)
        setupMarketValue()
    }
    
    private func setupMarketValue() {
        if measure == MeasureTrackingMode.kilos {
            marketValue = record.marketTexts.value.kilos
            marketValueDouble = Double(record.kiloValue)
        } else if measure == MeasureTrackingMode.pounds {
            marketValue = record.marketTexts.value.pound
            marketValueDouble = Double(record.poundValue)
        } else if record.group == .gymnastic {
            marketValueDouble = Double(record.maxReps)
            marketValue = "\(record.maxReps)"
        } else if record.group == .endurance {
            marketValueDouble = Double(record.distance)
            marketValue = "\(record.distance)"
        }
    }
}


