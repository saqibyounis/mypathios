import SwiftUICore
import SwiftUI

//
//  TaskFormView.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//


struct TargetFormView: View {
    let goalName: String?
    let goalId: String?
    @StateObject private var viewModel: TargetFormViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(goalName: String?, goalId: String?) {
        self.goalName = goalName
        self.goalId = goalId
        let service = TargetServiceFactory.makeService()
        _viewModel = StateObject(wrappedValue: TargetFormViewModel(service: service, goalId: goalId))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Target Details") {
                    TextField("Target Name", text: $viewModel.name)
                        .textInputAutocapitalization(.words)
                        .disabled(viewModel.isSaving)
                    
                    Toggle("Set Deadline", isOn: $viewModel.hasDeadline)
                        .disabled(viewModel.isSaving)
                    
                    if viewModel.hasDeadline {
                        DatePicker(
                            "Deadline",
                            selection: $viewModel.deadline,
                            in: Date()...,
                            displayedComponents: [.date]
                        )
                        .disabled(viewModel.isSaving)
                    }
                }
                
                Section("Associated Goal") {
                    Text(goalName ?? "")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("New Target")
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
                        viewModel.saveTarget()
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

