//
//  UIView+Additions.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 28.11.2025.
//

import Foundation
import UIKit

extension UIView {
    func setGradientBorder(
        colors: [UIColor],
        lineWidth: CGFloat,
        cornerRadius: CGFloat
    ) {
        layer.sublayers?
            .filter { $0.name == "gradientBorder" }
            .forEach { $0.removeFromSuperlayer() }
        
        let gradient = CAGradientLayer()
        gradient.name = "gradientBorder"
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth
        shape.path = UIBezierPath(
            roundedRect: bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2),
            cornerRadius: cornerRadius
        ).cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.black.cgColor
        
        gradient.mask = shape
        layer.addSublayer(gradient)
    }
}
