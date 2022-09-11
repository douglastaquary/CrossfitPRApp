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
    case minTime
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
                Section(header: Text("Personal record")) {
                    CategoryView(categoriesNames: viewModel.crossfitLevelList, selectedCategory: $viewModel.selectedCategoryItem)
                    Picker(selection: $viewModel.selectedCategory, label: Text("Crossfit PR").foregroundColor(.secondary)) {
                        ForEach(0..<viewModel.personalRecordTypeList.count, id: \.self) {
                            Text(viewModel.personalRecordTypeList[$0].rawValue)
                        }
                    }
                    .foregroundColor(.primary)
                    .padding(.bottom, 12)
                }
                
                Section(header: Text("Record configurations")) {
                    Toggle(isOn: $viewModel.isMaxRepetitions) {
                        Text("Maximum repetitions")
                    }
                    Toggle(isOn: $viewModel.minimunTimes) {
                        Text("Minimum time")
                    }
                }
                if viewModel.isMaxRepetitions {
                    Section(header: Text("Max reps")) {
                        Picker(selection: $viewModel.editingRecord.maxReps, label: Text("Repetitions").foregroundColor(.secondary)){
                            ForEach(0..<100) {
                                Text("\(String($0))").foregroundColor(.primary)
                            }
                        }
                    }
                } else if viewModel.minimunTimes {
                    Section(header: Text("Minimum time")) {
                        Picker(selection: $viewModel.editingRecord.minTime, label: Text("Times").foregroundColor(.secondary)){
                            ForEach(0..<200) {
                                Text("\(String($0)) min").foregroundColor(.primary)
                            }
                        }
                        
                        Picker(selection: $viewModel.editingRecord.distance, label: Text("Distance").foregroundColor(.secondary)){
                            ForEach(0..<100) {
                                Text("\(String($0)) km").foregroundColor(.primary)
                            }
                        }
                    }
                } else {
                    Section(header: Text("Informations")) {
                        Picker(selection: $viewModel.selectedPercentage, label: Text("Percentage").foregroundColor(.secondary)){
                            ForEach(0..<199) {
                                Text("\(String($0)) %").foregroundColor(.primary)
                            }
                        }
                        Picker(selection: $viewModel.selectedInitialPounds, label: Text("Weight").foregroundColor(.secondary)){
                            ForEach(0..<999) {
                                Text("\(String($0)) lb").foregroundColor(.primary)
                            }
                        }
                    }
                }

                Section(header: Text("Comments")) {
                    TextField("Enter a comment if needed", text: $viewModel.editingRecord.comments)
                        .frame(height: 86)
                }
            }
            .navigationBarTitle(Text("New Record"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(
                    action:{
                        self.presentation.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                            .foregroundColor(.green)
                            .bold()
                    }),
                trailing: Button(
                    action: {
                        viewModel.saveRecord()
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Text("Save")
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
