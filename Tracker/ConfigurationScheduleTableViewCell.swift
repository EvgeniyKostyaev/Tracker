//
//  ConfigurationScheduleTableViewCell.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 22.08.2025.
//

import UIKit

enum ConfigurationScheduleTableViewCellTheme {
    static let dayLabelFontSize: CGFloat = 17.0
    static let dayLabelLeadingConstraint: CGFloat = 16.0
    static let daySwitchTrailingConstraint: CGFloat = -16.0
    static let contentViewHeightConstraint: CGFloat = 75.0
}

final class ConfigurationScheduleTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    var onSwitchChanged: ((Bool) -> Void)?
    
    static let identifier = "DayCell"
    
    // MARK: - Private Properties
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: ConfigurationScheduleTableViewCellTheme.dayLabelFontSize)
        return label
    }()
    
    private lazy var daySwitch: UISwitch = {
        let daySwitch = UISwitch()
        daySwitch.onTintColor = .trackerBlue
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        daySwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        return daySwitch
    }()
    
    // MARK: - Overrides Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with dayWeeks: DayWeeks, isOn: Bool) {
        dayLabel.text = dayWeeks.fullRepresentation
        daySwitch.isOn = isOn
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(daySwitch)
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ConfigurationScheduleTableViewCellTheme.dayLabelLeadingConstraint),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: ConfigurationScheduleTableViewCellTheme.daySwitchTrailingConstraint),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.heightAnchor.constraint(equalToConstant: ConfigurationScheduleTableViewCellTheme.contentViewHeightConstraint)
        ])
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        onSwitchChanged?(sender.isOn)
    }
}
