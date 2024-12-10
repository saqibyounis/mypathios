//
//  Untitled.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import Resolver

extension Resolver {
    public static func registerAllServices() {
        
        // Register RealmManager as a singleton
        register { RealmManager.shared }
            .scope(.application) // This ensures it remains a singleton
        
        //        // Register ViewModels
        //        register { HomeViewModel(service: resolve()) }
        //
        //        // Register Services
        //        register { DataService() as DataServiceProtocol }
        
    }
}

