//
//  Tracker.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 10.06.2025.
//

import Foundation
import UIKit

enum Weekday: Int {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
}

struct Schedule {
    var weekdays: Set<Weekday?>
    var startTime: Date?
    var endTime: Date?
    
    init(weekdays: Set<Weekday?>, startTime: Date? = nil, endTime: Date? = nil) {
        self.weekdays = weekdays
        self.startTime = startTime
        self.endTime = endTime
    }
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
    
    var isCompleted: Bool = false
    var completedDaysCount: Int = 0
}
