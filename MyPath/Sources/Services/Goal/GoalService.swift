//
//  GoalService.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import Foundation
import RxSwift
import RealmSwift
// MARK: - Service Protocol
protocol GoalService {
    func createGoal(name: String, description: String?) -> Single<GoalEntity>
    func updateGoal(_ goal: GoalEntity, name: String?, description: String?) -> Completable
    func deleteGoal(_ goal: GoalEntity) -> Completable
//    func addTarget(to goal: GoalEntity, name: String, deadline: Date?) -> Completable
//    func addTask(to goal: GoalEntity, name: String, description: String?, duration: Int?) -> Completable
    func observeGoals() -> Observable<Results<GoalEntity>>
    func observeActiveGoals() -> Observable<[GoalEntity]>
}
