//
//  RoutineEntity.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import Foundation
import RealmSwift

class RoutineEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var startTime: Int
    @Persisted var activeDays: List<Int>
    @Persisted var duration: Int = 0
    @Persisted var isCompleted: Bool = false
    @Persisted var tasks: List<TaskEntity> = List<TaskEntity>()
    @Persisted(originProperty: "routines") var parentTask: LinkingObjects<TaskEntity>
    
    convenience init(name: String, startTime: Date, days: [Int]) {
        self.init()
        self.name = name
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: startTime)
        self.startTime = ((components.hour ?? 0) * 3600 + (components.minute ?? 0) * 60) * 1000
        days.forEach { self.activeDays.append($0) }
    }
    
    func calculateDuration() {
        self.duration = tasks.sum(ofProperty: "duration") ?? 0
    }
}
