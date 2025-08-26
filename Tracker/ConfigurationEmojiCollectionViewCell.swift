//
//  ConfigurationEmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 22.08.2025.
//

import UIKit

final class ConfigurationEmojiCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    static let identifier = "EmojiCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Overrides Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16.0
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
