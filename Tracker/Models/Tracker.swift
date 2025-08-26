//
//  Tracker.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 10.06.2025.
//

import Foundation
import UIKit

enum DayWeeks: Int {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
}

extension DayWeeks {
    var shortRepresentation: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
    
    var fullRepresentation: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
}

struct Schedule {
    let daysWeeks: [DayWeeks?]?
    let date: Date?
}

enum TrackerType: String, Codable {
    case habit
    case irregular
}

struct Tracker {
    let id: Int
    let title: String
    let color: UIColor
    let emoji: String
    let type: TrackerType
    let schedule: Schedule?
    
    func completedDaysCount(from completedTrackers: [TrackerRecord]) -> Int {
        completedTrackers.filter({ $0.trackerId == id }).count
    }
    
    func isCompleted(on date: Date, from completedTrackers: [TrackerRecord]) -> Bool {
        completedTrackers.contains(where: { trackerRecord in
            return trackerRecord.trackerId == id && trackerRecord.date.isSameDayAs(date)
        })
    }
    
    func isAvailable(on activeDate: Date) -> Bool {
        activeDate <= Date()
    }
}
