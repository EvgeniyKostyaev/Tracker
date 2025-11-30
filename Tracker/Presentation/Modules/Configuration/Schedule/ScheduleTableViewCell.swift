//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 22.08.2025.
//

import UIKit

private enum Theme {
    static let dayLabelFontSize: CGFloat = 17.0
    static let dayLabelLeadingConstraint: CGFloat = 16.0
    static let daySwitchTrailingConstraint: CGFloat = -16.0
    static let contentViewHeightConstraint: CGFloat = 75.0
    static let tableViewSeparatorInset: CGFloat = 16.0
    static let separatorViewHeightConstraint: CGFloat = 0.8
    static let alphaComponent: CGFloat = 0.3
    static let cornerRadius: CGFloat = 16.0
}

final class ScheduleTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    var onSwitchChanged: ((Bool) -> Void)?
    
    static let identifier = "DayCell"
    
    // MARK: - Private Properties
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Theme.dayLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var daySwitch: UISwitch = {
        let daySwitch = UISwitch()
        daySwitch.onTintColor = .trackerBlue
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        daySwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        return daySwitch
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
    func configure(with dayWeeks: DayWeeks, isOn: Bool, isFirstCell: Bool, isLastCell: Bool) {
        dayLabel.text = dayWeeks.fullRepresentation
        daySwitch.isOn = isOn
        separatorView.isHidden = isLastCell
        
        setupCornerRadius(cornerRadius: Theme.cornerRadius, isFirstCell: isFirstCell, isLastCell: isLastCell)
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(daySwitch)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.dayLabelLeadingConstraint),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Theme.daySwitchTrailingConstraint),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.tableViewSeparatorInset),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.tableViewSeparatorInset),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Theme.separatorViewHeightConstraint),
            
            contentView.heightAnchor.constraint(equalToConstant: Theme.contentViewHeightConstraint)
        ])
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        onSwitchChanged?(sender.isOn)
    }
}
