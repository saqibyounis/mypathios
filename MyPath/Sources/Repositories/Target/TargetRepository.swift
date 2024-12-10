//
//  TargetRepository.swift
//  MyPath
//
//  Created by Saqib Younis on 29/11/2024.
//

import RxSwift
import RxSwiftExt
import RealmSwift


// MARK: - Repository Protocol
protocol TargetRepository {
    func create(_ target: TargetEntity) -> Completable
    func update(_ target: TargetEntity) -> Completable
    func delete(_ target: TargetEntity) -> Completable
    func fetch(id: String) -> Single<TargetEntity?>
    func fetchAll() -> Observable<Results<TargetEntity>>
    func fetchByParentGoal(goalId: String) -> Observable<Results<TargetEntity>>
}
