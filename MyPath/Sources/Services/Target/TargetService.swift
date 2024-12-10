//
//  TargetService.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//
import Foundation
import RealmSwift
import RxSwift


protocol TargetService {
    func createTarget(name: String, deadline: Date?, parentGoalId: String?) -> Completable
    func updateTarget(_ target: TargetEntity) -> Completable
    func deleteTarget(_ target: TargetEntity) -> Completable
    func getTarget(id: String) -> Single<TargetEntity?>
    func getAllTargets() -> Observable<Results<TargetEntity>>
    func getTargetsByParentGoal(goalId: String) -> Observable<Results<TargetEntity>>
    func updateTargetProgress(_ target: TargetEntity, progress: Double) -> Completable
}
