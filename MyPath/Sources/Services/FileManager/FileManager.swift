import Foundation

// MARK: - File Manager Service
class FileManagerService {
    static let shared = FileManagerService()
    private let fileManager = FileManager.default
    
    // MARK: - Directory paths
    var attachmentsDirectory: URL {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let attachmentsPath = documentsPath.appendingPathComponent("Attachments", isDirectory: true)
        
        if !fileManager.fileExists(atPath: attachmentsPath.path) {
            try? fileManager.createDirectory(at: attachmentsPath, withIntermediateDirectories: true)
        }
        
        return attachmentsPath
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
}

