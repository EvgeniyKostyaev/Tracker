//
//  UITableViewCell+Additions.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 07.11.2025.
//

import UIKit

extension UITableViewCell {
    
    // MARK: - Public methods
    func setupCornerRadius(cornerRadius: CGFloat, isFirstCell: Bool, isLastCell: Bool) {
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        
        switch (isFirstCell, isLastCell) {
        case (true, true):
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case (true, false):
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case (false, true):
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case (false, false):
            contentView.layer.cornerRadius = CGFloat.zero
        }
    }
    
}
