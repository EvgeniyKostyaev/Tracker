//
//  TrackerSupplementaryHeaderView.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 07.08.2025.
//

import UIKit

final class TrackerSupplementaryHeaderView: UICollectionReusableView {
    
    // MARK: - Public Properties
    static let identifier = "TrackerSupplementaryHeaderView"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Theme.fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Private Properties
    private enum Theme {
        static let fontSize: CGFloat = 19.0
        static let leadingConstraint: CGFloat = 28.0
        static let trailingConstraint: CGFloat = 28.0
    }
    
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
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Theme.leadingConstraint),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Theme.trailingConstraint),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
