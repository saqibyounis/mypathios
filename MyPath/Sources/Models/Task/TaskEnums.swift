
import Foundation
import RealmSwift
import SwiftUICore

enum Classification: String, PersistableEnum {
    case doNow = "DO_NOW"       // Urgent and Important
    case schedule = "SCHEDULE"  // Important but Not Urgent
    case delegate = "DELEGATE"  // Urgent but Not Important
    case eliminate = "ELIMINATE" // Neither Urgent nor Important
}

enum TaskStatus: String, CaseIterable, PersistableEnum {
    case started = "Started"
    case inProgress = "In Progress"
    case completed = "Completed"
    case onHold = "On Hold"
    
    
    var color: Color {
        switch self {
        case .started: return .blue
        case .inProgress: return .green
        case .completed: return .purple
        case .onHold: return .orange
        }
    }
    
    var icon: String {
        switch self {
        case .started: return "play.circle.fill"
        case .inProgress: return "arrow.triangle.2.circlepath"
        case .completed: return "checkmark.circle.fill"
        case .onHold: return "pause.circle.fill"
        }
    }
}


enum TaskSource: String, PersistableEnum {
    case jira = "JIRA"
    case trello = "TRELLO"
    case googleCalendar = "GOOGLE_CALENDAR"
    case appleCalendar = "APPLE_CALENDAR"
    case teamsCalendar = "TEAMS_CALENDAR"
    case manual = "MANUAL" // Tasks added locally
}


enum Priority: Int, CaseIterable, PersistableEnum {
    case low = 0
    case medium = 1
    case high = 2
    
    var title: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}
