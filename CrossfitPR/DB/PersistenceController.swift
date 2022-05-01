//
//  PersistenceController.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 17/04/22.
//

import Foundation
import CoreData

struct PersistenceController {
    // A singleton for our entire app to use
    static let shared = PersistenceController()
    
    static var prMock: PR = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let pr = PR(context: viewContext)
        pr.prName = "AIR SQUAT (AS)"
        pr.recordValue = 100
        pr.recordDate = .now
        pr.percentage = 0.60
        pr.id = UUID()
        return pr
    }()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let pr = PR(context: viewContext)
            pr.prName = "AIR SQUAT (AS)"
            pr.recordValue = 100
            pr.recordDate = .now
            pr.percentage = 0.28
            pr.id = UUID()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    // Storage for Core Data
    let container: NSPersistentContainer

    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CrossfitPR")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
