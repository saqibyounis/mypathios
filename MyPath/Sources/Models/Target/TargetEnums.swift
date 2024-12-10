//
//  TargetEnums.swift
//  MyPath
//
//  Created by Saqib Younis on 02/12/2024.
//

import Foundation
import RealmSwift

enum TargetStatus: String, PersistableEnum, CaseIterable {
    case started = "STARTED"
    case inProgress = "IN_PROGRESS"
    case completed = "COMPELETED"
    case onHold = "ON_HOLD"
}

enum TargetType: String, PersistableEnum, CaseIterable{
    case longTerm = "LONG_TERM"
    case shortTerm = "SHORT_TERM"
    case continious = "CONTINIOUS"
    
}

enum TargetPriority: String, PersistableEnum, CaseIterable{
    case high = "HIGH"
    case low = "LOW"
    case medium = "MEDIUM"
    
    
}

