//
//  Category.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 22/05/22.
//

import Foundation

struct Category: Identifiable, Comparable, Hashable {
    let id = UUID()
    var title: String
}

extension Category {
    static func < (lhs: Category, rhs: Category) -> Bool {
        lhs.title < rhs.title
    }
}
