//
//  String+Additions.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 14.11.2025.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
