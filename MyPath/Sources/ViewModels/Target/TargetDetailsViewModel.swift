//
//  TargetDetailsViewModel.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import Foundation
import RxSwift
import RealmSwift


// MARK: - View Model
class TargetDetailsViewModel: ObservableObject {
    private let targetService: TargetService
    private let taskService: TaskService
    private let disposeBag = DisposeBag()
    
    let target: TargetEntity
    
    @Published var tasks: [TaskEntity] = []
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var showingAddTask: Bool = false
    @Published var selectedTaskFilter: TaskStatus?
    
    init(target: TargetEntity, targetService: TargetService, taskService: TaskService) {
        self.target = target
        self.targetService = targetService
        self.taskService = taskService
        fetchTasks()
    }
    
    func fetchTasks() {
        isLoading = true
        
        taskService.getTasksByTarget(targetId: target.id)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] results in
                    self?.isLoading = false
                    self?.updateTasks(from: results)
                },
                onError: { [weak self] error in
                    self?.isLoading = false
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func updateTasks(from results: Results<TaskEntity>) {
        var filteredTasks = Array(results)
        
        if let filter = selectedTaskFilter {
            filteredTasks = filteredTasks.filter { $0.status == filter }
        }
        
        tasks = filteredTasks.sorted { $0.createdAt > $1.createdAt }
    }
    
    func deleteTask(_ task: TaskEntity) {
        isLoading = true
        
        taskService.deleteTask(task)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onCompleted: { [weak self] in
                    self?.isLoading = false
                },
                onError: { [weak self] error in
                    self?.isLoading = false
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                }
            )
            .disposed(by: disposeBag)
    }
    
    func updateTaskStatus(_ task: TaskEntity, status: TaskStatus) {
        taskService.updateTaskStatus(task, status: status)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onError: { [weak self] error in
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                }
            )
            .disposed(by: disposeBag)
    }
}
