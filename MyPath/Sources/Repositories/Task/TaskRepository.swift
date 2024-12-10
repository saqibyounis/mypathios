//
//  TaskRepository.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import Foundation
import RxSwift
import RealmSwift

// MARK: - Repository Protocol
protocol TaskRepository {
    func create(_ task: TaskEntity) -> Completable
    func update(_ task: TaskEntity) -> Completable
    func delete(_ task: TaskEntity) -> Completable
    func fetch(id: String) -> Single<TaskEntity?>
    func fetchAll() -> Observable<Results<TaskEntity>>
    func fetchByParentTarget(targetId: String) -> Observable<Results<TaskEntity>>
}
