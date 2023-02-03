//
//  MyRecordsView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 17/12/22.
//

import SwiftUI

struct MyRecordsView: View {
    @State var showNewPRView = false
    @State var isEmpty = false
    @EnvironmentObject var store: RecordStore
    @Binding var searchText: String
    
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
                        RecordDetail(prName: section.name)
                            .environmentObject(RecordStore(prSection: section))
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
                        NewRecordView()
                    }
                }
            }
        }
    }
}

struct MyRecordsView_Previews: PreviewProvider {
    static var previews: some View {
        MyRecordsView(searchText: .constant("snatch"))
    }
}
