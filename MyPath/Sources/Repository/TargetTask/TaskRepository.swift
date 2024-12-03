//
//  TaskRepository.swift
//  MyPath
//
//  Created by Saqib Younis on 29/11/2024.
//
import Foundation
import RealmSwift

class TaskRepository {
    private let realm: Realm

    init() {
    
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                }
            }
        )
        

        Realm.Configuration.defaultConfiguration = config
        
  
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Error initializing Realm: \(error.localizedDescription)")
        }
    }


    func getAllTasks() -> Results<TaskEntity> {
        return realm.objects(TaskEntity.self)
    }


    func getTask(by id: String) -> TaskEntity? {
        return realm.object(ofType: TaskEntity.self, forPrimaryKey: id)
    }

    func addTask(task: TaskEntity) {
        do {
            try realm.write {
                realm.add(task)
            }
        } catch {
            print("Error adding task: \(error.localizedDescription)")
        }
    }


    func updateTask(task: TaskEntity) {
        do {
            try realm.write {
                realm.add(task, update: .modified)
            }
        } catch {
            print("Error updating task: \(error.localizedDescription)")
        }
    }


    func deleteTask(task: TaskEntity) {
        do {
            try realm.write {
                realm.delete(task)
            }
        } catch {
            print("Error deleting task: \(error.localizedDescription)")
        }
    }

    func getTasks(startTimestamp: Int, endTimestamp: Int) -> Results<TaskEntity> {
        return realm.objects(TaskEntity.self).filter("scheduledTime >= %@ AND scheduledTime <= %@", startTimestamp, endTimestamp)
    }
}
