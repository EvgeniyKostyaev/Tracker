//
//  ConfigurationColorCollectionViewCell.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 22.08.2025.
//

import UIKit

enum ConfigurationColorCollectionViewCellTheme {
    static let cornerRadius: CGFloat = 8.0
    static let containerViewHeightConstraint: CGFloat = 40.0
    static let containerViewWidthConstraint: CGFloat = 40.0
}

final class ConfigurationColorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    static let identifier = "ColorCell"
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = ConfigurationColorCollectionViewCellTheme.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Overrides Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = ConfigurationColorCollectionViewCellTheme.cornerRadius
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: ConfigurationColorCollectionViewCellTheme.containerViewHeightConstraint),
            containerView.widthAnchor.constraint(equalToConstant: ConfigurationColorCollectionViewCellTheme.containerViewWidthConstraint)
        ])
    }
}
