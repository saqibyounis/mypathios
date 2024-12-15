//
//  TaskFormViewModel.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//
import SwiftUI
import RxSwift
import Resolver

class TaskFormViewModel: ObservableObject {
    private let service: TaskServiceImpl
    private let disposeBag = DisposeBag()
    private let targetId: String?
    private let task: TaskEntity?
    
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var duration: Double = 30
    @Published var dificultyLevel: Double = 0
    @Published var status: TaskStatus = .started
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isSaving: Bool = false
    @Published var shouldDismiss: Bool = false
    @Published var isLoading: Bool = false
    @Published var selectedPriority: Priority = .low
    @Published var startDate: Date = Date().addingTimeInterval(7776000)

    
    init(service: TaskServiceImpl, targetId: String?, task: TaskEntity?) {
        self.service = service
        self.targetId = targetId
        self.task = task
        
        if let task = task {
            loadTask(task: task)
        }
    }
    
    private func loadTask(task: TaskEntity) {
        isLoading = true
        self.name = task.name
        self.description = task.taskDescription ?? ""
        self.duration = Double(task.duration ?? Int(0.0))
        self.status = task.status
        self.isLoading = false
        
    }
    
    func saveTask() {
        guard isFormValid else { return }
        isSaving = true
        
        let observable: Completable
        if let task = task {
            let realmManager: RealmManager = Resolver.resolve()
            let realm = realmManager.realm
            do{
                try realm?.write{
                    task.duration = Int(duration)
                    task.status = status
                    task.name = name
                    task.taskDescription = description.isEmpty ? nil : description
                }
            }catch {}
            observable = service.updateTask(task)
        } else {
            observable = service.createTask(
                name: name,
                description: description.isEmpty ? nil : description,
                duration: Int(duration),
                parentTargetId: targetId,
                status: status
            )
        }
        
        observable
            .observe(on: MainScheduler.instance)
            .subscribe(
                onCompleted: { [weak self] in
                    self?.isSaving = false
                    self?.shouldDismiss = true
                },
                onError: { [weak self] error in
                    self?.isSaving = false
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                }
            )
            .disposed(by: disposeBag)
    }
    
    var isFormValid: Bool {
        !name.isEmpty && duration >= 5 && duration <= 240
    }
}
