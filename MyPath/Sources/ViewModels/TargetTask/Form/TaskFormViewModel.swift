//
//  TaskFormViewMOdel.swift
//  MyPath
//
//  Created by Saqib Younis on 02/12/2024.
//

import RealmSwift
import Foundation

class TaskViewModel: ObservableObject {
    @Published var id: String
    @Published var icon: String?
    @Published var title: String
    @Published var descriptionText: String
    @Published var classification: Classification
    @Published var duration: Double
    @Published var createdTime: Int
    @Published var scheduledTime: Int?
    @Published var actualStartTime: Int?
    @Published var actualEndTime: Int?
    @Published var status: TaskStatus
    @Published var priorityScore: Double
    @Published var source: TaskSource
    @Published var externalId: String?
    @Published var metadata: [MetaData]
    @Published var targetId: String
    @Published var files: [String]
    
    private let taskService: TargetTaskService
    private var taskEntity: TaskEntity
    
    init(taskEntity: TaskEntity, taskService: TargetTaskService) {
        self.taskService = taskService
        self.taskEntity = taskEntity
        
        self.id = taskEntity.id
        self.icon = taskEntity.icon
        self.title = taskEntity.title
        self.descriptionText = taskEntity.descriptionText
        self.classification = taskEntity.classification
        self.duration = taskEntity.duration
        self.createdTime = taskEntity.createdTime
        self.scheduledTime = taskEntity.scheduledTime
        self.actualStartTime = taskEntity.actualStartTime
        self.actualEndTime = taskEntity.actualEndTime
        self.status = taskEntity.status
        self.priorityScore = taskEntity.priorityScore
        self.source = taskEntity.source
        self.externalId = taskEntity.externalId
        self.metadata = Array(taskEntity.metadata)
        self.targetId = taskEntity.targetId
        self.files = Array(taskEntity.files)
    }
    
    
    
//    func updateTask(title: String, description: String, status: TaskStatus) {
//        taskEntity.title = title
//        taskEntity.descriptionText = description
//        taskEntity.status = status
//        
//        taskService.update(task: taskEntity)
//        
//        self.title = title
//        self.descriptionText = description
//        self.status = status
//    }
//    
   
}
