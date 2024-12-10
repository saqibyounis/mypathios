//
//  GoalServiceImpl.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import Foundation
import RxSwift
import RealmSwift

// MARK: - Service Implementation
class GoalServiceImpl: GoalService {
   
    
    private let repository: GoalRepositoryImpl
    private let disposeBag = DisposeBag()
    
    init(repository: GoalRepositoryImpl) {
        self.repository = repository
    }
    
    
    func createGoal(name: String, description: String?) -> Single<GoalEntity> {
        let goal = GoalEntity(name: name, description: description)
        return repository.create(goal)
            .andThen(Single.just(goal))
    }
    
    func updateGoal(_ goal: GoalEntity, name: String?, description: String?) -> Completable {
        if let name = name { goal.name = name }
        if let description = description { goal.goalDescription = description }
        return repository.update(goal)
    }
    
    func deleteGoal(_ goal: GoalEntity) -> Completable {
        return repository.delete(goal)
    }
    
//    func addTarget(to goal: GoalEntity, name: String, deadline: Date?) -> Completable {
//        let target = TargetEntity(name: name, deadline: deadline)
//        goal.targets.append(target)
//        return repository.update(goal)
//    }
    
  
    
    func observeGoals() -> Observable<Results<GoalEntity>> {
        return repository.fetchAll()
    }
    
    func observeActiveGoals() -> Observable<[GoalEntity]> {
        return repository.fetchActive()
            .map { Array($0) }
    }
}

// MARK: - Factory
class GoalServiceFactory {
    static func makeService() -> GoalServiceImpl {
        let repository =  GoalRepositoryImpl()
        return GoalServiceImpl(repository: repository)
    }
}
