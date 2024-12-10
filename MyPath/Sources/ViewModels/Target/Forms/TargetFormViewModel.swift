//
//  TargetFormViewModel.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//


import SwiftUI
import RxSwift

// MARK: - View Model
class TargetFormViewModel: ObservableObject {
    private let service: TargetServiceImpl
    private let disposeBag = DisposeBag()
    private let goalId: String?
    
    @Published var name: String = ""
    @Published var deadline: Date = Date().addingTimeInterval(7776000)
    @Published var hasDeadline: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isSaving: Bool = false
    @Published var shouldDismiss: Bool = false
    
    init(service: TargetServiceImpl, goalId: String?) {
        self.service = service
        self.goalId = goalId
    }
    
    func saveTarget() {
        guard !name.isEmpty else { return }
        isSaving = true
        
        service.createTarget(
            name: name,
            deadline: hasDeadline ? deadline : nil,
            parentGoalId: goalId
        )
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
        !name.isEmpty
    }
}
