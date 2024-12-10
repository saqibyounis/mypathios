//
//  TaskDetailsView.swift
//  MyPath
//
//  Created by Saqib Younis on 09/12/2024.
//


import SwiftUI
import RxSwift
import PhotosUI

// MARK: - Views
struct TaskDetailsView: View {
    @StateObject var viewModel: TaskDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let task = viewModel.task {
                    TaskInfoSection(task: task)
                    AttachmentsSection(viewModel: viewModel)
                }
            }
            .padding()
        }
        .navigationTitle("Task Details")
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

struct TaskInfoSection: View {
    let task: TaskEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(task.name)
                .font(.title2)
                .fontWeight(.bold)
            
            if let description = task.taskDescription {
                Text(description)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Label("\(task.duration) min", systemImage: "clock")
                Spacer()
//                StatusBadge(status: task.status)
            }
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

struct AttachmentsSection: View {
    @ObservedObject var viewModel: TaskDetailsViewModel
    
    var body: some View {
      
        VStack(alignment: .leading, spacing: 12) {
            Text("Attachments")
                .font(.title3)
                .fontWeight(.bold)
            
            AttachmentListView(
                attachments: viewModel.task!.attachments,
                        onDeleteAttachment: { attachment in
                            if let index = viewModel.task!.attachments.firstIndex(where: { $0.id == attachment.id }) {
                                viewModel.task!.attachments.remove(at: index)
                            }
                        },
                        onAttachmentTapped: { attachment in
                            // Handle attachment tap (e.g., preview file)
                            print("Tapped attachment: \(attachment.name)")
                        }
                    )
            AttachmentActionsView (){ attachment in
                print(attachment.name)
                viewModel.addAttachment(attachment: attachment)
            } onError: { error in
                print(error)
            }


           
        }
    }
}
