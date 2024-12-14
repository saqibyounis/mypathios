//
//  AttachmentHandler.swift
//  MyPath
//
//  Created by Saqib Younis on 11/12/2024.
//
import SwiftUI
import RxSwift
import PhotosUI
import Foundation


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
            let type = determineAttachmentType(from: url)
            let savedUrl = try fileManager.saveAttachment(originalUrl: url, filename: url.lastPathComponent)
            let thumbnailPath = try fileManager.generateAndSaveThumbnail(for: savedUrl, type: type)

            
            return AttachmentEntity(
                id: UUID().uuidString,
                name: url.lastPathComponent,
                type: type,
                size: size,
                localPath: savedUrl.lastPathComponent,
                thumbnailPath: thumbnailPath
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

