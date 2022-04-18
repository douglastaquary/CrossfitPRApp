//
//  LaunchView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 04/04/22.
//

import SwiftUI

public enum Route: String {
    case onBoardingView = "onBoardingView"
    case prHistoriesListView = "PRHistoriesListView"
    case newPR = "NewPRRecordView"
}

struct LaunchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewlaunch: ViewLaunch

    var body: some View {
        VStack {
            if viewlaunch.currentPage == Route.onBoardingView.rawValue {
                OnboardingView()
            } else if viewlaunch.currentPage == Route.prHistoriesListView.rawValue {
                RootView()
                    .environment(\.managedObjectContext, viewContext)
            } else if viewlaunch.currentPage == Route.newPR.rawValue {
                NewPRRecordView()
            }
        }
    }
}

class ViewLaunch: ObservableObject {

    init() {
        if !UserDefaults.standard.bool(forKey: "LaunchBefore") {
            currentPage = Route.onBoardingView.rawValue
        } else {
            currentPage = Route.prHistoriesListView.rawValue
        }
    }
    @Published var currentPage: String
}
