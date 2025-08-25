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
    
    // MARK: - Private Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: EmptyStateViewTheme.fontSizeLabel, weight: .medium)
        label.numberOfLines = EmptyStateViewTheme.numberOfLinesLabel
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.spacing = EmptyStateViewTheme.spacingStackView
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
            imageView.heightAnchor.constraint(equalToConstant: EmptyStateViewTheme.heightImageView),
            imageView.widthAnchor.constraint(equalToConstant: EmptyStateViewTheme.widthImageView)
        ])
    }
}
