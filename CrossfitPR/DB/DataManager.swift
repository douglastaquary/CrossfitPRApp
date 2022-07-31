//
//  DataManager.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 30/07/22.
//


import Foundation
import CoreData
import OrderedCollections

enum DataManagerType {
    case normal, preview, testing
}

class DataManager: NSObject, ObservableObject {
    
    static let shared = DataManager(type: .normal)
    static let preview = DataManager(type: .preview)
    static let testing = DataManager(type: .testing)
    
    @Published var records: OrderedDictionary<UUID, PersonalRecord> = [:]
    
    var recordsArray: [PersonalRecord] {
        Array(records.values)
    }
    
    fileprivate var managedObjectContext: NSManagedObjectContext
    private let recordsFRC: NSFetchedResultsController<PR>
    
    private init(type: DataManagerType) {
        switch type {
        case .normal:
            let persistentStore = PersistenceStore()
            self.managedObjectContext = persistentStore.context
        case .preview:
            let persistentStore = PersistenceStore(inMemory: true)
            self.managedObjectContext = persistentStore.context
            for i in 0..<10 {
                let newPR = PR(context: managedObjectContext)
                newPR.prName = "\(PRType.allCases[i])"
                newPR.recordDate = Date()
                newPR.id = UUID()
            }
            try? self.managedObjectContext.save()
        case .testing:
            let persistentStore = PersistenceStore(inMemory: true)
            self.managedObjectContext = persistentStore.context
        }
        
        let recordFR: NSFetchRequest<PR> = PR.fetchRequest()
        recordFR.sortDescriptors = []
        recordFR.predicate = NSPredicate(format: "prName != %@", PRType.empty.rawValue)
        recordsFRC = NSFetchedResultsController(
            fetchRequest: recordFR,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
        
        // Initial fetch to populate records array
        recordsFRC.delegate = self
        try? recordsFRC.performFetch()
        if let newRecords = recordsFRC.fetchedObjects {
            self.records = OrderedDictionary(uniqueKeysWithValues: newRecords.map({ ($0.id!, PersonalRecord(record: $0)) }))
        }
    }
    
    func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
}

extension DataManager: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newRecords = controller.fetchedObjects as? [PR] {
            self.records = OrderedDictionary(uniqueKeysWithValues: newRecords.map({ ($0.id!, PersonalRecord(record: $0)) }))
        }
    }
    
    private func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try managedObjectContext.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchRecords(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        if let predicate = predicate {
            recordsFRC.fetchRequest.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            recordsFRC.fetchRequest.sortDescriptors = sortDescriptors
        }
        try? recordsFRC.performFetch()
        if let newRecords = recordsFRC.fetchedObjects {
            self.records = OrderedDictionary(uniqueKeysWithValues: newRecords.map({ ($0.id!, PersonalRecord(record: $0)) }))
        }
    }
    
    func resetFetch() {
        recordsFRC.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "recordDate", ascending: true)]
        //recordsFRC.fetchRequest.predicate = nil
        try? recordsFRC.performFetch()
        if let newRecords = recordsFRC.fetchedObjects {
            self.records = OrderedDictionary(uniqueKeysWithValues: newRecords.map({ ($0.id!, PersonalRecord(record: $0)) }))
        }
    }

}

//MARK: - PersonalRecord Methods
extension PersonalRecord {
    fileprivate init(record: PR) {
        self.id = record.id ?? UUID()
        self.kiloValue = Int(record.kiloValue)
        self.poundValue = Int(record.poundValue)
        self.distance = Int(record.distance)
        self.recordDate = record.recordDate ?? Date()
        self.prName = PRType(rawValue: record.prName) ?? .empty
        self.percentage = record.percentage
        self.category = CrossfitLevel(rawValue: record.category ?? "") ?? .rx
        self.recordMode = RecordMode(rawValue: record.recordMode ?? "") ?? .maxWeight
        self.maxReps = Int(record.maxReps)
        self.minTime = Int(record.minTime)
        self.comments = record.comments
    }
}

extension DataManager {
    
    func saveNewRecord(record: PersonalRecord) {
//        let predicate = NSPredicate(format: "id = %@", record.id as CVarArg)
//        let result = fetchFirst(PR.self, predicate: predicate)
//        switch result {
//        case .success(_):
//            recordMO(from: record)
//        case .failure(_):
//            print("Couldn't fetch PR to save")
//        }
        recordMO(from: record)
        saveData()
    }
    
    func updateAndSave(record: PersonalRecord) {
        let predicate = NSPredicate(format: "id = %@", record.id as CVarArg)
        let result = fetchFirst(PR.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let recordMO = managedObject {
                update(recordMO: recordMO, from: record)
            } else {
                recordMO(from: record)
            }
        case .failure(_):
            print("Couldn't fetch PR to save")
        }
        saveData()
    }
    
    func delete(record: PersonalRecord) {
        let predicate = NSPredicate(format: "id = %@", record.id as CVarArg)
        let result = fetchFirst(PR.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let recordMo = managedObject {
                managedObjectContext.delete(recordMo)
            }
        case .failure(_):
            print("Couldn't fetch PR to save")
        }
        saveData()
    }
    
    func getPersonalRecord(with id: UUID) -> PersonalRecord? {
        return records[id]
    }
    
    private func recordMO(from pr: PersonalRecord) {
        let recordMO = PR(context: managedObjectContext)
        recordMO.id = pr.id
        recordMO.prName = pr.prName.rawValue
        recordMO.category = pr.category?.rawValue
        recordMO.recordMode = pr.recordMode?.rawValue
        recordMO.kiloValue = Int32(pr.kiloValue)
        recordMO.poundValue = Int32(pr.poundValue)
        recordMO.minTime = Int32(pr.minTime)
        recordMO.maxReps = Int32(pr.maxReps)
        recordMO.distance = Int32(pr.distance)
        recordMO.percentage = pr.percentage
        recordMO.recordDate = pr.recordDate
        recordMO.comments = pr.comments
        //update(recordMO: recordMO, from: pr)
    }
    
    private func update(recordMO: PR, from record: PersonalRecord) {
        recordMO.id = record.id
        recordMO.prName = record.prName.rawValue
        recordMO.category = record.category?.rawValue
        recordMO.recordMode = record.recordMode?.rawValue
        recordMO.kiloValue = Int32(record.kiloValue)
        recordMO.poundValue = Int32(record.poundValue)
        recordMO.minTime = Int32(record.minTime)
        recordMO.maxReps = Int32(record.maxReps)
        recordMO.distance = Int32(record.distance)
        recordMO.percentage = record.percentage
        recordMO.recordDate = record.recordDate
        recordMO.comments = record.comments
    }
    
    ///Get's the PR that corresponds to the PersonalRecord. If no PR is found, returns nil.
    private func getRecordMO(from pr: PersonalRecord?) -> PR? {
        guard let pr = pr else { return nil }
        let predicate = NSPredicate(format: "id = %@", pr.id as CVarArg)
        let result = fetchFirst(PR.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let recordMO = managedObject {
                return recordMO
            } else {
                return nil
            }
        case .failure(_):
            return nil
        }
        
    }
}

