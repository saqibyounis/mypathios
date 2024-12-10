//
//  MyPathApp.swift
//  MyPath
//
//  Created by Saqib Younis on 25/11/2024.
//

import SwiftUI
import Resolver

@main
struct MyPathApp: App {
    init() {
           RealmManager.shared.configure()
           // Ensure all services are registered before app launches
           Resolver.registerAllServices()
       }

    var body: some Scene {
        WindowGroup {
            HomeScreen()
        }
    
    }
}
