//
//  EmptyStateView.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 28.05.2025.
//

import UIKit

enum EmptyStateViewTheme {
    static let numberOfLinesLabel: Int = 0
    static let fontSizeLabel: CGFloat = 16
    static let spacingStackView: CGFloat = 16
    static let heightImageView: CGFloat = 80
    static let widthImageView: CGFloat = 80
}

final class EmptyStateView: UIView {
    
    // MARK: - Initializers methods
    init(image: UIImage?, text: String) {
        super.init(frame: .zero)
        setupView(image: image, text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupView(image: UIImage?, text: String) {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: EmptyStateViewTheme.fontSizeLabel, weight: .medium)
        label.numberOfLines = EmptyStateViewTheme.numberOfLinesLabel
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.spacing = EmptyStateViewTheme.spacingStackView
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: EmptyStateViewTheme.heightImageView),
            imageView.widthAnchor.constraint(equalToConstant: EmptyStateViewTheme.widthImageView)
        ])
    }
}
