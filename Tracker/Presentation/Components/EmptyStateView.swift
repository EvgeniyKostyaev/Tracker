//
//  EmptyStateView.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 28.05.2025.
//

import UIKit

private enum Theme {
    static let numberOfLinesLabel: Int = 0
    static let fontSizeLabel: CGFloat = 16
    static let spacingStackView: CGFloat = 12
    static let heightImageView: CGFloat = 80
    static let widthImageView: CGFloat = 80
    static let stackViewLeadingConstraint: CGFloat = 16.0
    static let stackViewTrailingConstraint: CGFloat = -16.0
}

final class EmptyStateView: UIView {
    
    // MARK: - Private Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .trackerLightGray
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: Theme.fontSizeLabel, weight: .medium)
        label.numberOfLines = Theme.numberOfLinesLabel
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.spacing = Theme.spacingStackView
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initializers methods
    init(image: UIImage?, text: String) {
        super.init(frame: .zero)
       
        imageView.image = image
        label.text = text
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Theme.stackViewLeadingConstraint),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Theme.stackViewTrailingConstraint),
            
            imageView.heightAnchor.constraint(equalToConstant: Theme.heightImageView),
            imageView.widthAnchor.constraint(equalToConstant: Theme.widthImageView)
        ])
    }
}
