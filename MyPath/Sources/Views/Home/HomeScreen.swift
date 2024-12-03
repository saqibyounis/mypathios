//
//  Home.swift
//  MyPath
//
//  Created by Saqib Younis on 30/11/2024.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        NavigationView {
           
             List {
                    NavigationLink(destination: TargetListView()) {
                    VStack(alignment: .leading) {
                        Text("Targets")
                            .font(.headline)
                        Text("View all the targets")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }}
                
             
                 NavigationLink(destination:  TargetFormView()) {
                     VStack(alignment: .leading) {
                         Text("Add new Target")
                             .font(.headline)
                         Text("Create new target")
                             .font(.subheadline)
                             .foregroundColor(.secondary)
                     }}
                
             }.navigationTitle("Home")
            }
        
        
    }
}

//struct HomeScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeScreen()
//    }
//}
