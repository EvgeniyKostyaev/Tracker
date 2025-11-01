//
//  AppSettings.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 01.11.2025.
//

import Foundation

private enum Keys: String {
    case firstLaunchKey
}

final class AppSettings: AppSettingsProtocol {
    
    // MARK: - Private Properties
    private let storage: UserDefaults = .standard
    
    
    // MARK: - Public Properties
    var isFirstLaunch: Bool {
        get {
            if let isFirstLaunch = storage.value(forKey: Keys.firstLaunchKey.rawValue) as? Bool {
                return isFirstLaunch
            }
            
            return true
        }
        
        set {
            storage.set(newValue, forKey: Keys.firstLaunchKey.rawValue)
            
        }
    }
    
}
