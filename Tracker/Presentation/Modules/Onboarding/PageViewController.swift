//
//  PageViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 01.11.2025.
//

import Foundation
import UIKit

private enum Theme {
    static let labelFontSize: CGFloat = 34.0
    static let labelNumberLines: Int = 3
    
    static let labelLeadingConstraint: CGFloat = 16.0
    static let labelTrailingConstraint: CGFloat = -16.0
    static let labelCenterYConstraint: CGFloat = 66.0
}

final class PageViewController: UIViewController {

    // MARK: - Private Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Theme.labelFontSize)
        label.textAlignment = .center
        label.textColor = .trackerBlack
        label.numberOfLines = Theme.labelNumberLines
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Initializers
    init(image: UIImage, text: String) {
        imageView.image = image
        label.text = text
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        view.addSubview(imageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.labelLeadingConstraint),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.labelTrailingConstraint),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Theme.labelCenterYConstraint)
        ])
    }
}

