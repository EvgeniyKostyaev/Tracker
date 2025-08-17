//
//  Date+Additions.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 13.08.2025.
//

import Foundation

extension Date {
    
    // MARK: - Public methods
    var dayOfWeek: Int {
        let weekday = iso8601Calendar.component(.weekday, from: self)
        return weekday == 1 ? 7 : weekday - 1
    }
    
    func isSameDayAs(_ date: Date) -> Bool{
        return iso8601Calendar.isDate(self, inSameDayAs: date)
    }
    
    // MARK: - Private methods
    private var iso8601Calendar : Calendar {
        var calendar = Calendar.init(identifier: .iso8601)
        calendar.timeZone = TimeZone.current
        return calendar
    }
}
