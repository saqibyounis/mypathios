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
    
    
    
    convenience init(id: String = UUID().uuidString,
                    name: String,
                    type: AttachmentType,
                    size: Int64,
                     localPath: String) {
        self.init()
        self.id = id
        self.name = name
        self.type = type
        self.size = size
        self.localPath = localPath
        self.createdAt = Date()
    }
    
    // Convert to DTO
    func toAttachment() -> Attachment {
        Attachment(
            id: id,
            name: name,
            type: type,
            size: size,
            url: URL(string: localPath) ?? URL(fileURLWithPath: "")
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
            localPath: url.path()
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
}
