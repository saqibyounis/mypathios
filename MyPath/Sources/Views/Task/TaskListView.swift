//
//  TaskListView.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import SwiftUI


// MARK: - View
struct TaskListView: View {
    @StateObject private var viewModel: TaskListViewModel
    @State private var showingAddTask = false
    
    init() {
        let service = TaskServiceFactory.makeService()
        _viewModel = StateObject(wrappedValue: TaskListViewModel(service: service))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading && viewModel.tasks.isEmpty {
                    ProgressView()
                } else if viewModel.tasks.isEmpty {
                    VStack(spacing: 12) {
                        Text("No Tasks")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        
                        Button("Add Task") {
                            showingAddTask = true
                        }
                    }
                } else {
                    List {
                      
                        ForEach(viewModel.tasks) { task in
                            NavigationLink(destination:   TaskDetailsView(viewModel: TaskDetailsViewModel(service: TaskServiceFactory.makeService(), taskId: task.id))) {
                                TaskRowView(task: task) { task, newStatus in
                                    viewModel.updateTaskStatus(task, status: newStatus)
                                }
                               }
                           
                        }
                        .onDelete { indexSet in
                            guard let index = indexSet.first else { return }
                            viewModel.deleteTask(viewModel.tasks[index])
                        }
                    }
                    .refreshable {
                        viewModel.fetchTasks()
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Picker("Filter", selection: $viewModel.selectedFilter) {
                        Text("All").tag(TaskListViewModel.TaskFilter.all)
                        Text("Active").tag(TaskListViewModel.TaskFilter.active)
                        Text("Completed").tag(TaskListViewModel.TaskFilter.completed)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

// MARK: - Task Row View

struct TaskRowView: View {
    let task: TaskEntity
    let onStatusChange: (TaskEntity, TaskStatus) -> Void
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(task.name)
                    .font(.headline)
                
                Spacer()
                
                Menu {
                    ForEach(TaskStatus.allCases, id: \.self) { status in
                        Button {
                            onStatusChange(task, status)
                        } label: {
                            if status == task.status {
                                Label(status.rawValue, systemImage: "checkmark")
                            } else {
                                Text(status.rawValue)
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: task.status.icon)
                        Text(task.status.rawValue)
                    }
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(task.status.color.opacity(0.2))
                    .foregroundColor(task.status.color)
                    .clipShape(Capsule())
                }
            }
            
            if let description = task.taskDescription, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Image(systemName: "clock")
                    .foregroundStyle(.secondary)
                Text("\(task.duration ?? 0) min")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if task.status == .completed, let completedAt = task.completedAt {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.secondary)
                    Text("Completed \(Date(timeIntervalSince1970: TimeInterval(completedAt/1000)).formatted(.relative(presentation: .named)))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
