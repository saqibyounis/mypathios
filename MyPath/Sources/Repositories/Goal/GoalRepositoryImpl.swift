//
//  GoalRepositoryImpl.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import Foundation
import RealmSwift
import RxSwift
import Resolver

class GoalRepositoryImpl: GoalRepository {
    private let realm: Realm
    
    init(realmManager: RealmManager = Resolver.resolve()) {
        self.realm = realmManager.realm
       }
    
    
    func create(_ goal: GoalEntity) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(NSError(domain: "", code: -1)))
                return Disposables.create()
            }
            
            // Create configuration for background thread
            let configuration = self.realm.configuration
            
            DispatchQueue.global(qos: .background).async {
                do {
                    // Create new Realm instance for this thread
                    let backgroundRealm = try Realm(configuration: configuration)
                    
                    // Create a thread-safe copy of the goal
                    var threadSafeGoal = GoalEntity()
                    // Copy properties from original goal
                    threadSafeGoal = goal.copy()
                    
                    // Copy other properties...
                    
                    try backgroundRealm.write {
                        backgroundRealm.add(threadSafeGoal)
                        print("Goal saved, total count: \(backgroundRealm.objects(GoalEntity.self).count)")
                    }
                    
                    DispatchQueue.main.async {
                        completable(.completed)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completable(.error(error))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func update(_ goal: GoalEntity) -> Completable {
        return Completable.create { [weak self] completable in
            do {
                try self?.realm.write {
                    self?.realm.add(goal, update: .modified)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func delete(_ goal: GoalEntity) -> Completable {
        return Completable.create { [weak self] completable in
            do {
                try self?.realm.write {
                    self?.realm.delete(goal)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func fetch(id: String) -> Single<GoalEntity?> {
        return Single.create { [weak self] single in
            let goal = self?.realm.object(ofType: GoalEntity.self, forPrimaryKey: id)
            single(.success(goal))
            return Disposables.create()
        }
    }
    
    func fetchAll() -> Observable<Results<GoalEntity>> {
        let goals = self.realm.objects(GoalEntity.self)
        
        return Observable.create { [weak self] observer in
            let goals = self?.realm.objects(GoalEntity.self)
            if let goals = goals {
                observer.onNext(goals)
                print(goals.count ?? "None")

                let token = goals.observe { changes in
                    switch changes {
                    case .initial(let goals):
                        observer.onNext(goals)
                    case .update(let goals, _, _, _):
                        observer.onNext(goals)
                    case .error(let error):
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    token.invalidate()
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchActive() -> Observable<Results<GoalEntity>> {
        return Observable.create { [weak self] observer in
            let goals = self?.realm.objects(GoalEntity.self).where { $0.progress < 100 }
            if let goals = goals {
                observer.onNext(goals)
                
                let token = goals.observe { changes in
                    switch changes {
                    case .initial(let goals):
                        observer.onNext(goals)
                    case .update(let goals, _, _, _):
                        observer.onNext(goals)
                    case .error(let error):
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    token.invalidate()
                }
            }
            return Disposables.create()
        }
    }
}
