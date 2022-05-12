//
//  RecordStore.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 11/05/22.
//

import Foundation
import os

@MainActor final class RecordStore: ObservableObject {
    private static let logger = Logger(
        subsystem: "com.aaplab.crossfitprapp",
        category: String(describing: RecordStore.self)
    )
    @Published var prs: [PR] = []
    
    func orderByValue() {
        prs.sort { $0.prValue < $1.prValue }
    }
    
    func orderFrom(textFilter: String) -> [PR] {
        return prs.filter { $0.prName == textFilter }
    }

}
