//
//  ConfigurationScheduleViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 21.08.2025.
//

import UIKit

enum ConfigurationScheduleViewControllerTheme {
    static let title: String = "Расписание"
    static let doneButtonTitle: String = "Готово"
    
    static let containerViewCornerRadius: CGFloat = 16.0
    static let tableViewSeparatorInset: CGFloat = 16.0
    
    enum DoneButton {
        static let doneButtonCornerRadius: CGFloat = 16.0
        static let doneButtonTopConstraint: CGFloat = 16.0
        static let doneButtonLeadingConstraint: CGFloat = 20.0
        static let doneButtonTrailingConstraint: CGFloat = -20.0
        static let doneButtonHeightConstraint: CGFloat = 60.0
        static let doneButtonBottomConstraint: CGFloat = -16.0
    }
    
    enum ContainerView {
        static let containerViewTopConstraint: CGFloat = 16.0
        static let containerViewLeadingConstraint: CGFloat = 16.0
        static let containerViewTrailingConstraint: CGFloat = -16.0
        static let containerViewHeightConstraint: CGFloat = 525.0
    }
}

final class ConfigurationScheduleViewController: UIViewController {
    
    // MARK: - Public Properties
    var onSave: (([DayWeeks]) -> Void)?
    
    var activeDaysWeeks: [DayWeeks] = []
    
    // MARK: - Private Properties
    private let daysWeeks: [DayWeeks] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = ConfigurationScheduleViewControllerTheme.containerViewCornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            ConfigurationScheduleTableViewCell.self,
            forCellReuseIdentifier: ConfigurationScheduleTableViewCell.identifier
        )
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: ConfigurationScheduleViewControllerTheme.tableViewSeparatorInset,
            bottom: 0,
            right: ConfigurationScheduleViewControllerTheme.tableViewSeparatorInset
        )
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(ConfigurationScheduleViewControllerTheme.doneButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = ConfigurationScheduleViewControllerTheme.DoneButton.doneButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        return button
    }()
    
    private let navigationBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        return appearance
    }()
    
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = ConfigurationScheduleViewControllerTheme.title
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        tableView.dataSource = self
        
        setupLayout()
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        view.addSubview(containerView)
        containerView.addSubview(tableView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ConfigurationScheduleViewControllerTheme.ContainerView.containerViewTopConstraint),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConfigurationScheduleViewControllerTheme.ContainerView.containerViewLeadingConstraint),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ConfigurationScheduleViewControllerTheme.ContainerView.containerViewTrailingConstraint),
            containerView.heightAnchor.constraint(equalToConstant: ConfigurationScheduleViewControllerTheme.ContainerView.containerViewHeightConstraint),
            
            tableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            doneButton.topAnchor.constraint(greaterThanOrEqualTo: containerView.bottomAnchor, constant: ConfigurationScheduleViewControllerTheme.DoneButton.doneButtonTopConstraint),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConfigurationScheduleViewControllerTheme.DoneButton.doneButtonLeadingConstraint),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ConfigurationScheduleViewControllerTheme.DoneButton.doneButtonTrailingConstraint),
            doneButton.heightAnchor.constraint(equalToConstant: ConfigurationScheduleViewControllerTheme.DoneButton.doneButtonHeightConstraint),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: ConfigurationScheduleViewControllerTheme.DoneButton.doneButtonBottomConstraint)
        ])
    }
    
    @objc private func doneTapped() {
        activeDaysWeeks.sort { $0.rawValue < $1.rawValue }
        onSave?(activeDaysWeeks)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ConfigurationScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysWeeks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConfigurationScheduleTableViewCell.identifier, for: indexPath) as? ConfigurationScheduleTableViewCell else { return UITableViewCell()}
        
        let day = daysWeeks[indexPath.row]
        let isActive = activeDaysWeeks.contains(day)
        cell.configure(with: day, isOn: isActive)
        
        cell.onSwitchChanged = { [weak self] isOn in
            guard let self = self else { return }
            if isOn {
                if !self.activeDaysWeeks.contains(day) {
                    self.activeDaysWeeks.append(day)
                }
            } else {
                self.activeDaysWeeks.removeAll { $0 == day }
            }
        }
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = .zero
        }
        
        cell.backgroundColor = .clear
        
        return cell
    }
}
