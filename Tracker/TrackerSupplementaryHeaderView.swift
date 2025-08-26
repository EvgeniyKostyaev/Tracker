//
//  TrackerSupplementaryHeaderView.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 07.08.2025.
//

import UIKit

enum TrackerSupplementaryHeaderViewTheme {
    static let fontSize: CGFloat = 19.0
    static let leadingConstraint: CGFloat = 28.0
    static let trailingConstraint: CGFloat = 28.0
}

final class TrackerSupplementaryHeaderView: UICollectionReusableView {
    
    // MARK: - Public Properties
    static let identifier = "TrackerSupplementaryHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: TrackerSupplementaryHeaderViewTheme.fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Overrides Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:TrackerSupplementaryHeaderViewTheme.leadingConstraint),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: TrackerSupplementaryHeaderViewTheme.trailingConstraint),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
