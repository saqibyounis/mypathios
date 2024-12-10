//
//  TargetListView.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import SwiftUI

// MARK: - Target List View
struct TargetListView: View {
    @StateObject private var viewModel: TargetListViewModel
    @State private var showingAddTarget = false
    @State private var selectedTarget: TargetEntity?
    
    init() {
        let service = TargetServiceFactory.makeService()
        _viewModel = StateObject(wrappedValue: TargetListViewModel(service: service))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading && viewModel.targets.isEmpty {
                    ProgressView()
                } else if viewModel.targets.isEmpty {
                    VStack(spacing: 12) {
                        Text("No Targets")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        
                        Button("Add Target") {
                            showingAddTarget = true
                        }
                    }
                } else {
                    List {
                        ForEach(viewModel.targets) { target in
                            TargetRowView(target: target)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedTarget = target
                                }
                        }
                        .onDelete { indexSet in
                            guard let index = indexSet.first else { return }
                            viewModel.deleteTarget(viewModel.targets[index])
                        }
                    }
                    .refreshable {
                        viewModel.fetchTargets()
                    }
                }
            }
            .navigationTitle("Targets")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddTarget = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Picker("Filter", selection: $viewModel.selectedFilter) {
                        Text("All").tag(TargetListViewModel.TargetFilter.all)
                        Text("In Progress").tag(TargetListViewModel.TargetFilter.inProgress)
                        Text("Completed").tag(TargetListViewModel.TargetFilter.completed)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .sheet(isPresented: $showingAddTarget) {
                // Replace with your actual TargetFormView
                    TargetFormView(goalName: nil, goalId: nil)
                
            }
            .sheet(item: $selectedTarget) { target in
                // Replace with your target detail view
                TargetDetailsView(target: target)
            }
        }
    }
}

// MARK: - Target Row View
struct TargetRowView: View {
    let target: TargetEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(target.name)
                    .font(.headline)
                
                Spacer()
                
                Text("\(Int(target.progress))%")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(progressColor.opacity(0.2))
                    .foregroundColor(progressColor)
                    .clipShape(Capsule())
            }
            
            ProgressView(value: target.progress, total: 100)
                .tint(progressColor)
            
            if let deadline = target.deadline {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.secondary)
                    Text("Due \(Date(timeIntervalSince1970: TimeInterval(deadline/1000)).formatted(.relative(presentation: .named)))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            if !target.tasks.isEmpty {
                HStack {
                    Image(systemName: "checklist")
                        .foregroundStyle(.secondary)
                    Text("\(target.tasks.filter { $0.status == .completed }.count)/\(target.tasks.count) tasks completed")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private var progressColor: Color {
        if target.progress >= 100 {
            return .green
        } else if target.progress > 50 {
            return .blue
        } else {
            return .orange
        }
    }
}

