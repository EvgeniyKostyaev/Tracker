//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 22.08.2025.
//

import UIKit

private enum Theme {
    static let cornerRadius: CGFloat = 8.0
    static let containerViewHeightConstraint: CGFloat = 40.0
    static let containerViewWidthConstraint: CGFloat = 40.0
}

final class ColorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    static let identifier = "ColorCell"
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Theme.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Overrides Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = Theme.cornerRadius
        
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
            containerView.heightAnchor.constraint(equalToConstant: Theme.containerViewHeightConstraint),
            containerView.widthAnchor.constraint(equalToConstant: Theme.containerViewWidthConstraint)
        ])
    }
}
