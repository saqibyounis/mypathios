//
//  TargetFormViewModel.swift
//  MyPath
//
//  Created by Saqib Younis on 30/11/2024.
//

import Foundation
import RxSwift

class TargetFormViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var descriptionText: String = ""
    @Published var startDate: Date?
    @Published var intendedFinishDate: Date?
    @Published var icon: String = ""
    @Published var category: String = ""
    @Published var predefinedCategories = ["Work", "Personal", "Health", "Finance", "Custom"]
    @Published var targetStatus: TargetStatus = .started
    @Published var targetType: TargetType = .shortTerm
    @Published var targetPriority: TargetPriority = .medium

    
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    private let targetService: TargetTaskService

    init(targetService: TargetTaskService = TargetTaskService()) {
        self.targetService = targetService
    }

    func validateAndSaveTarget() -> Bool {
        if name.isEmpty {
            showError = true
            errorMessage = "Target name is required."
            return false
        }
        
        if category.isEmpty {
            showError = true
            errorMessage = "Target category is required."
            return false
        }
        let startDateTimestamp = Int((startDate?.timeIntervalSince1970 ?? -1) * 1000)
        let finishDateTimestamp = Int((intendedFinishDate?.timeIntervalSince1970 ?? -1) * 1000)
        let target = TargetEntity()
        target.name = name
        target.descriptionText = descriptionText.isEmpty ? nil : descriptionText
        target.creationDate = Int(Date().timeIntervalSince1970 * 1000)
        target.startDate = startDateTimestamp
        target.intendedCompletionDate = finishDateTimestamp
        target.icon = icon.isEmpty ? nil : icon
        target.category = category
        target.priority = targetPriority
        target.targetType = targetType
        target.status = targetStatus
        targetService.addTarget(target: target)
        return true
    }
}
