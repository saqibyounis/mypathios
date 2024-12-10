//
//  GoalsView.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//
import SwiftUI


struct GoalsListView: View {
    @StateObject private var viewModel: GoalsListViewModel
    @State private var showingAddGoal = false
    
    init() {
        let service = GoalServiceFactory.makeService()
        _viewModel = StateObject(wrappedValue: GoalsListViewModel(goalService: service))
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.goals.isEmpty {
                    ContentUnavailableView(
                        "No Goals",
                        systemImage: "flag.circle",
                        description: Text("Add your first goal to get started")
                    )
                } else {
                    List {
                        ForEach(viewModel.goals) { goal in
                            GoalRowView(goal: goal)
                        }
                        .onDelete { indexSet in
                            guard let index = indexSet.first else { return }
                            viewModel.deleteGoal(viewModel.goals[index])
                        }
                    }
                }
            }
            .navigationTitle("Goals")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddGoal = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                GoalFormView()
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .refreshable {
                viewModel.loadGoals()
            }
        }
    }
}

struct GoalRowView: View {
    let goal: GoalEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(goal.name)
                .font(.headline)
            
            if let description = goal.goalDescription {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            ProgressView(value: goal.progress, total: 100)
                .tint(.green)
            
            Text("\(Int(goal.progress))% Complete")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
}
