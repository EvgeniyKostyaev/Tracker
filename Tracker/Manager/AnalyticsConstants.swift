//
//  AnalyticsConstants.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 28.11.2025.
//

import Foundation

enum AnalyticsConstants {
    
    static let event = "EVENT"
    
    enum Key {
        static let event = "event"
        static let screen = "screen"
        static let item = "item"
    }
    
    enum Value {
        static let open = "open"
        static let close = "close"
        static let click = "click"
        static let main = "main"
        static let addTrack = "add_track"
        static let track = "track"
        static let filter = "filter"
        static let edit = "edit"
        static let delete = "delete"
    }
}
