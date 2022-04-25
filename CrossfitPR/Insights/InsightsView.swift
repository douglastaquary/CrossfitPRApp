//
//  PRDetailView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 04/04/22.
//

import SwiftUI

struct InsightsView: View {
    let bars: [Bar]
    @State private var favoriteOption = "Day"
    var times = ["Day", "Week", "Month"]
    
    var body: some View {
        Form {
            Section {
                Group {
                    VStack(spacing: 12) {
                        Picker("", selection: $favoriteOption) {
                            ForEach(times, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding([.top], 18)
                    
                    if bars.isEmpty {
                        Text("There is no data to display chart...")
                    } else {
                        VStack {
                            BarChartView(bars: bars)
                        }
                        .frame(height: 200)
                    }
                }
            }
            Section("PR informations") {
                HSubtitleView(title: "biggest pr", subtitle: "160 lb")
                HSubtitleView(title: "percentage pr", subtitle: "70 %")
            }
        }
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView(bars: Crossfit.barsMock)
    }
}

struct Legend: Hashable {
    let color: Color
    let label: String
}

struct Bar: Identifiable {
    let id: UUID
    let value: Double
    let label: String
    let legend: Legend
}

struct BarsView: View {
    let bars: [Bar]
    let max: Double

    init(bars: [Bar]) {
        self.bars = bars
        self.max = bars.map { $0.value }.max() ?? 0
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(self.bars) { bar in
                    Capsule()
                        .fill(bar.legend.color)
                        .frame(height: CGFloat(bar.value) / CGFloat(self.max) * geometry.size.height)
                        .overlay(Rectangle().stroke(Color.white))
                        .accessibility(label: Text(bar.label))
                        .accessibility(value: Text(bar.legend.label))
                }
            }
        }
    }
}

struct LegendView: View {
    private let legends: [Legend]

    init(bars: [Bar]) {
        legends = Array(Set(bars.map { $0.legend }))
    }

    var body: some View {
        HStack(alignment: .center) {
            ForEach(legends, id: \.self) { legend in
                VStack(alignment: .center) {
                    Circle()
                        .fill(legend.color)
                        .frame(width: 16, height: 16)
                    Text(legend.label)
                        .font(.subheadline)
                        .lineLimit(nil)
                }
            }
        }
    }
}


struct BarChartView: View {
    let bars: [Bar]

    var body: some View {
        Group {
            if bars.isEmpty {
                Text("There is no data to display chart...")
            } else {
                VStack {
                    BarsView(bars: bars)
                    LabelsView(bars: bars)
                    LegendView(bars: bars)
                        .padding()
                        .accessibility(hidden: true)
                }
                
            }
        }
    }
}

struct LabelsView: View {
    var labelsCount: Int = 0
    var prs: [String] = []
    
    init(bars: [Bar]) {
        prs = Array(Set(bars.map { $0.label }))
        labelsCount = prs.count
    }

    private var threshold: Int {
        let threshold = prs.count / labelsCount
        return threshold == 0 ? 1 : threshold
    }
    
    var body: some View {
        HStack {
            ForEach(0..<prs.count, id: \.self) { index in
                Group {
                    if index % self.threshold == 0 {
                        Spacer()
                        Text(self.prs[index])
                            .font(.caption)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(bars: Crossfit.barsMock)
    }
}

struct HSubtitleView: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(subtitle)
                .bold()
        }
    }
}
