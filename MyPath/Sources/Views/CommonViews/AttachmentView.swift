//
//  AttachmentView.swift
//  MyPath
//
//  Created by Saqib Younis on 09/12/2024.
//
import SwiftUI
import RxSwift
import PhotosUI

import Foundation
import UIKit

// MARK: - Models
struct AttachmentViewConfiguration {
    var showCamera: Bool = true
    var allowedTypes: [UTType] = [.image, .pdf, .text]
    var maxFileSize: Int64? = nil
}

// MARK: - Attachment Handler Errors
enum AttachmentHandlerError: LocalizedError {
    case invalidFileSize(Int64)
    case invalidFileType(String)
    case fileSaveFailed(Error)
    case fileAccessFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidFileSize(let size):
            return "File size \(size.formatted()) exceeds maximum allowed size"
        case .invalidFileType(let type):
            return "File type '\(type)' is not supported"
        case .fileSaveFailed(let error):
            return "Failed to save file: \(error.localizedDescription)"
        case .fileAccessFailed:
            return "Failed to access file"
        }
    }
}

// MARK: - Attachment Handler Protocol
protocol AttachmentHandling {
    func saveAttachment(from url: URL) async throws -> AttachmentEntity
    func saveAttachment(image: UIImage) async throws -> AttachmentEntity
    func deleteAttachment(_ attachment: AttachmentEntity) async throws
}

// MARK: - Attachment Handler Implementation
class AttachmentHandler: AttachmentHandling {
    private let fileManager: FileManagerService
    private let maxFileSize: Int64
    private let allowedTypes: [UTType]
    
    init(maxFileSize: Int64 = 10_000_000, // 10MB default
         allowedTypes: [UTType] = [.image, .pdf, .text]) {
        self.fileManager = .shared
        self.maxFileSize = maxFileSize
        self.allowedTypes = allowedTypes
    }
    
    func saveAttachment(from url: URL) async throws -> AttachmentEntity {
        // Verify file size
        let size = try fileManager.getFileSize(at: url)
        guard size <= maxFileSize else {
            throw AttachmentHandlerError.invalidFileSize(size)
        }
        
        // Verify file type
        let fileType = try url.resourceValues(forKeys: [.contentTypeKey]).contentType
        guard let fileType = fileType,
              allowedTypes.contains(where: { fileType.conforms(to: $0) }) else {
            throw AttachmentHandlerError.invalidFileType(url.pathExtension)
        }
        
        // Save file
        do {
            let savedUrl = try fileManager.saveAttachment(originalUrl: url, filename: url.lastPathComponent)
            
            return AttachmentEntity(
                id: UUID().uuidString,
                name: url.lastPathComponent,
                type: determineAttachmentType(from: url),
                size: size,
                localPath: savedUrl.lastPathComponent
            )
        } catch {
            throw AttachmentHandlerError.fileSaveFailed(error)
        }
    }
    
    func saveAttachment(image: UIImage) async throws -> AttachmentEntity {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw AttachmentHandlerError.fileSaveFailed(AttachmentHandlerError.fileAccessFailed)
        }
        
        let filename = "\(UUID().uuidString).jpg"
        let temporaryUrl = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        try data.write(to: temporaryUrl)
        
        return try await saveAttachment(from: temporaryUrl)
    }
    
    func deleteAttachment(_ attachment: AttachmentEntity) async throws {
        try fileManager.deleteAttachment(at: attachment.toAttachment().url)
    }
    
    private func determineAttachmentType(from url: URL) -> AttachmentType {
        let uti = UTType(filenameExtension: url.pathExtension)
        
        if uti?.conforms(to: .image) ?? false {
            return .image
        } else if uti?.conforms(to: .pdf) ?? false {
            return .pdf
        }
        return .other
    }
}



// MARK: - Helper Views
struct DocumentPicker: UIViewControllerRepresentable {
    let callback: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image, .pdf, .text])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(callback: callback)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let callback: (URL) -> Void
        
        init(callback: @escaping (URL) -> Void) {
            self.callback = callback
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            callback(url)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    let callback: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(callback: callback)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let callback: (UIImage) -> Void
        
        init(callback: @escaping (UIImage) -> Void) {
            self.callback = callback
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                callback(image)
            }
            picker.dismiss(animated: true)
        }
    }
}


// MARK: - Attachment List View
struct AttachmentListView: View {
    let attachments: List<AttachmentEntity>
    let onDeleteAttachment: ((AttachmentEntity) -> Void)?
    let onAttachmentTapped: ((AttachmentEntity) -> Void)?
    @State private var selectedAttachment: AttachmentEntity?
    
    init(
        attachments: List<AttachmentEntity>,
        onDeleteAttachment: ((AttachmentEntity) -> Void)? = nil,
        onAttachmentTapped: ((AttachmentEntity) -> Void)? = nil
    ) {
        self.attachments = attachments
        self.onDeleteAttachment = onDeleteAttachment
        self.onAttachmentTapped = onAttachmentTapped
    }
    
    var body: some View {
        VStack(spacing: 12) {
            if attachments.isEmpty {
                EmptyAttachmentView()
            } else {
                ForEach(attachments, id: \.id) { attachment in
                    AttachmentItemView(
                        attachment: attachment,
                        onDelete: {
                            if let onTap = onDeleteAttachment{
                                onTap(attachment)
                            }
                        },
                        onTap: {
                            if let onTap = onAttachmentTapped {
                                onTap(attachment)
                            }
                        }
                    )
                }
            }
        }
        .padding(.horizontal)
    }
}

struct EmptyAttachmentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.fill")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("No Attachments")
                .font(.headline)
                .foregroundColor(.gray)
            Text("Add files or take photos")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct AttachmentItemView: View {
    let attachment: AttachmentEntity
    let onDelete: () -> Void
    let onTap: () -> Void
    @State private var showDeleteAlert = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // File Icon
                Image(systemName: iconName)
                    .font(.system(size: 24))
                    .foregroundColor(.accentColor)
                    .frame(width: 40, height: 40)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                // File Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(attachment.name)
                        .font(.system(.body, design: .rounded))
                        .lineLimit(1)
                    
                    Text(formattedSize)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Delete Button
                Button(action: { showDeleteAlert = true }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(8)
                }
            }
            .padding(12)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
        .alert("Delete Attachment", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive, action: onDelete)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this attachment?")
        }
    }
    
    private var iconName: String {
        switch attachment.type {
        case .image: return "photo.fill"
        case .pdf: return "doc.text.fill"
        case .other: return "doc.fill"
        }
    }
    
    private var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: attachment.size)
    }
}

// MARK: - Attachment Actions View
struct AttachmentActionsView: View {
    let onAttachmentSaved: (AttachmentEntity) -> Void
    let onError: (Error) -> Void
    @State private var showingActionSheet = false
    @State private var showingImagePicker = false
    @State private var showingFilePicker = false
    @State private var showingCamera = false
    @State private var isLoading = false
    // Add this property to AttachmentActionsView
    @State private var photosPickerItem: PhotosPickerItem?

    
    private let attachmentHandler: AttachmentHandler
    
    init(
        maxFileSize: Int64 = 10_000_000,
        allowedTypes: [UTType] = [.image, .pdf, .text],
        onAttachmentSaved: @escaping (AttachmentEntity) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        self.onAttachmentSaved = onAttachmentSaved
        self.onError = onError
        self.attachmentHandler = AttachmentHandler(
            maxFileSize: maxFileSize,
            allowedTypes: allowedTypes
        )
    }
    
    var body: some View {
        VStack {
            Button(action: { showingActionSheet = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Attachment")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(isLoading)
            .overlay {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                }
            }
        }
        .padding(.horizontal)
        .confirmationDialog("Add Attachment", isPresented: $showingActionSheet) {
            Button("Take Photo") { showingCamera = true }
            Button("Choose Photo") { showingImagePicker = true }
            Button("Choose File") { showingFilePicker = true }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showingCamera) {
            ImagePicker { image in
                handleImage(image)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
       
            // Replace the existing PhotosPicker implementation with:
            PhotosPicker(
                selection: $photosPickerItem,
                matching: .images
            ) {
                Text("Choose Photo")
            }
            .onChange(of: photosPickerItem) { newItem in
                if let newItem {
                    handlePhotosPicker(newItem)
                }
            }
        }
        .sheet(isPresented: $showingFilePicker) {
            DocumentPicker { url in
                handleFile(url)
            }
        }
    }
    
    private func handleFile(_ url: URL) {
        Task {
            isLoading = true
            do {
                let attachment = try await attachmentHandler.saveAttachment(from: url)
                await MainActor.run {
                    onAttachmentSaved(attachment)
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    onError(error)
                    isLoading = false
                }
            }
        }
    }
    
    private func handleImage(_ image: UIImage) {
        Task {
            isLoading = true
            do {
                let attachment = try await attachmentHandler.saveAttachment(image: image)
                await MainActor.run {
                    onAttachmentSaved(attachment)
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    onError(error)
                    isLoading = false
                }
            }
        }
    }
    
    // Add this function to AttachmentActionsView
    private func handlePhotosPicker(_ item: PhotosPickerItem) {
        Task {
            isLoading = true
            do {
                guard let data = try await item.loadTransferable(type: Data.self),
                      let image = UIImage(data: data) else {
                    throw AttachmentHandlerError.fileAccessFailed
                }
                let attachment = try await attachmentHandler.saveAttachment(image: image)
                await MainActor.run {
                    onAttachmentSaved(attachment)
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    onError(error)
                    isLoading = false
                }
            }
        }
    }
}
//
//// MARK: - Example Usage
//struct AttachmentExampleView: View {
//    @State private var attachments: [AttachmentFile] = []
//    @State private var showError = false
//    @State private var errorMessage = ""
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            // List of attachments
//            AttachmentListView(
//                attachments: attachments,
//                onDeleteAttachment: { attachment in
//                    if let index = attachments.firstIndex(where: { $0.id == attachment.id }) {
//                        attachments.remove(at: index)
//                    }
//                },
//                onAttachmentTapped: { attachment in
//                    // Handle attachment tap (e.g., preview file)
//                    print("Tapped attachment: \(attachment.name)")
//                }
//            )
//            
//            // Add attachment button
//            AttachmentActionsView(
//                maxFileSize: 10_000_000, // 10MB
//                allowedTypes: [.image, .pdf, .text],
//                onAttachmentSaved: { attachment in
//                    attachments.append(attachment)
//                },
//                onError: { error in
//                    errorMessage = error.localizedDescription
//                    showError = true
//                }
//            )
//        }
//        .alert("Error", isPresented: $showError) {
//            Button("OK") { }
//        } message: {
//            Text(errorMessage)
//        }
//    }
//}
