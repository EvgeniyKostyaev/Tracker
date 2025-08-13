//
//  Date+Additions.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 13.08.2025.
//

import Foundation

extension Date {
    var dayOfWeek: Int {
        let weekday = Calendar(identifier: .iso8601).component(.weekday, from: self)
        return weekday == 1 ? 7 : weekday - 1
    }
}
