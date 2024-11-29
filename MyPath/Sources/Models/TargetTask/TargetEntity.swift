//
//  TargetEntity.swift
//  MyPath
//
//  Created by Saqib Younis on 29/11/2024.
//

import Foundation
import RealmSwift

class TargetEntity: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var userId: String
    @Persisted var name: String
    @Persisted var icon: String?
    @Persisted var creationDate: Int
    @Persisted var intendedCompletionDate: Int?
    

    convenience init(id: String, userId: String, name: String, icon: String, creationDate: Int, intendedCompletionDate: Int) {
        self.init()
        self.id = id
        self.userId = userId
        self.name = name
        self.icon = icon
        self.creationDate = creationDate
        self.intendedCompletionDate = intendedCompletionDate
    }
}
