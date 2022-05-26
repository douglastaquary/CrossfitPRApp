//
//  NewPRRecordView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import SwiftUI
import CoreData

struct NewPRRecordView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var commentsText: String = ""
    @State private var selectedCategory: Int = 0
    @State private var selectedPercentage: Int = 10
    @State private var selectedInitialPounds: Int = 10
    @StateObject private var viewModel = NewPRViewModel()
    @Environment(\.presentationMode) var presentation
    
    let onCommit: (() -> Void) = {}
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal record")) {
                    CategoryView()
                    Picker(selection: $selectedCategory, label: Text("Exercise").foregroundColor(.secondary)){
                        ForEach(0..<ActivitiesRecordKey.allCases.count) {
                            Text(ActivitiesRecordKey.allCases[$0].rawValue)
                        }
                    }
                    .foregroundColor(.primary)
                    .labelsHidden()
                    .padding(.bottom, 12)
                }
                
                Section(header: Text("Informations")) {
                    Picker(selection: $selectedPercentage, label: Text("Percentage").foregroundColor(.secondary)){
                        ForEach(0..<200) {
                            Text("\($0) %")
                        }
                    }
                    .foregroundColor(.primary)
                    .labelsHidden()
                    //.padding(.bottom, 12)
//                    Stepper(value: $viewModel.prPercentage) {
//                        Text(" \(viewModel.prPercentage.clean) %").bold()
//                    }
                    Picker(selection: $selectedInitialPounds, label: Text("Weight").foregroundColor(.secondary)){
                        ForEach(0..<999) {
                            Text("\(String($0)) lb").foregroundColor(.primary)
                        }
                    }
                }

                Section(header: Text("Comments")) {
                    TextField("Enter a comment if needed", text: $commentsText)
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
                        let newPR = PR(context: viewContext)
                        newPR.prName = ActivitiesRecordKey.allCases[selectedCategory].rawValue
                        newPR.recordDate = .now
                        newPR.prValue = selectedInitialPounds
                        newPR.id = UUID()
                        newPR.percentage = viewModel.prPercentage
                        do {
                            try viewContext.save()
                            print("PR saved.")
                            self.presentation.wrappedValue.dismiss()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }) {
                        Text("Save")
                            .foregroundColor(.green)
                            .bold()
                    }
            ).disabled(viewModel.isSaving)
        }
        
    }
    
    private func configPrToSave() {
        viewModel.personalRecord.activity.name = ActivitiesRecordKey(rawValue: Crossfit.exercises[selectedCategory].name.rawValue) ?? .empty
        viewModel.personalRecord.pounds = Double(selectedInitialPounds)
    }
}

struct NewPRRecordView_Previews: PreviewProvider {
    static var previews: some View {
        NewPRRecordView()
    }
}

struct CategoryView: View {
    
    @State private var selectedCategory = 0
    
    var body: some View {
        VStack(alignment: .center) {
            Picker("What is your favorite color?", selection: $selectedCategory) {
                Text("RX").tag(0)
                Text("Scaled").tag(1)
            }
            .pickerStyle(.segmented)
            ///Text("Value: \(selectedCategory)")
        }
        .padding([.bottom, .top], 14)
    }
}


struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}

