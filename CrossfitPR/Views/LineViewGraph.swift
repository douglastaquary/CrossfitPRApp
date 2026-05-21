//
//  LineViewGraph.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 11/05/22.
//

import SwiftUI
import SwiftUICharts

struct LineViewGraph: View {
    
    @State var points: [DataPoint]
    
    var body: some View {
        VStack{
            LineChartView(dataPoints: points)
                .padding(.top)
        }
        
    }
}

struct LineViewGraph_Previews: PreviewProvider {
    static var previews: some View {
        LineViewGraph(points: [])
    }
}
