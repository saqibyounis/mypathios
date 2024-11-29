//
//  SyncService.swift
//  MyPath
//
//  Created by Saqib Younis on 29/11/2024.
//

import Foundation

// Service to handle sync logic and data operations
class TargetTaskService {
    private let taskRepository = TaskRepository()
    private let targetRepository = TargetRepository()

    // Example of checking for network status and syncing tasks
    func syncTasksToCloud() {
        if isNetworkAvailable() {
            // Sync tasks to cloud (implement cloud API logic)
            syncTasksWithCloud()
        } else {
            // If offline, store data locally and handle sync later
            print("No network connection, saving data locally")
        }
    }

    func syncTargetsToCloud() {
        if isNetworkAvailable() {
            // Sync targets to cloud (implement cloud API logic)
            syncTargetsWithCloud()
        } else {
            print("No network connection, saving data locally")
        }
    }

    // Checks if network is available
    private func isNetworkAvailable() -> Bool {
        // Check network availability (use a network manager or reachability)
        return true // Simplified for demonstration
    }

    // Example sync function for Tasks
    private func syncTasksWithCloud() {
        let tasks = taskRepository.getAllTasks()
        // Implement logic to send tasks to cloud, e.g., via API
        print("Syncing tasks to cloud:", tasks)
    }

    // Example sync function for Targets
    private func syncTargetsWithCloud() {
        let targets = targetRepository.getAllTargets()
        // Implement logic to send targets to cloud, e.g., via API
        print("Syncing targets to cloud:", targets)
    }

    // Local data fetch logic (offline-first)
    func fetchAllTasks() -> [TaskEntity] {
        return Array(taskRepository.getAllTasks())
    }

    func fetchAllTargets() -> [TargetEntity] {
        return Array(targetRepository.getAllTargets())
    }
    

    
        func fetchTasks(for date: Date) -> [TaskEntity] {
            let startOfDay = Int(Calendar.current.startOfDay(for: date).timeIntervalSince1970 * 1000)
            let endOfDay = Int(Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: date))!.timeIntervalSince1970 * 1000)
            
            let results = taskRepository.getTasks(startTimestamp: startOfDay, endTimestamp: endOfDay)
            return Array(results)
        }

        func fetchTasks(from startDate: Date, to endDate: Date) -> [TaskEntity] {
            let startTimestamp = Int(startDate.timeIntervalSince1970 * 1000)
            let endTimestamp = Int(endDate.timeIntervalSince1970 * 1000)

            let results = taskRepository.getTasks(startTimestamp: startTimestamp, endTimestamp: endTimestamp)
            return Array(results)
        }
}
