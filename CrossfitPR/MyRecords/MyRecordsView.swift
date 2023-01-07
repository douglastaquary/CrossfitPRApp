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
    @State var exercises: [Category]
    @Binding var searchText: String
    
    var body: some View {
        NavigationStack {
            
            if !exercises.isEmpty {
                ScrollViewReader { scrollView in
                    ScrollView {
                        ForEach(exercises, id: \.id) { exercise in
                            NavigationLink(value: exercise) {
                                CategoryItemView(title: exercise.title, group: exercise.group.rawValue)
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: { self.showNewPRView.toggle() }) {
                            Image(systemName: "plus.circle")
                                .font(.headline)
                                .foregroundColor(.green)
                                .accessibility(label: Text("add new record"))
                        }.sheet(isPresented: $showNewPRView) {
                            NewRecordView()
                        }
                    }
                }
                .navigationBarTitle(LocalizedStringKey("screen.category.title"), displayMode: .large)
                .searchable(text: self.$searchText, prompt: LocalizedStringKey("category.search.descript"))
                .onAppear {
                    UINavigationBar.appearance().tintColor = .green
                }
                .navigationDestination(for: Category.self) { category in
                    
                    NewRecordView()
//                    RecordDetail(prName: category.title)
//                        .environmentObject(RecordStore(recordCategory: category))
                }
                
            } else {
                
                VStack{
                    Text("Você ainda não\ntem nenhum record gravado.\n\nComeçe agora mesmo\nadicionando um novo record.")
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
        MyRecordsView(exercises: [], searchText: .constant("snatch"))
    }
}
