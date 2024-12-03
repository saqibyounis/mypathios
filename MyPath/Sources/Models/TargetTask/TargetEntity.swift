//
//  TargetEntity.swift
//  MyPath
//
//  Created by Saqib Younis on 29/11/2024.
//

import Foundation
import RealmSwift

class TargetEntity: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var userId: String
    @Persisted var name: String
    @Persisted var descriptionText: String?
    @Persisted var category: String?
    @Persisted var icon: String?
    @Persisted var creationDate: Int
    @Persisted var startDate: Int?
    @Persisted var intendedCompletionDate: Int?
    @Persisted var status: TargetStatus
    @Persisted var priority: TargetPriority
    @Persisted var targetType: TargetType
    
    

    convenience init(id: String, userId: String, name: String, icon: String, creationDate: Int, intendedCompletionDate: Int, descriptionText: String?, status: TargetStatus, priority: TargetPriority, targetType: TargetType) {
        self.init()
        self.id = id
        self.userId = userId
        self.name = name
        self.icon = icon
        self.creationDate = creationDate
        self.intendedCompletionDate = intendedCompletionDate
        self.descriptionText = descriptionText
        self.status = status
        self.priority = priority
        self.targetType = targetType
    }
}
