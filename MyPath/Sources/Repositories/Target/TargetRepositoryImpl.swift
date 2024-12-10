//
//  TargetRepositoryImpl.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//
import Foundation
import RealmSwift
import RxSwift
import Resolver

class TargetRepositoryImpl: TargetRepository {
    private let realm: Realm
    
    init(realmManager: RealmManager = Resolver.resolve()) {
        self.realm = realmManager.realm
       }
    
    
    func create(_ target: TargetEntity) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return Disposables.create()
            }
            
            do {
                try self.realm.write {
                    self.realm.add(target)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func update(_ target: TargetEntity) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return Disposables.create()
            }
            
            do {
                try self.realm.write {
                    self.realm.add(target, update: .modified)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func delete(_ target: TargetEntity) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return Disposables.create()
            }
            
            do {
                try self.realm.write {
                    self.realm.delete(target)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func fetch(id: String) -> Single<TargetEntity?> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return Disposables.create()
            }
            
            let target = self.realm.object(ofType: TargetEntity.self, forPrimaryKey: id)
            single(.success(target))
            return Disposables.create()
        }
    }
    
    func fetchAll() -> Observable<Results<TargetEntity>> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"]))
                return Disposables.create()
            }
            
            let targets = self.realm.objects(TargetEntity.self)
            observer.onNext(targets)
            
            let notificationToken = targets.observe { changes in
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
    
    func fetchByParentGoal(goalId: String) -> Observable<Results<TargetEntity>> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"]))
                return Disposables.create()
            }
            
            let targets = self.realm.objects(TargetEntity.self).filter("parentGoalId == %@", goalId)
            observer.onNext(targets)
            
            let notificationToken = targets.observe { changes in
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
