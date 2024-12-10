//
//  GoalListViewModel.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//
import RxSwift
import RxCocoa

class GoalsListViewModel: ObservableObject {
    @Published var goals: [GoalEntity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let goalService: GoalServiceImpl
    private let disposeBag = DisposeBag()
    
    init(goalService: GoalServiceImpl) {
        self.goalService = goalService
        loadGoals()
    }
    
    

    
    func loadGoals() {
      
        isLoading = true
        
        goalService.observeGoals()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] goals in
                    self?.goals = Array(goals)
                    self?.isLoading = false
                },
                onError: { [weak self] error in
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
            )
            .disposed(by: disposeBag)
    }
   
    
    func deleteGoal(_ goal: GoalEntity) {
        goalService.deleteGoal(goal)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onError: { [weak self] error in
                    self?.errorMessage = error.localizedDescription
                }
            )
            .disposed(by: disposeBag)
    }
}
