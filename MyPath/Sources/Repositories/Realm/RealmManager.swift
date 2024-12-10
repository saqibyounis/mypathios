//
//  RealmManager.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    
    private(set) var realm: Realm!
    
    private init() {    }
    
    func configure() {
        let config = Realm.Configuration(
            schemaVersion: 7,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 7 {
                    // Perform migration steps here
                }
            }
        )
        
        Realm.Configuration.defaultConfiguration = config
        
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    // Helper method for testing
    func configureForTesting() {
        let config = Realm.Configuration(
            inMemoryIdentifier: "test-realm",
            schemaVersion: 1,
            deleteRealmIfMigrationNeeded: true
        )
        
        do {
            realm = try Realm(configuration: config)
        } catch {
            fatalError("Failed to initialize test Realm: \(error.localizedDescription)")
        }
    }
}
