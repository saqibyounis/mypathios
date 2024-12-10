//
//  TargetViewModel.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//


//
//  TargetViewModel.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//
import SwiftUI
import RxSwift
import RealmSwift

// MARK: - View Model
class TargetListViewModel: ObservableObject {
    private let service: TargetService
    private let disposeBag = DisposeBag()
    
    @Published var targets: [TargetEntity] = []
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var selectedFilter: TargetFilter = .all
    
    enum TargetFilter {
        case all
        case inProgress
        case completed
    }
    
    init(service: TargetService) {
        self.service = service
        fetchTargets()
    }
    
    func fetchTargets() {
        isLoading = true
        
        service.getAllTargets()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] results in
                    self?.isLoading = false
                    self?.updateTargets(from: results)
                },
                onError: { [weak self] error in
                    self?.isLoading = false
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func updateTargets(from results: Results<TargetEntity>) {
        let allTargets = Array(results)
        
        switch selectedFilter {
        case .all:
            targets = allTargets
        case .inProgress:
            targets = allTargets.filter { $0.progress < 100 }
        case .completed:
            targets = allTargets.filter { $0.progress >= 100 }
        }
    }
    
    func deleteTarget(_ target: TargetEntity) {
        isLoading = true
        
        service.deleteTarget(target)
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
}
