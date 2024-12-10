//
//  TargetDetailView.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import SwiftUI
import RxSwift
import RealmSwift



// MARK: - Target Details View
struct TargetDetailsView: View {
    @StateObject private var viewModel: TargetDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(target: TargetEntity) {
        let targetService = TargetServiceFactory.makeService()
        let taskService = TaskServiceFactory.makeService()
        _viewModel = StateObject(wrappedValue: TargetDetailsViewModel(
            target: target,
            targetService: targetService,
            taskService: taskService
        ))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Progress Section
                    ProgressSection(progress: viewModel.target.progress)
                    
                    // Deadline Section
                    if let deadline = viewModel.target.deadline {
                        DeadlineSection(deadline: deadline)
                    }
                    
                    // Tasks Section
                    TasksSection(
                        tasks: viewModel.tasks,
                        selectedFilter: $viewModel.selectedTaskFilter,
                        onTaskStatusChange: viewModel.updateTaskStatus,
                        onDeleteTask: viewModel.deleteTask
                    )
                }
                .padding()
            }
            .navigationTitle(viewModel.target.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.showingAddTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .sheet(isPresented: $viewModel.showingAddTask) {
                TaskFormView(targetName: viewModel.target.name, targetId: viewModel.target.id, task: nil)
            }
            .refreshable {
                viewModel.fetchTasks()
            }
        }
    }
}

// MARK: - Supporting Views
private struct ProgressSection: View {
    let progress: Double
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(Int(progress))%")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(progressColor)
            
            ProgressView(value: progress, total: 100)
                .tint(progressColor)
                .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
    
    private var progressColor: Color {
        if progress >= 100 {
            return .green
        } else if progress > 50 {
            return .blue
        } else {
            return .orange
        }
    }
}

private struct DeadlineSection: View {
    let deadline: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Label {
                Text("Deadline")
                    .font(.headline)
            } icon: {
                Image(systemName: "calendar")
            }
            
            Text(Date(timeIntervalSince1970: TimeInterval(deadline/1000)).formatted(date: .long, time: .omitted))
                .foregroundStyle(.secondary)
            
            Text(Date(timeIntervalSince1970: TimeInterval(deadline/1000)).formatted(.relative(presentation: .named)))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

private struct TasksSection: View {
    let tasks: [TaskEntity]
    @Binding var selectedFilter: TaskStatus?
    let onTaskStatusChange: (TaskEntity, TaskStatus) -> Void
    let onDeleteTask: (TaskEntity) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Tasks")
                    .font(.headline)
                
                Spacer()
                
                Menu {
                    Button("All Tasks") {
                        selectedFilter = nil
                    }
                    
                    ForEach(TaskStatus.allCases, id: \.self) { status in
                        Button(status.rawValue) {
                            selectedFilter = status
                        }
                    }
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
            
            if tasks.isEmpty {
                Text("No tasks yet")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(tasks) { task in
                    TaskRowView(task: task, onStatusChange: onTaskStatusChange)
                        .swipeActions {
                            Button(role: .destructive) {
                                onDeleteTask(task)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}
