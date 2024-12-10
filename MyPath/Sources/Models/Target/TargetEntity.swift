//
//  TargetEntity.swift
//  MyPath
//
//  Created by Saqib Younis on 07/12/2024.
//


import Foundation
import RealmSwift

class TargetEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var deadline: Int? // Unix timestamp in milliseconds
    @Persisted var progress: Double = 0.0
    @Persisted var parentGoalId: String? // Making parent goal optional by storing just the ID
    @Persisted var tasks: List<TaskEntity> = List<TaskEntity>()
    
    convenience init(name: String, deadline: Date? = nil, parentGoalId: String? = nil) {
        self.init()
        self.name = name
        self.parentGoalId = parentGoalId
        self.deadline = deadline != nil ?
            Int(deadline!.timeIntervalSince1970 * 1000) :
            Int(Calendar.current.date(byAdding: .month, value: 3, to: Date())!.timeIntervalSince1970 * 1000)
    }
    
    func calculateProgress() -> Double {
        if tasks.isEmpty { return 0.0 }
        let completedTasks = tasks.filter { $0.status == .completed }.count
        return Double(completedTasks) / Double(tasks.count) * 100
    }
}
