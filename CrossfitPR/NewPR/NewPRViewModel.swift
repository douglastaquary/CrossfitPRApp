//
//  NewPRViewModel.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import Foundation
import os

@MainActor final class NewPRViewModel: ObservableObject {

    let storage = CodableStorage(storage: DiskStorage(path: URL(fileURLWithPath: NSTemporaryDirectory())))
    private static let logger = Logger(
        subsystem: "com.douglast.mycrossfitpr",
        category: String(describing: NewPRViewModel.self)
    )

    let exercise = Exercise(name: .airSquat)
    
    @Published var personalRecord: PersonalRecord = .init(
        activity: Exercise(name: .airSquat),
        date: .now,
        pounds: 160,
        goal: 16 * 3600
    )

    @Published var activities: [String] = [
        "AIR SQUAT (AS)", "BACK SQUAT", "BAR MUSCLE-UP", "BENCH PRESS (Supino)",
        "BOX JUMP (BJ)", "BURPEE", "BURPEE OVER THE BAR", "BUTTERFLY",
        "CHEST TO BAR (CTB/C2B)", "CLEAN", "CLEAN & JERK"
    ]
    
    @Published private(set) var isSaving = false

    private let cloudKitService = CloudKitService()

    func save() {
        isSaving = true
        
        let history = History(prs: [personalRecord])

        do {
            try storage.save(history, for: "history")
            //try await cloudKitService.save(personalRecord.record)
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }

        isSaving = false
    }
}
