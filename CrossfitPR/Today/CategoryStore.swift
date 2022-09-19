//
//  CategoryStore.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 28/04/22.
//

import Foundation
import ActivityKit
import SwiftUI
import Combine
import os

@MainActor final class CategoryStore: ObservableObject {
    private static let logger = Logger(
        subsystem: "com.dabtlab.crossfitprapp",
        category: String(describing: CategoryStore.self)
    )
    private var _activity: Any?
    
#if os(iOS)
    @available(iOS 16.1, *)
    private var activity: Activity<CrossfitAttributes>? {
        _activity as? Activity<CrossfitAttributes>
    }
#endif
    
    @Published var searchText: String = ""
    
    private var categories: [Category] {
        Category.list
    }
    
    var filteredCategories: [Category] {
        categories.filter {
            searchText.isEmpty ? true : $0.title.contains(searchText)
        }.sorted()
    }
    
    
#if os(iOS)
    @available(iOS 16.1, *)
    func startLiveActivity() {
        if !ActivityAuthorizationInfo().areActivitiesEnabled {
            print("Not available")
            return
        }
        
        do {
            _ = try Activity<CrossfitAttributes>.request(
                attributes: CrossfitAttributes(inputValue: "Hello Activity 2"),
                contentState: CrossfitAttributes.ContentState(value: "HEllo LIve Activity"),
                pushType: nil)
            print("Starting live activity")
        } catch (let error) {
            print("Error requesting live activity \(error.localizedDescription)")
        }
    }
#endif
    
#if os(iOS)
    @available(iOS 16.1, *)
    
    func checkActiveActivities() async {
        for await activity in Activity<CrossfitAttributes>.activityUpdates {
            print("Activity detais: \(activity.attributes)")
        }
    }
#endif
    
}
