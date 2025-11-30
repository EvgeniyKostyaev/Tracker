//
//  AnalyticsServiceProtocol.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 28.11.2025.
//

import Foundation

protocol AnalyticsServiceProtocol {
    func logEvent(name: String, params : [AnyHashable : Any])
}
