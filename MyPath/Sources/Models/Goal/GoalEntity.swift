//
//  GoalEntity.swift
//  MyPath
//
//  Created by Saqib Younis on 07/12/2024.
//

import Foundation
import RealmSwift



class GoalEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var goalDescription: String?
    @Persisted var startDate: Int = Int(Date().timeIntervalSince1970 * 1000)
    @Persisted var progress: Double = 0.0
    
    convenience init(name: String, description: String? = nil) {
        self.init()
        self.name = name
        self.goalDescription = description
        self.startDate = Int(Date().timeIntervalSince1970 * 1000)
    }
    
    func calculateProgress() -> Double {
        
        return 0.0
        
        
    }
    
    func copy(withNewId: Bool = true) -> GoalEntity {
        let copiedGoal = GoalEntity()
        copiedGoal.id = withNewId ? UUID().uuidString : self.id
        copiedGoal.name = self.name
        copiedGoal.goalDescription = self.goalDescription
        copiedGoal.startDate = self.startDate
        copiedGoal.progress = self.progress
        return copiedGoal
    }
}
