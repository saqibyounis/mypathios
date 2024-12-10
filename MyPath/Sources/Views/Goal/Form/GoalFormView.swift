//
//  GoalFormView.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import Foundation
import SwiftUI
import RxSwift

struct GoalFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: GoalFormViewModel
    @State private var showingError = false
    private let disposeBag = DisposeBag()


    
    init() {
        _viewModel = StateObject(wrappedValue: GoalFormView.makeViewModel())
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Goal Details") {
                    TextField("Goal Name", text: $viewModel.name)
                        .textInputAutocapitalization(.words)
                    
                    TextEditor(text: $viewModel.description)
                        .frame(height: 100)
                        .overlay(
                            Group {
                                if viewModel.description.isEmpty {
                                    Text("Description (optional)")
                                        .foregroundStyle(.secondary)
                                        .padding(.leading, 4)
                                }
                            },
                            alignment: .topLeading
                        )
                }
                
                Section("Goal Type") {
                    GoalTypeSelectionView(selectedType: $viewModel.selectedType)
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical, 8)
                }
                
                Section("Priority") {
                    PrioritySelectionView(selectedPriority: $viewModel.selectedPriority)
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical, 8)
                }
                
                Section("Timeline") {
                    HStack {
                        Text("Start Date")
                        Spacer()
                        Text(viewModel.startDate.formatted(date: .abbreviated, time: .omitted))
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Progress")
                        Spacer()
                        Text("\(Int(viewModel.progress))%")
                            .foregroundStyle(.secondary)
                    }
                    
                    ProgressView(value: viewModel.progress, total: 100)
                        .tint(.green)
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        
                        // Wherever you're calling saveGoal():
                        viewModel.saveGoal()
                            .observe(on: MainScheduler.instance)  // Ensure UI updates on main thread
                            .subscribe(
                                onCompleted: {
                                    print("Goal saved successfully")
                                },
                                onError: { error in
                                    print("Failed to save goal: \(error)")
                                }
                            )
                            .disposed(by: disposeBag)

                        if viewModel.errorMessage != nil {
                                                   
                            showingError = true
                            } else {
                              dismiss()
                            }
                    }
                    .disabled(viewModel.name.isEmpty)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}
