//
//  ScheduleEntity.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import Foundation
import RealmSwift

enum ScheduleStatus: String, PersistableEnum {
    case pending = "PENDING"
    case inProgress = "IN_PROGRESS"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
}

class Schedule: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var title: String?
    @Persisted var startTime: Int  // Unix timestamp in milliseconds
    @Persisted var endTime: Int    // Unix timestamp in milliseconds
    @Persisted var status: ScheduleStatus = .pending
    @Persisted var task: TaskEntity?
    
    convenience init(title: String? = nil, startTime: Date, task: TaskEntity?) {
        self.init()
        self.title = title ?? task?.name
        self.startTime = Int(startTime.timeIntervalSince1970 * 1000)
        if let duration = task?.duration {
            self.endTime = Int(startTime.addingTimeInterval(TimeInterval(duration * 60)).timeIntervalSince1970 * 1000)
        } else {
            self.endTime = Int(startTime.addingTimeInterval(3600).timeIntervalSince1970 * 1000)
        }
        self.task = task
    }
}
