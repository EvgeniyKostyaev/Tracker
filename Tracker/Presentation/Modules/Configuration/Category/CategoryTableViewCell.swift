//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 02.10.2025.
//

import UIKit

private enum Theme {
    static let categoryLabelFontSize: CGFloat = 17.0
    static let categoryLabelLeadingConstraint: CGFloat = 16.0
    static let checkmarkImageViewTrailingConstraint: CGFloat = -16.0
    static let contentViewHeightConstraint: CGFloat = 75.0
    static let tableViewSeparatorInset: CGFloat = 16.0
    static let separatorViewHeightConstraint: CGFloat = 1
    static let alphaComponent: CGFloat = 0.3
    static let cornerRadius: CGFloat = 16.0
}

final class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    static let identifier = "CategotyCell"
    
    // MARK: - Private Properties
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Theme.categoryLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .trackerLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Overrides Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .trackerLightGray.withAlphaComponent(Theme.alphaComponent)
        selectionStyle = .none
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with category: String, isActive: Bool, isFirstCell: Bool, isLastCell: Bool) {
        categoryLabel.text = category
        checkmarkImageView.image = isActive ? .check : nil
        separatorView.isHidden = isLastCell
        
        setupCornerRadius(cornerRadius: Theme.cornerRadius, isFirstCell: isFirstCell, isLastCell: isLastCell)
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        contentView.addSubview(categoryLabel)
        contentView.addSubview(checkmarkImageView)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.categoryLabelLeadingConstraint),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Theme.checkmarkImageViewTrailingConstraint),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.heightAnchor.constraint(equalToConstant: Theme.contentViewHeightConstraint),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.tableViewSeparatorInset),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.tableViewSeparatorInset),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Theme.separatorViewHeightConstraint)
        ])
    }
}
