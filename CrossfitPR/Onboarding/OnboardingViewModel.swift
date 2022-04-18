//
//  OnboardingViewModel.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import Foundation
import CloudKit
import os

@MainActor final class OnboardingViewModel: ObservableObject {
    private static let logger = Logger(
        subsystem: "com.douglast.mycrossfitpr",
        category: String(describing: OnboardingViewModel.self)
    )

    @Published private(set) var accountStatus: CKAccountStatus = .couldNotDetermine

    private let cloudKitService = CloudKitService()

    func fetchAccountStatus() async {
        do {
            accountStatus = try await cloudKitService.checkAccountStatus()
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
    }
}
