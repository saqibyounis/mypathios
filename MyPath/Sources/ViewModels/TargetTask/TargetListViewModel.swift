//
//  TargetViewModel.swift
//  MyPath
//
//  Created by Saqib Younis on 02/12/2024.
//

import Foundation
import RealmSwift

// ViewModel for Target List
class TargetListViewModel: ObservableObject {
    @Published var targets: [TargetEntity] = []

    private let repository = TargetRepository() // Replace with your TaskRepository if shared

    init() {
        fetchTargets()
    }

    func fetchTargets() {
        targets = Array(repository.getAllTargets())
    }
}

