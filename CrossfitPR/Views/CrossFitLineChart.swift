//
//  CrossFitLineChart.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 12/09/22.
//
//
//import SwiftUI
//import Charts
//
//struct LinePoint: Identifiable {
//    let id = UUID()
//    let x: String
//    let y: Int
//}
//
//struct CrossFitLineChart: View {
//    
//    let points = [
//        LinePoint(x: "Set 12, 2022", y: 90),
//        LinePoint(x: "Set 13, 2022", y: 100),
//        LinePoint(x: "Set 14, 2022", y: 120),
//        LinePoint(x: "Set 15, 2022", y: 125)
//    ]
//    
//    let records = PersonalRecord.recordListMock
//    
//    let newPoints: [LinePoint] = PersonalRecord.recordListMock.map { item in
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM dd, yyyy"
//        let date = dateFormatter.string(from: item.recordDate ?? Date())
//        
//        return LinePoint(x: date, y: item.poundValue)
//    }
//    
//    
//    var body: some View {
//        Chart(newPoints) {
//            AreaMark(
//                x: .value("Date", $0.x),
//                y: .value("Weight", $0.y)
//            )
////            PointMark(
////                x: .value("Mount", "\($0.recordDate?.dateFormat ?? "")"),
////                y: .value("Value", $0.poundValue)
////            )
//        }
//    }
//}
//
//struct CrossFitLineChart_Previews: PreviewProvider {
//    static var previews: some View {
//        CrossFitLineChart()
//    }
//}
