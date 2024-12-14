//
//  AttachmentEntity.swift
//  MyPath
//
//  Created by Saqib Younis on 09/12/2024.
//

import Foundation
import RealmSwift
import Foundation

// MARK: - Attachment Type Enum
enum AttachmentType: String, PersistableEnum {
    case image
    case pdf
    case other
    
    var iconName: String {
        switch self {
        case .image: return "photo"
        case .pdf: return "doc.text"
        case .other: return "doc"
        }
    }
}

// MARK: - Attachment Realm Object
class AttachmentEntity: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var typeRawValue: String
    @Persisted var size: Int64
    @Persisted var localPath: String
    @Persisted var createdAt: Date
    @Persisted var thumbnailPath: String?

    // Computed property for type
    var type: AttachmentType {
        get {
            AttachmentType(rawValue: typeRawValue) ?? .other
        }
        set {
            typeRawValue = newValue.rawValue
        }
    }
    
    var url: URL? {
        get {
            FileManagerService.shared.attachmentsDirectory.appendingPathComponent(localPath)
        }
    }
    
    var thumbnailUrl: URL? {
        guard let thumbnailPath = thumbnailPath else { return nil }
        return FileManagerService.shared.thumbnailsDirectory.appendingPathComponent(thumbnailPath)
    }
    
    
    
    convenience init(id: String = UUID().uuidString,
                    name: String,
                    type: AttachmentType,
                    size: Int64,
                     localPath: String, thumbnailPath: String?) {
        self.init()
        self.id = id
        self.name = name
        self.type = type
        self.size = size
        self.localPath = localPath
        self.createdAt = Date()
        self.thumbnailPath = thumbnailPath
    }
    
    // Convert to DTO
    func toAttachment() -> Attachment {
        Attachment(
            id: id,
            name: name,
            type: type,
            size: size,
            url: URL(string: localPath) ?? URL(fileURLWithPath: ""),
            thumbnailUrl: URL(string: thumbnailPath ?? "")
            
        )
    }
}

// MARK: - Extension for Attachment conversion
extension Attachment {
    func toRealmObject(taskId: String) -> AttachmentEntity {
        AttachmentEntity(
            id: id,
            name: name,
            type: type,
            size: size,
            localPath: url.path(),
            thumbnailPath: thumbnailUrl?.path() ?? nil
        )
    }
}

// MARK: - Attachment DTO
struct Attachment: Identifiable {
    let id: String
    let name: String
    let type: AttachmentType
    let size: Int64
    let url: URL
    let thumbnailUrl: URL?
}
