//
//  LoadingView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 04/12/22.
//

import SwiftUI
import Charts

struct LoadingView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ProgressView()
                .foregroundColor(.gray)
            Text("loading.view.title")
                .foregroundColor(.gray)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}



struct ContentView1: View {
    @State private var selectedIndex: Int? = nil
    @State private var numbers = (0...10).map { _ in
        Int.random(in: 0...10)
    }
    
    var body: some View {
        Chart {
            ForEach(Array(zip(numbers, numbers.indices)), id: \.0) { number, index in
                            if let selectedIndex, selectedIndex == index {
                                RectangleMark(
                                    x: .value("Index", index),
                                    yStart: .value("Value", 0),
                                    yEnd: .value("Value", number),
                                    width: 16
                                )
                                .opacity(0.4)
                            }

                            LineMark(
                                x: .value("Index", index),
                                y: .value("Value", number)
                            )
                        }
        }
        .chartOverlay { chart in
            GeometryReader { geometry in
                            Rectangle()
                                .fill(Color.clear)
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            let currentX = value.location.x - geometry[chart.plotAreaFrame].origin.x
                                            guard currentX >= 0, currentX < chart.plotAreaSize.width else {
                                                return
                                            }
                                            
                                            guard let index = chart.value(atX: currentX, as: Int.self) else {
                                                return
                                            }
                                            selectedIndex = index
                                        }
                                        .onEnded { _ in
                                            selectedIndex = nil
                                        }
                                )
                        }
        }
    }
}


struct ContentView1_Previews: PreviewProvider {
    static var previews: some View {
        ContentView1()
    }
}
