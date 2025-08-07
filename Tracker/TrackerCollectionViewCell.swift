//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 07.08.2025.
//

import UIKit

enum TrackerCollectionViewCellTheme {
    static let cardViewCornerRadius: CGFloat = 16.0
    static let cardViewHeightConstraint: CGFloat = 90.0
    
    static let emojiCircleViewCornerRadius: CGFloat = 12.0
    static let emojiLabelFontSize: CGFloat = 14.0
    static let emojiCircleViewTopConstraint: CGFloat = 12.0
    static let emojiCircleViewLeadingConstraint: CGFloat = 12.0
    static let emojiCircleViewWidthConstraint: CGFloat = 24.0
    static let emojiCircleViewHeightConstraint: CGFloat = 24.0
    
    static let titleLabelFontSize: CGFloat = 16.0
    static let titleLabelNumberOfLines: Int = 2
    static let titleLabelLeadingConstraint: CGFloat = 12.0
    static let titleLabelTrailingConstraint: CGFloat = -12.0
    
    static let daysLabelFontSize: CGFloat = 12.0
    static let daysLabelTopConstraint: CGFloat = 16.0
    static let daysLabelHeightConstraint: CGFloat = 18.0
    static let daysLabelLeadingConstraint: CGFloat = 12.0
    static let daysLabelTrailingConstraint: CGFloat = 12.0
    
    static let plusButtonFontSize: CGFloat = 24.0
    static let plusButtonCornerRadius: CGFloat = 17.0
    static let plusButtonWidthConstraint: CGFloat = 34.0
    static let plusButtonHeightConstraint: CGFloat = 34.0
    static let plusButtonTrailingConstraint: CGFloat = -12.0
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    static let identifier = "TrackerCollectionViewCell"
    
    // MARK: - Private Properties
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGreen
        view.layer.cornerRadius = TrackerCollectionViewCellTheme.cardViewCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        view.layer.cornerRadius = TrackerCollectionViewCellTheme.emojiCircleViewCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "❤️"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: TrackerCollectionViewCellTheme.emojiLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Поливать растения"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: TrackerCollectionViewCellTheme.titleLabelFontSize, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = TrackerCollectionViewCellTheme.titleLabelNumberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.text = "1 день"
        label.font = UIFont.systemFont(ofSize: TrackerCollectionViewCellTheme.daysLabelFontSize)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        
        let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
        let plusImage = UIImage(systemName: "plus", withConfiguration: config)
        
        button.setImage(plusImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = TrackerCollectionViewCellTheme.plusButtonWidthConstraint / 2
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Overrides Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cardView)
        cardView.addSubview(emojiCircleView)
        emojiCircleView.addSubview(emojiLabel)
        cardView.addSubview(titleLabel)
        contentView.addSubview(daysLabel)
        contentView.addSubview(plusButton)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public methods
    func configure(title: String, emoji: String, days: String) {
        titleLabel.text = title
        emojiLabel.text = emoji
        daysLabel.text = days
    }
    
    // MARK: - Private methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: TrackerCollectionViewCellTheme.cardViewHeightConstraint),
            
            emojiCircleView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: TrackerCollectionViewCellTheme.emojiCircleViewTopConstraint),
            emojiCircleView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: TrackerCollectionViewCellTheme.emojiCircleViewLeadingConstraint),
            emojiCircleView.widthAnchor.constraint(equalToConstant: TrackerCollectionViewCellTheme.emojiCircleViewWidthConstraint),
            emojiCircleView.heightAnchor.constraint(equalToConstant: TrackerCollectionViewCellTheme.emojiCircleViewHeightConstraint),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiCircleView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiCircleView.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: cardView.leadingAnchor, constant: TrackerCollectionViewCellTheme.titleLabelLeadingConstraint),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: TrackerCollectionViewCellTheme.titleLabelTrailingConstraint),
            
            daysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: TrackerCollectionViewCellTheme.daysLabelTopConstraint),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: TrackerCollectionViewCellTheme.daysLabelLeadingConstraint),
            daysLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: TrackerCollectionViewCellTheme.daysLabelTrailingConstraint),
            daysLabel.heightAnchor.constraint(equalToConstant: TrackerCollectionViewCellTheme.daysLabelHeightConstraint),
            
            plusButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: TrackerCollectionViewCellTheme.plusButtonTrailingConstraint),
            plusButton.widthAnchor.constraint(equalToConstant: TrackerCollectionViewCellTheme.plusButtonWidthConstraint),
            plusButton.heightAnchor.constraint(equalToConstant: TrackerCollectionViewCellTheme.plusButtonHeightConstraint)
        ])
    }
}
