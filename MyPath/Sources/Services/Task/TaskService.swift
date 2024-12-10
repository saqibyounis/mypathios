//
//  TaskService.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import Foundation
import RxSwift
import RealmSwift

// MARK: - Service Protocol and Implementation
protocol TaskService {
    func createTask(name: String, description: String?, duration: Int?, parentTargetId: String?, status: TaskStatus?) -> Completable
    func updateTask(_ task: TaskEntity) -> Completable
    func deleteTask(_ task: TaskEntity) -> Completable
    func getTask(id: String) -> Single<TaskEntity?>
    func getAllTasks() -> Observable<Results<TaskEntity>>
    func getTasksByTarget(targetId: String) -> Observable<Results<TaskEntity>>
    func updateTaskStatus(_ task: TaskEntity, status: TaskStatus) -> Completable
    func addAttachment(_ task: TaskEntity, atachment: AttachmentEntity) -> Completable
    func updateTaskProgress(_ task: TaskEntity) -> Completable
}
