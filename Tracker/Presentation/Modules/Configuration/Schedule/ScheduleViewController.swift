//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 21.08.2025.
//

import UIKit

private enum Theme {
    static let containerViewCornerRadius: CGFloat = 16.0
    static let tableViewSeparatorInset: CGFloat = 16.0
    
    static let alphaComponent: CGFloat = 0.3
    
    enum DoneButton {
        static let doneButtonCornerRadius: CGFloat = 16.0
        static let doneButtonTopConstraint: CGFloat = 16.0
        static let doneButtonLeadingConstraint: CGFloat = 20.0
        static let doneButtonTrailingConstraint: CGFloat = -20.0
        static let doneButtonHeightConstraint: CGFloat = 60.0
        static let doneButtonBottomConstraint: CGFloat = -16.0
    }
    
    enum TableView {
        static let tableViewTopConstraint: CGFloat = 16.0
        static let tableViewLeadingConstraint: CGFloat = 16.0
        static let tableViewTrailingConstraint: CGFloat = -16.0
        static let tableViewBottomConstraint: CGFloat = -16.0
    }
}

final class ScheduleViewController: UIViewController {
    
    // MARK: - Public Properties
    var onSave: (([DayWeeks]) -> Void)?
    
    var activeDaysWeeks: [DayWeeks] = []
    
    // MARK: - Private Properties
    private let daysWeeks: [DayWeeks] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            ScheduleTableViewCell.self,
            forCellReuseIdentifier: ScheduleTableViewCell.identifier
        )
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("schedule_done_button_title".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = Theme.DoneButton.doneButtonCornerRadius
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
        title = "schedule_tite".localized
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        tableView.dataSource = self
        
        setupLayout()
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.TableView.tableViewTopConstraint),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.TableView.tableViewLeadingConstraint),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.TableView.tableViewTrailingConstraint),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: Theme.TableView.tableViewBottomConstraint),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.DoneButton.doneButtonLeadingConstraint),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.DoneButton.doneButtonTrailingConstraint),
            doneButton.heightAnchor.constraint(equalToConstant: Theme.DoneButton.doneButtonHeightConstraint),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Theme.DoneButton.doneButtonBottomConstraint)
        ])
    }
    
    @objc private func doneTapped() {
        activeDaysWeeks.sort { $0.rawValue < $1.rawValue }
        onSave?(activeDaysWeeks)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysWeeks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as? ScheduleTableViewCell else { return UITableViewCell()}
        
        let day = daysWeeks[indexPath.row]
        let isActive = activeDaysWeeks.contains(day)
        let isFirstCell = indexPath.row == 0
        let isLastCell = indexPath.row == daysWeeks.count - 1
        cell.configure(with: day, isOn: isActive, isFirstCell: isFirstCell, isLastCell: isLastCell)
        
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
        
        cell.backgroundColor = .clear
        
        return cell
    }
}
