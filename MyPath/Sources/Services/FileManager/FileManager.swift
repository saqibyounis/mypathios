import Foundation
import SwiftUI

// MARK: - File Manager Service
class FileManagerService {
    static let shared = FileManagerService()
    private let fileManager = FileManager.default
    
        private init() {
            // Create necessary directories
            try? fileManager.createDirectory(at: attachmentsDirectory, withIntermediateDirectories: true)
            try? fileManager.createDirectory(at: thumbnailsDirectory, withIntermediateDirectories: true)
        }
    // MARK: - Directory paths
    var attachmentsDirectory: URL {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let attachmentsPath = documentsPath.appendingPathComponent("Attachments", isDirectory: true)
        
        if !fileManager.fileExists(atPath: attachmentsPath.path) {
            try? fileManager.createDirectory(at: attachmentsPath, withIntermediateDirectories: true)
        }
        
        return attachmentsPath
    }
    
    var thumbnailsDirectory: URL {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let thumbnailsPath = documentsPath.appendingPathComponent("Thumbnails", isDirectory: true)
        
        if !fileManager.fileExists(atPath: thumbnailsPath.path) {
            try? fileManager.createDirectory(at: thumbnailsPath, withIntermediateDirectories: true)
        }
        return thumbnailsPath
        
    }
    
    // MARK: - File Operations
    func saveAttachment(originalUrl: URL, filename: String) throws -> URL {
        // Create a unique filename to avoid conflicts
        let uniqueFilename = UUID().uuidString + "_" + filename
        let destinationUrl = attachmentsDirectory.appendingPathComponent(uniqueFilename)
        
        // If file already exists, remove it
        if fileManager.fileExists(atPath: destinationUrl.path) {
            try fileManager.removeItem(at: destinationUrl)
        }
        
        // Copy file to app directory
        try fileManager.copyItem(at: originalUrl, to: destinationUrl)
        
        return destinationUrl
    }
    
    func deleteAttachment(at url: URL) throws {
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
    }
    
    func getFileSize(at url: URL) throws -> Int64 {
        let attributes = try fileManager.attributesOfItem(atPath: url.path)
        return attributes[.size] as? Int64 ?? 0
    }
    
    // MARK: - Thumbnail Operations
    func generateAndSaveThumbnail(for url: URL, type: AttachmentType) throws -> String? {
        switch type {
        case .image:
            return try generateImageThumbnail(for: url)
        case .pdf:
            return try generatePDFThumbnail(for: url)
        case .other:
            return nil
        }
    }
    
    private func generateImageThumbnail(for url: URL) throws -> String {
        guard let image = UIImage(contentsOfFile: url.path) else {
            throw AttachmentHandlerError.fileAccessFailed
        }
        
        let thumbnailSize = CGSize(width: 300, height: 300)
        let thumbnailImage = image.preparingThumbnail(of: thumbnailSize)
        
        let thumbnailName = "\(UUID().uuidString)_thumb.jpg"
        let thumbnailUrl = thumbnailsDirectory.appendingPathComponent(thumbnailName)
        
        guard let thumbnailImage = thumbnailImage,
              let data = thumbnailImage.jpegData(compressionQuality: 0.7) else {
            throw AttachmentHandlerError.fileAccessFailed
        }
        
        try data.write(to: thumbnailUrl)
        return thumbnailName
    }
    
    private func generatePDFThumbnail(for url: URL) throws -> String {
        guard let pdfDocument = CGPDFDocument(url as CFURL),
              let pdfPage = pdfDocument.page(at: 1) else {
            throw AttachmentHandlerError.fileAccessFailed
        }
        
        let pageRect = pdfPage.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        
        let thumbnailImage = renderer.image { context in
            UIColor.white.set()
            context.fill(pageRect)
            
            context.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            context.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            context.cgContext.drawPDFPage(pdfPage)
        }
        
        let thumbnailName = "\(UUID().uuidString)_thumb.jpg"
        let thumbnailUrl = thumbnailsDirectory.appendingPathComponent(thumbnailName)
        
        guard let data = thumbnailImage.jpegData(compressionQuality: 0.7) else {
            throw AttachmentHandlerError.fileAccessFailed
        }
        
        try data.write(to: thumbnailUrl)
        return thumbnailName
    }
}
