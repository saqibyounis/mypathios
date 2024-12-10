import Foundation
import RealmSwift
import RxSwift



class TargetServiceImpl: TargetService {
    private let repository: TargetRepositoryImpl
    private let disposeBag = DisposeBag()
    
    init(repository: TargetRepositoryImpl) {
        self.repository = repository
    }
    
    func createTarget(name: String, deadline: Date?, parentGoalId: String?) -> Completable {
        let target = TargetEntity(name: name, deadline: deadline, parentGoalId: parentGoalId)
        return repository.create(target)
    }
    
    func updateTarget(_ target: TargetEntity) -> Completable {
        return repository.update(target)
    }
    
    func deleteTarget(_ target: TargetEntity) -> Completable {
        return repository.delete(target)
    }
    
    func getTarget(id: String) -> Single<TargetEntity?> {
        return repository.fetch(id: id)
    }
    
    func getAllTargets() -> Observable<Results<TargetEntity>> {
        return repository.fetchAll()
    }
    
    func getTargetsByParentGoal(goalId: String) -> Observable<Results<TargetEntity>> {
        return repository.fetchByParentGoal(goalId: goalId)
    }
    
    func updateTargetProgress(_ target: TargetEntity, progress: Double) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return Disposables.create()
            }
            
            // Validate progress value
            guard progress >= 0 && progress <= 100 else {
                completable(.error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid progress value. Must be between 0 and 100"])))
                return Disposables.create()
            }
            
            // Update progress
            target.progress = progress
            
            // Save changes
            return self.repository.update(target)
                .subscribe { completable(.completed) } onError: { error in
                    completable(.error(error))
                }
        }
    }
}

// MARK: - Factory
class TargetServiceFactory {
    static func makeService() -> TargetServiceImpl {
        do {
            let repository = TargetRepositoryImpl()
            return TargetServiceImpl(repository: repository)
        } catch {
            fatalError("Failed to initialize TargetService: \(error)")
        }
    }
}
