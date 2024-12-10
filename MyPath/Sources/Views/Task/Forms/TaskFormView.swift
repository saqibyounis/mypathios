//
//  TaskFormView.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import SwiftUI

struct TaskFormView: View {
    let targetName: String?
    let targetId: String?
    let task: TaskEntity?
    @StateObject private var viewModel: TaskFormViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(targetName: String?, targetId: String?, task: TaskEntity?) {
        self.targetName = targetName
        self.targetId = targetId
        self.task = task
        let service = TaskServiceFactory.makeService()
        _viewModel = StateObject(wrappedValue: TaskFormViewModel(service: service, targetId: targetId, task: task))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Task Details") {
                    TextField("Task Name", text: $viewModel.name)
                        .textInputAutocapitalization(.words)
                        .disabled(viewModel.isSaving)
                    
                    TextEditor(text: $viewModel.description)
                        .frame(height: 100)
                        .disabled(viewModel.isSaving)
                        .overlay(
                            Group {
                                if viewModel.description.isEmpty {
                                    Text("Additional details (optional)")
                                        .foregroundStyle(.secondary)
                                        .padding(.leading, 4)
                                }
                            },
                            alignment: .topLeading
                        )
                }
                
                Section("Duration") {
                    Stepper(value: $viewModel.duration, in: 5...240, step: 5) {
                        HStack {
                            Text("Duration")
                            Spacer()
                            Text("\(Int(viewModel.duration)) minutes")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .disabled(viewModel.isSaving)
                }
                
                Section("Associated Target") {
                    Text(targetName ?? "")
                        .foregroundStyle(.secondary)
                }
                
                Section("Status") {
                    StatusSelectionView(selectedStatus: $viewModel.status)
                        .padding(.all, 4)
                        .disabled(viewModel.isSaving)
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(viewModel.isSaving)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.saveTask()
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isSaving)
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .overlay {
                if viewModel.isSaving {
                    ProgressView()
                }
            }
            .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
                if shouldDismiss {
                    dismiss()
                }
            }
        }
    }
}
