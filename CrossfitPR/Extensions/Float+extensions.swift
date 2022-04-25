//
//  Float+extensions.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 24/04/22.
//

import Foundation

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
