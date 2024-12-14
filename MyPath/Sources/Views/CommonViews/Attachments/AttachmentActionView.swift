//
//  AttachmentActionView.swift
//  MyPath
//
//  Created by Saqib Younis on 11/12/2024.
//

import SwiftUI
import RxSwift
import PhotosUI

import Foundation
import UIKit

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
