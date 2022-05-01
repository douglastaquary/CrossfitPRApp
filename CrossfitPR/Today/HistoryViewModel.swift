//
//  HistoryViewModel.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 03/04/22.
//

import Foundation
import os

@MainActor final class HistoryViewModel: ObservableObject {

    //let disk = DiskStorage(path: URL(fileURLWithPath: NSTemporaryDirectory()))
    let storage = CodableStorage(storage: DiskStorage(path: URL(fileURLWithPath: NSTemporaryDirectory())))
    
    private static let logger = Logger(
        subsystem: "com.aaplab.crossfitprapp",
        category: String(describing: HistoryViewModel.self)
    )

    @Published var interval: DateInterval = .init(
        start: .now.addingTimeInterval(-30 * 34 * 3600),
        end: .now
    )

    @Published private(set) var histories: [History] = []
    @Published private(set) var isLoading = false

    private let cloudKitService = CloudKitService()

    func fetch() {
        isLoading = true

        do {
            histories = try storage.fetch(for: "history")
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }

        isLoading = false
    }
}
