//
//  TaskEntity.swift
//  MyPath
//
//  Created by Saqib Younis on 07/12/2024.
//
import Foundation
import RealmSwift
import RxSwift

// MARK: - Entity
class TaskEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var taskDescription: String?
    @Persisted var duration: Int? // Duration in minutes
    @Persisted var status: TaskStatus = .inProgress
    @Persisted var progress: Double = 0.0
    @Persisted var dificultyLevel: Double = 0.0
    @Persisted var createdAt: Int = Int(Date().timeIntervalSince1970 * 1000)
    @Persisted var completedAt: Int?
    @Persisted var parentTargetId: String? // Making parent target optional
    @Persisted var routines: List<RoutineEntity> = List<RoutineEntity>()
    @Persisted var attachments: List<AttachmentEntity> = List<AttachmentEntity>()
    
    
    convenience init(name: String, description: String? = nil, duration: Int? = 30, parentTargetId: String? = nil, status: TaskStatus? = nil) {
        self.init()
        self.name = name
        self.taskDescription = description
        self.duration = duration
        self.parentTargetId = parentTargetId
        if let status {
            self.status = status
        }
    }
    
    func calculateProgress() -> Double {
        if routines.isEmpty {
            return status == .completed ? 100.0 : 0.0
        }
        let completedRoutines = routines.filter { $0.isCompleted }.count
        return Double(completedRoutines) / Double(routines.count) * 100
    }
}

