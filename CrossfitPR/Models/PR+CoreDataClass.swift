//
//  PR+CoreDataClass.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 17/04/22.
//

import Foundation
import CoreData

@objc(PR)
public class PR: NSManagedObject {}

extension PR: Comparable {
    public static func < (lhs: PR, rhs: PR) -> Bool {
        return lhs.id == rhs.id && lhs.prName < rhs.prName
    }
}

