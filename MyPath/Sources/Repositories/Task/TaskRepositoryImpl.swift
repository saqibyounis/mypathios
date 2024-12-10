//
//  RealmTaskRepository.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import Foundation
import RealmSwift
import RxSwift
import Resolver

// MARK: - Repository Implementation
class TaskRepositoryImpl: TaskRepository {
    private let realm: Realm
    
    init(realmManager: RealmManager = Resolver.resolve()) {
        self.realm = realmManager.realm
       }
    
    
    func create(_ task: TaskEntity) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return Disposables.create()
            }
            
            do {
                try self.realm.write {
                    self.realm.add(task)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func update(_ task: TaskEntity) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return Disposables.create()
            }
            
            do {
                try self.realm.write {
                    self.realm.add(task, update: .modified)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func delete(_ task: TaskEntity) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return Disposables.create()
            }
            
            do {
                try self.realm.write {
                    self.realm.delete(task)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func fetch(id: String) -> Single<TaskEntity?> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return Disposables.create()
            }
            
            let task = self.realm.object(ofType: TaskEntity.self, forPrimaryKey: id)
            single(.success(task))
            return Disposables.create()
        }
    }
    
    func fetchAll() -> Observable<Results<TaskEntity>> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"]))
                return Disposables.create()
            }
            
            let tasks = self.realm.objects(TaskEntity.self)
            observer.onNext(tasks)
            
            let notificationToken = tasks.observe { changes in
                switch changes {
                case .initial(let results):
                    observer.onNext(results)
                case .update(let results, _, _, _):
                    observer.onNext(results)
                case .error(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                notificationToken.invalidate()
            }
        }
    }
    
    func fetchByParentTarget(targetId: String) -> Observable<Results<TaskEntity>> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"]))
                return Disposables.create()
            }
            
            let tasks = self.realm.objects(TaskEntity.self).filter("parentTargetId == %@", targetId)
            observer.onNext(tasks)
            
            let notificationToken = tasks.observe { changes in
                switch changes {
                case .initial(let results):
                    observer.onNext(results)
                case .update(let results, _, _, _):
                    observer.onNext(results)
                case .error(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                notificationToken.invalidate()
            }
        }
    }
}
