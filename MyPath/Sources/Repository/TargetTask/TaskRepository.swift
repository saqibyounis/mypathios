//
//  TaskRepository.swift
//  MyPath
//
//  Created by Saqib Younis on 29/11/2024.
//

import Foundation
import RealmSwift

// Repository for managing database operations for TaskEntity
class TaskRepository {
    private let realm = try! Realm()

    func getAllTasks() -> Results<TaskEntity> {
        return realm.objects(TaskEntity.self)
    }

    func getTask(by id: String) -> TaskEntity? {
        return realm.object(ofType: TaskEntity.self, forPrimaryKey: id)
    }

    func addTask(task: TaskEntity) {
        try! realm.write {
            realm.add(task)
        }
    }

    func updateTask(task: TaskEntity) {
        try! realm.write {
            realm.add(task, update: .modified)
        }
    }

    func deleteTask(task: TaskEntity) {
        try! realm.write {
            realm.delete(task)
        }
    }
    

       func getTasks(startTimestamp: Int, endTimestamp: Int) -> Results<TaskEntity> {
           return realm.objects(TaskEntity.self).filter("scheduledTime >= %@ AND scheduledTime <= %@", startTimestamp, endTimestamp)
       }
    

}
