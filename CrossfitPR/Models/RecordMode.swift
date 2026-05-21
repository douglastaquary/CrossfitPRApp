//
//  RecordMode.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 23/06/23.
//

import Foundation

enum RecordMode: String {
    case maxWeight
    case maxRepetition
    case maxDistance
    
    var index: Int {
        switch self {
        case .maxWeight: return  0
        case .maxRepetition: return 1
        case .maxDistance: return 2
        }
    }
}
