
import Foundation
import RealmSwift

enum Classification: String, PersistableEnum {
    case doNow = "DO_NOW"       // Urgent and Important
    case schedule = "SCHEDULE"  // Important but Not Urgent
    case delegate = "DELEGATE"  // Urgent but Not Important
    case eliminate = "ELIMINATE" // Neither Urgent nor Important
}

enum TaskStatus: String, PersistableEnum {
    case pending = "PENDING"
    case completed = "COMPLETED"
    case failed = "FAILED"
}

enum TaskSource: String, PersistableEnum {
    case jira = "JIRA"
    case trello = "TRELLO"
    case googleCalendar = "GOOGLE_CALENDAR"
    case appleCalendar = "APPLE_CALENDAR"
    case teamsCalendar = "TEAMS_CALENDAR"
    case manual = "MANUAL" // Tasks added locally
}
