//
//  GoalEnums.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import RealmSwift

enum GoalType: String, CaseIterable, PersistableEnum {
    case longTerm = "Long Term"
    case shortTerm = "Short Term"
    case continuous = "Continuous"
    
    var icon: String {
        switch self {
        case .longTerm: return "calendar"
        case .shortTerm: return "stopwatch"
        case .continuous: return "infinity"
        }
    }
}
