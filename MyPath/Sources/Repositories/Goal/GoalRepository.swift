//
//  GoalRepository.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

// MARK: - Repository Protocol
protocol GoalRepository {
    func create(_ goal: GoalEntity) -> Completable
    func update(_ goal: GoalEntity) -> Completable
    func delete(_ goal: GoalEntity) -> Completable
    func fetch(id: String) -> Single<GoalEntity?>
    func fetchAll() -> Observable<Results<GoalEntity>>
    func fetchActive() -> Observable<Results<GoalEntity>>
}
