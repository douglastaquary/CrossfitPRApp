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
    
    @State private var selectedCategory: Int = 0
    @State private var selectedInitialPounds: Int = 10
    @StateObject private var viewModel = NewPRViewModel()
    @Environment(\.presentationMode) var presentation
    
    //@Binding var query: String
    let onCommit: (() -> Void) = {}

    var body: some View {
        NavigationView {
                Form {
                    VStack {
                        Picker(selection: $selectedCategory, label: Text("Exercicio").foregroundColor(.secondary)){
                            ForEach(0..<Crossfit.exercises.count) {
                                Text(Crossfit.exercises[$0].name.rawValue)
                            }
                        }
                        .foregroundColor(.primary)
                        .labelsHidden()
                    }.padding()
                    
                    Section {
                        Picker(selection: $selectedInitialPounds, label: Text("Personal Record").foregroundColor(.secondary)){
                            ForEach(0..<999) {
                                Text("\(String($0)) lb").foregroundColor(.primary)
                            }
                        }
                        DatePicker("Data", selection: $viewModel.personalRecord.date)
                    }.padding()
                    
                    
                }
                .navigationBarTitle(Text("Novo Record"), displayMode: .inline)
                .navigationBarItems(trailing:
                    Button(action: {
                    configPrToSave()
//                    self.viewModel.save()
                    
                    let newPR = PR(context: viewContext)
                    newPR.prName = Crossfit.exercises[selectedCategory].name.rawValue
                    newPR.recordDate = .now
                    newPR.prValue = selectedInitialPounds
                    newPR.id = UUID()
                    //newPR.percentage = viewModel.prPercentage
                    do {
                        try viewContext.save()
                        print("PR saved.")
                        self.presentation.wrappedValue.dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                }) {
                    Text("Salvar")
                        .foregroundColor(.green)
                        .bold()
                }).disabled(viewModel.isSaving)
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


