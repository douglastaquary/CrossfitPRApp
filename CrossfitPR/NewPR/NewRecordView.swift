//
//  NewPRRecordView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import SwiftUI
import CoreData

struct NewRecordView: View {
    private enum Field: Int, CaseIterable {
        case percentage, weight, distance, duration
    }

    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var viewModel: NewRecordViewModel
    @State private var commentsText: String = ""
    @State private var selectedCategory: Int = 0
    @State private var selectedCategoryItem: Int = 0
    @State private var selectedPercentage: Int = 10
    @State private var selectedInitialPounds: Int = 10
    @State private var selectedMaxReps: Int = 0
    @State private var selectedMinTime: Int = 0
    @State private var selectedDistance: Int = 10
    @State private var title: String = ""
    @State private var isPound: Bool = false
    
    @Environment(\.presentationMode) var presentation
    //@FocusState private var focusedField: Field?
    
    let onCommit: (() -> Void) = {}
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Record")) {
                    CategoryView(items: viewModel.crossfitLevelList, selectedCategory: $viewModel.selectedCategoryItem)
                    Picker(selection: $viewModel.selectedCategory, label: Text("Crossfit PR")) {
                        Text(viewModel.editingCategory.title)
                    }
                    .foregroundColor(.primary)
                    .padding(.bottom, 12)
                }

                switch viewModel.editingCategory.group {
                case .barbell:
                    
                    Section(header: Text("newRecord.screen.section.informations.percentage.title")) {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            TextField("0%", text: $viewModel.selectedPercentage) { UIApplication.shared.endEditing() }
                                .keyboardType(.numberPad)
                                .fixedSize(horizontal: true, vertical: false)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .accentColor(.green)
                                //.focused($focusedField, equals: .percentage)
                            if !viewModel.selectedPercentage.isEmpty {
                                Text("%")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(!viewModel.selectedPercentage.isEmpty ? .primary : .secondary)
                            }
                        }
                    }
                    
                    Section(header: Text("newRecord.screen.section.informations.weight.title")) {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            TextField(viewModel.measureTrackingMode == .pounds ? "lb" : "kg", text: $viewModel.selectedInitialPounds) { UIApplication.shared.endEditing()
                            }
                            .keyboardType(.numberPad)
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .accentColor(.green)
                            if !viewModel.selectedInitialPounds.isEmpty {
                                Text(viewModel.measureTrackingMode == .pounds ? " lb" : " kg")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(!viewModel.selectedInitialPounds.isEmpty ? .primary : .secondary)
                            }
                        }
                    }

                case .gymnastic:
                    Section(header: Text("newRecord.screen.toggle.maxrep.title")) {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            TextField("Reps", text: $viewModel.selectedMaxReps) { UIApplication.shared.endEditing() }
                                .keyboardType(.numberPad)
                                .fixedSize(horizontal: true, vertical: false)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .accentColor(.green)
                            if !viewModel.selectedMaxReps.isEmpty {
                                Text("reps")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(!viewModel.selectedMaxReps.isEmpty ? .primary : .secondary)
                            }
                        }
                    }
                    Section(header: Text("newRecord.screen.picker.timecount.title")) {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            TextField("Min", text: $viewModel.selectedMinTime) { UIApplication.shared.endEditing() }
                                .keyboardType(.numberPad)
                                .fixedSize(horizontal: true, vertical: false)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .accentColor(.green)
                            if !viewModel.selectedMinTime.isEmpty {
                                Text("newRecord.screen.minutes.description")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(!viewModel.selectedMinTime.isEmpty ? .primary : .secondary)
                            }
                        }
                    }
                case .endurance:
                    Section(header: Text("newRecord.screen.toggle.distance.title")) {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            TextField("Km", text: $viewModel.selectedDistance) { UIApplication.shared.endEditing() }
                                .keyboardType(.numberPad)
                                .fixedSize(horizontal: true, vertical: false)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .accentColor(.green)
                            if !viewModel.selectedDistance.isEmpty {
                                Text("Km")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(!viewModel.selectedDistance.isEmpty ? .primary : .secondary)
                            }
                        }
                    }
                    
                    Section(header: Text("newRecord.screen.picker.timecount.title")) {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            TextField("Min", text: $viewModel.selectedMinTime) { UIApplication.shared.endEditing() }
                                .keyboardType(.numberPad)
                                .fixedSize(horizontal: true, vertical: false)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .accentColor(.green)
                            if !viewModel.selectedMinTime.isEmpty {
                                Text("newRecord.screen.minutes.description")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(!viewModel.selectedMinTime.isEmpty ? .primary : .secondary)
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
            .navigationBarItems(leading:
                Button(action:{
                        self.presentation.wrappedValue.dismiss()
                    }, label: {
                        Text("newRecord.screen.cancel.button.title")
                            .foregroundColor(.green)
                            .bold()
                    }
                )
            )
                
        }
        
        Spacer()
        VStack {
            Button("newRecord.screen.save.button.title"){
                withAnimation() {
                    self.viewModel.saveRecord()
                    self.presentation.wrappedValue.dismiss()
                }
            }
            .buttonStyle(FilledButton(widthSizeEnabled: true))
            .disabled(!viewModel.isSaving)
        }
        .padding()

    }
}

struct NewPRRecordView_Previews: PreviewProvider {
    static var previews: some View {
        NewRecordView()
    }
}

