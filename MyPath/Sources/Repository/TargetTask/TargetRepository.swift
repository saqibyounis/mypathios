//
//  TargetRepository.swift
//  MyPath
//
//  Created by Saqib Younis on 29/11/2024.
//

import Foundation
import RealmSwift

// Repository for managing database operations for TargetEntity
class TargetRepository {

    private let realm: Realm

    init() {
    
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                }
            }
        )
        

        Realm.Configuration.defaultConfiguration = config
        
  
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Error initializing Realm: \(error.localizedDescription)")
        }
    }

    func getAllTargets() -> Results<TargetEntity> {
        return realm.objects(TargetEntity.self)
    }

    func getTarget(by id: String) -> TargetEntity? {
        return realm.object(ofType: TargetEntity.self, forPrimaryKey: id)
    }

    func addTarget(target: TargetEntity) {
        try! realm.write {
            realm.add(target)
        }
    }

    func updateTarget(target: TargetEntity) {
        try! realm.write {
            realm.add(target, update: .modified)
        }
    }

    func deleteTarget(target: TargetEntity) {
        try! realm.write {
            realm.delete(target)
        }
    }
}

