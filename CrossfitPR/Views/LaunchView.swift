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
    @EnvironmentObject var viewlaunch: ViewLaunch
    @ObservedObject var monitor = NetworkMonitor()
    @State private var showAlertSheet = false
    @ObservedObject var viewModel: CrossfitPRViewModel
    @State private var accountStatusAlertShown = false
    @Environment(\.dismiss) var dismiss
    
    private let storeKitService: StoreKitManager
    
    init(storeKitManager: StoreKitManager, viewModel: CrossfitPRViewModel) {
        self.viewModel = viewModel
        self.storeKitService = storeKitManager
    }
    
    var body: some View {
        VStack {
            if !monitor.isConnected {
                //No Internet Connection
                VStack {
                    Text(LocalizedStringKey("CrossFitPR"))
                        .fontWeight(.heavy)
                        .font(.system(size: 36))
                        .frame(width: 300, alignment: .leading)
                    HViewImageAndText(
                        image: monitor.isConnected ? "wifi" : "wifi.slash",
                        imageColor: .green,
                        title: monitor.isConnected ? "Connected!" : "Not connected!",
                        description: monitor.isConnected ? "The network request can be performed" : "Please enable Wifi or Celular data"
                    )
                    Spacer()
                    Button("Perform network request") {
                        self.showAlertSheet = true
                    }
                    .buttonStyle(FilledButton(widthSizeEnabled: true))
                }
                .padding()
                .alert(isPresented: $showAlertSheet, content: {
                    if monitor.isConnected {
                        return Alert(title: Text("Success!"), message: Text("The network request can be performed"), dismissButton: .default(Text("OK")))
                    }
                    return Alert(title: Text("No Internet Connection"), message: Text("Please enable Wifi or Celluar data"), dismissButton: .default(Text("Cancel")))
                })
            } else {
                if viewlaunch.currentPage == Route.onBoardingView.rawValue {
                    OnboardingView()
                } else if viewlaunch.currentPage == Route.prHistoriesListView.rawValue {
                    RootView()
                        .onAppear {
                            Task {
                                await viewModel.fetchAccountStatus()
                                if viewModel.accountStatus != .available {
                                    accountStatusAlertShown = true
                                } else {
                                    //viewModel.updatePurchases()
                                    dismiss()
                                }
                            }
                        }
                        .environment(\.storeKitManager, self.storeKitService)
                        .alert(isPresented: $accountStatusAlertShown) {
                            Alert(
                                title: Text("onboarding.alert.icloud.account.title"),
                                message: Text("onboarding.alert.icloud.account.message"),
                                dismissButton: .default(Text("onboarding.alert.cancel.button.title")) {
                                    Task {
                                        await viewModel.fetchAccountStatus()
                                        if viewModel.accountStatus != .available {
                                            accountStatusAlertShown = true
                                        } else {
                                            Task {
                                                viewModel.updatePurchases()
                                                dismiss()
                                            }
                                        }
                                    }
                                }
                            )
                        }
                }
                
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
