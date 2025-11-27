//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 28.11.2025.
//

import Foundation
import AppMetricaCore

final class AnalyticsService: AnalyticsServiceProtocol {
    
    static let shared = AnalyticsService()
    
    private init() {}
    
    func logEvent(name: String, params: [AnyHashable : Any]) {
        AppMetrica.reportEvent(name: name, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
