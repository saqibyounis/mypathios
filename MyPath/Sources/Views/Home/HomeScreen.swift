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
//                 NavigationLink(destination: GoalFormView()) {
//                    VStack(alignment: .leading) {
//                        Text("Goal")
//                            .font(.headline)
//                        Text("Create Goal")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }}
//                
//             
//                 NavigationLink(destination: GoalsListView()) {
//                    VStack(alignment: .leading) {
//                        Text("Goal List")
//                            .font(.headline)
//                        Text("View all Goals")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }}
//                 NavigationLink(destination: TargetFormView(goalName: nil, goalId: nil)) {
//                    VStack(alignment: .leading) {
//                        Text("Target")
//                            .font(.headline)
//                        Text("Create a Target")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }}
//                 NavigationLink(destination: TargetListView()) {
//                    VStack(alignment: .leading) {
//                        Text("Target List")
//                            .font(.headline)
//                        Text("View all Target")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }}
                 
                 NavigationLink(destination: TaskFormView(targetName: nil, targetId: nil, task: nil)) {
                    VStack(alignment: .leading) {
                        Text("Task")
                            .font(.headline)
                        Text("Create a Task")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }}
                 
                 NavigationLink(destination: TaskListView()) {
                    VStack(alignment: .leading) {
                        Text("Task List")
                            .font(.headline)
                        Text("View all Tasks")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }}
                
             }.navigationTitle("Home")
            }
        
        
    }
}
