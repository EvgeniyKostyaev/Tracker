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
        case .monday: return "schedule_monday_short".localized
        case .tuesday: return "schedule_tuesday_short".localized
        case .wednesday: return "schedule_wednesday_short".localized
        case .thursday: return "schedule_thursday_short".localized
        case .friday: return "schedule_friday_short".localized
        case .saturday: return "schedule_saturday_short".localized
        case .sunday: return "schedule_sunday_short".localized
        }
    }
    
    var fullRepresentation: String {
        switch self {
        case .monday: return "schedule_monday".localized
        case .tuesday: return "schedule_tuesday".localized
        case .wednesday: return "schedule_wednesday".localized
        case .thursday: return "schedule_thursday".localized
        case .friday: return "schedule_friday".localized
        case .saturday: return "schedule_saturday".localized
        case .sunday: return "schedule_sunday".localized
        }
    }
}

struct Schedule {
    let daysWeeks: [DayWeeks]?
    let date: Date?
}

enum TrackerType: String, Codable {
    case habit
    case irregular
}

struct Tracker {
    let id: UUID
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

// MARK: - DayWeeks
extension Array where Element == DayWeeks {
    func toMask() -> Int16 {
        reduce(0) { acc, day in
            return acc | (1 << day.rawValue)
        }
    }
}

extension DayWeeks {
    static func from(mask: Int16) -> [DayWeeks] {
        (1...7).compactMap { bit in
            (mask & (1 << bit)) != 0 ? DayWeeks(rawValue: bit) : nil
        }
    }
}

