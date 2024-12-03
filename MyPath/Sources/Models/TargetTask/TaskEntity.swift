//
//  TaskEntity.swift
//  MyPath
//
//  Created by Saqib Younis on 29/11/2024.
//

import Foundation
import RealmSwift

class MetaData: Object {
    @Persisted var key: String
    @Persisted var value: String
}

class TaskEntity: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var icon: String?
    @Persisted var title: String
    @Persisted var descriptionText: String
    @Persisted var classification: Classification
    @Persisted var duration: Double?
    @Persisted var createdTime: Int
    @Persisted var scheduledTime: Int?
    @Persisted var actualStartTime: Int?
    @Persisted var actualEndTime: Int?
    @Persisted var status: TaskStatus
    @Persisted var priorityScore: Double?
    @Persisted var source: TaskSource
    @Persisted var externalId: String?
    @Persisted var metadata: List<MetaData> = List<MetaData>()
    @Persisted var targetId: String
    @Persisted var files: List<String> = List<String>()

    convenience init(
        id: String,
        icon: String,
        title: String,
        description: String,
        classification: Classification,
        duration: Double,
        createdTime: Int,
        scheduledTime: Int?,
        actualStartTime: Int?,
        actualEndTime: Int?,
        status: TaskStatus,
        priorityScore: Double,
        source: TaskSource,
        externalId: String?,
        metadata: List<MetaData>,
        targetId: String,
        files: [String]
    ) {
        self.init()
        self.id = id
        self.icon = icon
        self.title = title
        self.descriptionText = description
        self.classification = classification
        self.duration = duration
        self.createdTime = createdTime
        self.scheduledTime = scheduledTime
        self.actualStartTime = actualStartTime
        self.actualEndTime = actualEndTime
        self.status = status
        self.priorityScore = priorityScore
        self.source = source
        self.externalId = externalId
        self.metadata = metadata
        self.targetId = targetId
        self.files.append(objectsIn: files)
    }
}
