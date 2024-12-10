//
//  TaskViewModel.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import SwiftUI
import RxSwift
import RealmSwift

// MARK: - View Model
class TaskListViewModel: ObservableObject {
    private let service: TaskServiceImpl
    private let disposeBag = DisposeBag()
    
    @Published var tasks: [TaskEntity] = []
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var selectedFilter: TaskFilter = .all
    
    enum TaskFilter {
        case all
        case active
        case completed
    }
    
    init(service: TaskServiceImpl) {
        self.service = service
        fetchTasks()
    }
    
    func fetchTasks() {
        isLoading = true
        
        service.getAllTasks()
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
        let allTasks = Array(results)
        
        switch selectedFilter {
        case .all:
            tasks = allTasks
        case .active:
            tasks = allTasks.filter { $0.status != .completed }
        case .completed:
            tasks = allTasks.filter { $0.status == .completed }
        }
    }
    
    func deleteTask(_ task: TaskEntity) {
        isLoading = true
        
        service.deleteTask(task)
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
        service.updateTaskStatus(task, status: status)
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


