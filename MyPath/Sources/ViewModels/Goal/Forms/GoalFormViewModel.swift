//
//  GoalFormView.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftUI


class GoalFormViewModel: ObservableObject {
    private let goalService: GoalServiceImpl
    private let disposeBag = DisposeBag()
    
    // Published properties for form fields
    @Published var name = ""
    @Published var description = ""
    @Published var startDate = Date()
    @Published var progress: Double = 0
    @Published var selectedType: GoalType = .shortTerm
    @Published var selectedPriority: Priority = .low
    
    // Validation state
    @Published var isValid = false
    @Published var isSaving = false
    // Changed to a regular property with didSet observer
        private var _errorMessage: String?
        var errorMessage: String? {
            get { _errorMessage }
            set {
                objectWillChange.send()
                _errorMessage = newValue
            }
        }
    init(goalService: GoalServiceImpl) {
        self.goalService = goalService
        setupValidation()
    }
    
    private func setupValidation() {
        // Observe name changes for validation
        $name
            .map { !$0.isEmpty }
            .assign(to: &$isValid)
    }
   
    
    func saveGoal() -> Completable {
        isSaving = true
        
        return goalService.createGoal(name: name, description: description)
            .do(
                onError: { [weak self] error in
                    DispatchQueue.main.async {
                        self?.errorMessage = error.localizedDescription
                        print(self?.errorMessage ?? "")
                    }
                }, onSubscribe: { [weak self] in
                    DispatchQueue.main.async {
                        self?.isSaving = true
                    }
                },
                onDispose: { [weak self] in
                    DispatchQueue.main.async {
                        self?.isSaving = false
                    }
                }
            )
            .asCompletable()
    }
    
    
    func reset() {
        name = ""
        description = ""
        startDate = Date()
        progress = 0
        selectedType = .shortTerm
        selectedPriority = .low
        errorMessage = nil
    }
}



// View extension to use ViewModel
extension GoalFormView {
    static func makeViewModel() -> GoalFormViewModel {
        let service = GoalServiceFactory.makeService()
        return GoalFormViewModel(goalService: service)
    }
}
