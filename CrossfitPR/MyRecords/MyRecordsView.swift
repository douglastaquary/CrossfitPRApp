//
//  MyRecordsView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 17/12/22.
//

import SwiftUI

struct MyRecordsView: View {
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var store: RecordDetailViewModel
    @State var showNewPRView = false
    @State var isEmpty = false
    @State var searchText: String = ""
    let appDefaults: UserDefaults
    
    init(appDefaults: UserDefaults) {
        self.appDefaults = appDefaults
        
    }
    
    var body: some View {
        NavigationStack {
            if !store.sections.isEmpty {
                ScrollViewReader { scrollView in
                    ScrollView {
                        ForEach(store.sections, id: \.id) { section in
                            NavigationLink(value: section) {
                                CategoryItemView(title: section.name, group: section.group.rawValue)
                            }
                        }
                    }
                    .navigationBarTitle(LocalizedStringKey("My Records"), displayMode: .large)
                    .searchable(text: self.$searchText, prompt: LocalizedStringKey("category.search.descript"))
                    .onAppear {
                        UINavigationBar.appearance().tintColor = .green
                    }
                    .navigationDestination(for: PRSection.self) { section in
                        RecordDetailView(prName: section.name)
                            .environmentObject(RecordDetailViewModel(prSection: section))
                            .environmentObject(SettingsStore(defaults: self.appDefaults))
                    }
                }
                
            } else {
                VStack{
                    Text("Começe agora mesmo\nadicionando um novo record.")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 64)
                    OpaqueActionButton(
                        imageName: "figure.cross.training",
                        title: "Add new record",
                        completion: { self.showNewPRView.toggle() }
                    ).sheet(isPresented: $showNewPRView) {
                        NewRecordView(viewModel: NewRecordViewModel())
                    }
                }
            }
        }
    }
}

struct MyRecordsView_Previews: PreviewProvider {
    static var previews: some View {
        MyRecordsView(appDefaults: .standard)
    }
}
