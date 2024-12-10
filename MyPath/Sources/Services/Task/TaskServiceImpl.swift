//
//  TaskServiceImpl.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import Foundation
import RxSwift
import RealmSwift
import Resolver

class TaskServiceImpl: TaskService {
   
    
    private let repository: TaskRepositoryImpl
    
    init(repository: TaskRepositoryImpl) {
        self.repository = repository
    }
    
    func createTask(name: String, description: String?, duration: Int?, parentTargetId: String?, status: TaskStatus?) -> Completable {
        let task = TaskEntity(name: name, description: description, duration: duration, parentTargetId: parentTargetId, status: status)
        return repository.create(task)
    }
    
    func addAttachment(_ task: TaskEntity, atachment: AttachmentEntity) -> RxSwift.Completable {
        
        do {
            let realmManager: RealmManager = try  Resolver.resolve()
            let realm: Realm = realmManager.realm
            try realm.write {
                task.attachments.append(atachment)
            }
            return repository.update(task)
        } catch let error {
            return Completable.error(error) // Return error as a Completable
        }
    }
    
    func updateTask(_ task: TaskEntity) -> Completable {
        return repository.update(task)
    }
    
    func deleteTask(_ task: TaskEntity) -> Completable {
        return repository.delete(task)
    }
    
    func getTask(id: String) -> Single<TaskEntity?> {
        return repository.fetch(id: id)
    }
    
    func getAllTasks() -> Observable<Results<TaskEntity>> {
        return repository.fetchAll()
    }
    
    func getTasksByTarget(targetId: String) -> Observable<Results<TaskEntity>> {
        return repository.fetchByParentTarget(targetId: targetId)
    }
    
    func updateTaskStatus(_ task: TaskEntity, status: TaskStatus) -> Completable {
        do {
            let realmManager: RealmManager = try  Resolver.resolve()
            let realm: Realm = realmManager.realm
            try realm.write {
                task.status = status
                if status == .completed {
                    task.completedAt = Int(Date().timeIntervalSince1970 * 1000)
                }
            }
            return repository.update(task)
        } catch let error {
            return Completable.error(error) // Return error as a Completable
        }
    }
    
    func updateTaskProgress(_ task: TaskEntity) -> Completable {
        task.progress = task.calculateProgress()
        return repository.update(task)
    }
}

// MARK: - Factory
class TaskServiceFactory {
    static func makeService() -> TaskServiceImpl {
        do {
            let repository = try TaskRepositoryImpl()
            return TaskServiceImpl(repository: repository)
        } catch {
            fatalError("Failed to initialize TaskService: \(error)")
        }
    }
}
