//
//  NewPRRecordView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import SwiftUI
import CoreData

enum RecordMode: String {
    case maxWeight
    case maxRepetition
    case maxDistance
}

struct NewRecordView: View {

    @StateObject private var viewModel = NewRecordViewModel()
    
    @State private var commentsText: String = ""
    @State private var selectedCategory: Int = 0
    @State private var selectedCategoryItem: Int = 0
    @State private var selectedPercentage: Int = 10
    @State private var selectedInitialPounds: Int = 10
    @State private var selectedMaxReps: Int = 0
    @State private var selectedMinTime: Int = 0
    @State private var selectedDistance: Int = 10
    
    @Environment(\.presentationMode) var presentation
    
    let onCommit: (() -> Void) = {}
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Record")) {
                    CategoryView(categoriesNames: viewModel.crossfitLevelList, selectedCategory: $viewModel.selectedCategoryItem)
                    Picker(selection: $viewModel.selectedCategory, label: Text("Crossfit PR").foregroundColor(.secondary)) {
                        ForEach(0..<viewModel.personalRecordTypeList.count, id: \.self) {
                            Text(viewModel.personalRecordTypeList[$0].title)
                        }
                    }
                    .foregroundColor(.primary)
                    .padding(.bottom, 12)
                }
                
                Section(header: Text("newRecord.screen.section.personal.title")) {
                    Toggle(isOn: $viewModel.isMaxRepetitions) {
                        Text("newRecord.screen.toggle.maxreps.title")
                    }
                    Toggle(isOn: $viewModel.isMaxDistance) {
                        Text("newRecord.screen.toggle.mintime.title")
                    }
                }
                if viewModel.isMaxRepetitions {
                    Section(header: Text("newRecord.screen.toggle.maxrep.title")) {
                        Picker(selection: $viewModel.selectedMaxReps, label: Text("newRecord.screen.picker.repetition.title").foregroundColor(.secondary)){
                            ForEach(0..<100) {
                                Text("\(String($0))").foregroundColor(.primary)
                            }
                        }
                        Picker(selection: $viewModel.selectedMinTime, label: Text("newRecord.screen.picker.timecount.title").foregroundColor(.secondary)){
                            ForEach(0..<200) {
                                Text("\(String($0)) min").foregroundColor(.primary)
                            }
                        }
                    }
                }
                else if viewModel.isMaxDistance {
                    Section(header: Text("newRecord.screen.toggle.mintime.title")) {
                        Picker(selection: $viewModel.selectedDistance, label: Text("newRecord.screen.toggle.distance.title").foregroundColor(.secondary)){
                            ForEach(0..<100) {
                                Text("\(String($0)) km").foregroundColor(.primary)
                            }
                        }
                        
                        Picker(selection: $viewModel.selectedMinTime, label: Text("newRecord.screen.picker.timecount.title").foregroundColor(.secondary)){
                            ForEach(0..<200) {
                                Text("\(String($0)) min").foregroundColor(.primary)
                            }
                        }
                    }
                }
                else {
                    Section(header: Text("newRecord.screen.section.informations.title")) {
                        Picker(selection: $viewModel.selectedPercentage, label: Text("newRecord.screen.section.informations.percentage.title").foregroundColor(.secondary)){
                            ForEach(0..<199) {
                                Text("\(String($0)) %").foregroundColor(.primary)
                            }
                        }
                        Picker(selection: $viewModel.selectedInitialPounds, label: Text("newRecord.screen.section.informations.weight.title").foregroundColor(.secondary)){
                            ForEach(0..<999) {
                                Text("\(String($0)) lb").foregroundColor(.primary)
                            }
                        }
                    }
                }

                Section(header: Text("newRecord.screen.section.comment.title")) {
                    TextField("newRecord.screen.section.comment.description", text: $viewModel.editingRecord.comments)
                        .frame(height: 86)
                }
            }
            .navigationBarTitle(Text("newRecord.screen.title"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(
                    action:{
                        self.presentation.wrappedValue.dismiss()
                    }, label: {
                        Text("newRecord.screen.cancel.button.title")
                            .foregroundColor(.green)
                            .bold()
                    }),
                trailing: Button(
                    action: {
                        viewModel.saveRecord()
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Text("newRecord.screen.save.button.title")
                            .foregroundColor(.green)
                            .bold()
                    }
            ).disabled(viewModel.isSaving)
        }
    }
}

struct NewPRRecordView_Previews: PreviewProvider {
    static var previews: some View {
        NewRecordView()
    }
}

struct CategoryView: View {
    let categoriesNames: [String]
    @Binding var selectedCategory: Int

    var body: some View {
        VStack(alignment: .center) {
            Picker("What is your favorite color?", selection: $selectedCategory) {
                ForEach(0..<categoriesNames.count, id: \.self) { index in
                    Text(self.categoriesNames[index]).tag(index)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding([.bottom, .top], 14)
    }
}


struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(categoriesNames: [], selectedCategory: .constant(0))
    }
}

