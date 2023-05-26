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
    
    var index: Int {
        switch self {
        case .maxWeight: return  0
        case .maxRepetition: return 1
        case .maxDistance: return 2
        }
    }
}

struct NewRecordView: View {

    @StateObject var viewModel: NewRecordViewModel
    
    //@EnvironmentObject var viewModel: NewRecordViewModel
    
    @State private var commentsText: String = ""
    @State private var selectedCategory: Int = 0
    @State private var selectedCategoryItem: Int = 0
    @State private var selectedPercentage: Int = 10
    @State private var selectedInitialPounds: Int = 10
    @State private var selectedMaxReps: Int = 0
    @State private var selectedMinTime: Int = 0
    @State private var selectedDistance: Int = 10
    @State private var title: String = ""
    
    @Environment(\.presentationMode) var presentation
    
    let onCommit: (() -> Void) = {}
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Record")) {
                    CategoryView(items: viewModel.crossfitLevelList, selectedCategory: $viewModel.selectedCategoryItem)
                    Picker(selection: $viewModel.selectedCategory, label: Text("Crossfit PR").foregroundColor(.secondary)) {
                        if viewModel.editingCategory.title.isEmpty {
                            ForEach(0..<viewModel.personalRecordTypeList.count, id: \.self) {
                                Text(viewModel.personalRecordTypeList[$0].title)
                            }
                        } else {
                            Text(viewModel.editingCategory.title)
                        }
                    }
                    .foregroundColor(.primary)
                    .padding(.bottom, 12)
                }

                switch viewModel.personalRecordTypeList[viewModel.selectedCategory].group {
                case .barbell:
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
                case .gymnastic:
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
                case .endurance:
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
                
                Section(header: Text("newRecord.screen.section.comment.title")) {
                    TextField("newRecord.screen.section.comment.description", text: $viewModel.editingRecord.comments)
                        .frame(height: 86)
                }
                
            }
            .onAppear {
                if !viewModel.editingCategory.title.isEmpty {
                    viewModel.editingRecord.group = viewModel.editingCategory.group
                    viewModel.editingRecord.prName = viewModel.editingCategory.title
                    viewModel.editingRecord.recordMode = viewModel.editingCategory.type
                    viewModel.selectedCategory = viewModel.editingCategory.type.index
                }
            }
            .navigationBarTitle(Text(viewModel.editingCategory.title), displayMode: .inline)
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
        NewRecordView(viewModel: NewRecordViewModel())
    }
}

struct CategoryView: View {
    let items: [String]
    @Binding var selectedCategory: Int

    var body: some View {
        VStack(alignment: .center) {
            Picker("What is your favorite color?", selection: $selectedCategory) {
                ForEach(0..<items.count, id: \.self) { index in
                    Text(self.items[index]).tag(index)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding([.bottom, .top], 14)
    }
}


struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(items: [], selectedCategory: .constant(0))
    }
}

