//
//  PRSection.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 01/05/22.
//

import Foundation

struct PRSection: Identifiable, Hashable {
    let id: UUID = UUID()
    var name: String
    var group: RecordGroup
    var prs: [PR] = []
    
    mutating func addNewPR(_ pr: PR) {
        prs.append(pr)
    }
}


extension PRSection {
    static func < (lhs: PRSection, rhs: PRSection) -> Bool {
        return lhs.id == rhs.id && lhs.name.lowercased() == rhs.name.lowercased()
    }
}

