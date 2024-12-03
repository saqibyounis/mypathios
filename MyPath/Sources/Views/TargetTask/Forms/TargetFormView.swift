//
//  TargetForm.swift
//  MyPath
//
//  Created by Saqib Younis on 30/11/2024.
//

import Foundation
import SwiftUI
import RxSwift

struct TargetFormView: View {
    @StateObject private var viewModel = TargetFormViewModel()

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Target Name").bold()) {
                    TextField("Enter name", text: $viewModel.name)
                }
                Section(header: Text("Description")) {
                    TextField("Optional", text: $viewModel.descriptionText)
                }
                Section(header: Text("Start Date")) {
                    DatePicker("Start Date", selection: Binding(
                        get: { viewModel.startDate ?? Date() },
                        set: { viewModel.startDate = $0 }
                    ), displayedComponents: .date)
                }
                Section(header: Text("Intended Commplition Date")) {
                    DatePicker("Finish Date", selection: Binding(
                        get: { viewModel.intendedFinishDate ?? Date() },
                        set: { viewModel.intendedFinishDate = $0 }
                    ), displayedComponents: .date)
                }
                Section(header: Text("Icon")) {
                    TextField("Icon (Optional)", text: $viewModel.icon)
                }
                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $viewModel.category) {
                        ForEach(viewModel.predefinedCategories, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                
                Section(header: Text("Target Status")) {
                    Picker("Select Status", selection: $viewModel.targetStatus) {
                        ForEach(TargetStatus.allCases, id: \.self) { status in
                            Text(status.rawValue.capitalized)
                        }
                    }
                }
                Section(header: Text("Target Type")) {
                    Picker("Select Type", selection: $viewModel.targetType) {
                        ForEach(TargetType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                }
                Section(header: Text("Target Priority")) {
                    Picker("Select Priority", selection: $viewModel.targetPriority) {
                        ForEach(TargetPriority.allCases, id: \.self) { priority in
                            Text(priority.rawValue.capitalized)
                        }
                    }
                }
            }
            .alert(isPresented: $viewModel.showError) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Add Target")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if viewModel.validateAndSaveTarget() {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}
