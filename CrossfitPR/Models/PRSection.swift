//
//  PRSection.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 01/05/22.
//

import Foundation

struct PRSection: Identifiable {
    let id: UUID = UUID()
    var name: String
    var prs: [PR]
    
    mutating func addNewPR(_ pr: PR) {
        prs.append(pr)
    }
}

