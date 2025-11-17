//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 07.08.2025.
//

import UIKit

private enum Theme {
    static let cardViewCornerRadius: CGFloat = 16.0
    static let cardViewHeightConstraint: CGFloat = 90.0
    
    static let emojiCircleViewCornerRadius: CGFloat = 12.0
    static let emojiLabelFontSize: CGFloat = 14.0
    static let emojiCircleViewTopConstraint: CGFloat = 12.0
    static let emojiCircleViewLeadingConstraint: CGFloat = 12.0
    static let emojiCircleViewWidthConstraint: CGFloat = 24.0
    static let emojiCircleViewHeightConstraint: CGFloat = 24.0
    
    static let titleLabelFontSize: CGFloat = 12.0
    static let titleLabelNumberOfLines: Int = 2
    static let titleLabelLeadingConstraint: CGFloat = 12.0
    static let titleLabelTrailingConstraint: CGFloat = -12.0
    static let titleLabelBottomConstraint: CGFloat = -12.0
    
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
    static let plusButtonSymbolConfigurationPointSize: CGFloat = 10.0
    static let plusButtonImageSystemNamePlus: String = "plus"
    static let plusButtonImageSystemNameCheckmark: String = "checkmark"
}

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func trackerCell(_ cell: TrackerCollectionViewCell, onClickPlusButton indexPath: IndexPath?)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    static let identifier = "TrackerCollectionViewCell"
    
    var indexPath: IndexPath?
    
    // MARK: - Private Properties
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Theme.cardViewCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        view.layer.cornerRadius = Theme.emojiCircleViewCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Theme.emojiLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: Theme.titleLabelFontSize, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = Theme.titleLabelNumberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Theme.daysLabelFontSize)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.layer.cornerRadius = Theme.plusButtonCornerRadius
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Overrides Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public Methods
    func configure(backgroundColor: UIColor, title: String, emoji: String, dayCount: Int, isCompleted: Bool, isAvailable: Bool) {
        titleLabel.text = title
        emojiLabel.text = emoji
        daysLabel.text = getDaysRepresentation(dayCount)
        plusButton.setImage(getPlusButtonImage(isCompleted), for: UIControl.State.normal)
        plusButton.backgroundColor = backgroundColor.withAlphaComponent(isCompleted || !isAvailable ? 0.3 : 1.0)
        plusButton.isEnabled = isAvailable
        cardView.backgroundColor = backgroundColor
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        contentView.addSubview(cardView)
        cardView.addSubview(emojiCircleView)
        emojiCircleView.addSubview(emojiLabel)
        cardView.addSubview(titleLabel)
        contentView.addSubview(daysLabel)
        contentView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: Theme.cardViewHeightConstraint),
            
            emojiCircleView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Theme.emojiCircleViewTopConstraint),
            emojiCircleView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Theme.emojiCircleViewLeadingConstraint),
            emojiCircleView.widthAnchor.constraint(equalToConstant: Theme.emojiCircleViewWidthConstraint),
            emojiCircleView.heightAnchor.constraint(equalToConstant: Theme.emojiCircleViewHeightConstraint),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiCircleView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiCircleView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Theme.titleLabelLeadingConstraint),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: Theme.titleLabelTrailingConstraint),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: Theme.titleLabelBottomConstraint),
            
            daysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: Theme.daysLabelTopConstraint),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.daysLabelLeadingConstraint),
            daysLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: Theme.daysLabelTrailingConstraint),
            daysLabel.heightAnchor.constraint(equalToConstant: Theme.daysLabelHeightConstraint),
            
            plusButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Theme.plusButtonTrailingConstraint),
            plusButton.widthAnchor.constraint(equalToConstant: Theme.plusButtonWidthConstraint),
            plusButton.heightAnchor.constraint(equalToConstant: Theme.plusButtonHeightConstraint)
        ])
    }
    
    private func getDaysRepresentation(_ dayCount: Int) -> String {
        let daysString = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: String()),
            dayCount
        )
        
        return daysString
    }
    
    private func getPlusButtonImage(_ isCompleted: Bool) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: Theme.plusButtonSymbolConfigurationPointSize, weight: .bold)
        
        let plusImage = UIImage(systemName: Theme.plusButtonImageSystemNamePlus, withConfiguration: config)
        
        let checkImage = UIImage(systemName: Theme.plusButtonImageSystemNameCheckmark, withConfiguration: config)
        
        return isCompleted ? checkImage : plusImage
    }
    
    @objc private func plusButtonTapped() {
        delegate?.trackerCell(self, onClickPlusButton: indexPath)
    }
}
