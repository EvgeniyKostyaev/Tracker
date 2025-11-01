//
//  CreatingTrackerViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.05.2025.
//

import UIKit

final class CreatingTrackerViewController: UIViewController {
    
    // MARK: - Public properties
    var onCreate: ((Tracker, String) -> Void)?
    var activeDate: Date = Date()
    
    // MARK: - Private properties
    private enum Theme {
        static let title: String = "Создание трекера"
        static let habitButtonTitle: String = "Привычка"
        static let irregularEventButtonTitle: String = "Нерегулярное событие"
        
        static let sheetPresentationCornerRadius: CGFloat = 16.0
        
        enum ActionButton {
            static let actionButtonFontSise: CGFloat =  16.0
            static let actionButtonCornerRadius: CGFloat =  16.0
            static let actionButtonHeightConstraint: CGFloat = 60.0
        }
        
        enum StackView {
            static let stackViewSpacing: CGFloat = 16.0
            static let stackViewLeadingConstraint: CGFloat = 20
            static let stackViewTrailingConstraint: CGFloat = -20
        }
    }
    
    private lazy var habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Theme.habitButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: Theme.ActionButton.actionButtonFontSise, weight: .medium)
        button.layer.cornerRadius = Theme.ActionButton.actionButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(habitButtonTaped), for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Theme.irregularEventButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: Theme.ActionButton.actionButtonFontSise, weight: .medium)
        button.layer.cornerRadius = Theme.ActionButton.actionButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(irregularEventButtonTaped), for: .touchUpInside)
        return button
    }()
    
    private lazy var optionButtonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [habitButton, irregularEventButton])
        stack.axis = .vertical
        stack.spacing = Theme.StackView.stackViewSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = Theme.title
        
        setupLayout()
    }
    
    // MARK: - Actions
    @objc private func habitButtonTaped() {
        presentConfigurationTrackerAsSheet(trackerType: .habit)
    }
    
    @objc private func irregularEventButtonTaped() {
        presentConfigurationTrackerAsSheet(trackerType: .irregular)
    }
    
    // MARK: - Private methods
    private func setupLayout() {
        view.addSubview(optionButtonsStack)
        
        NSLayoutConstraint.activate([
            optionButtonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.StackView.stackViewLeadingConstraint),
            optionButtonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.StackView.stackViewTrailingConstraint),
            optionButtonsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitButton.heightAnchor.constraint(equalToConstant: Theme.ActionButton.actionButtonHeightConstraint),
            irregularEventButton.heightAnchor.constraint(equalToConstant: Theme.ActionButton.actionButtonHeightConstraint)
        ])
    }
    
    private func presentConfigurationTrackerAsSheet(trackerType: TrackerType) {
        let configurationTrackerViewController = ConfigurationTrackerViewController()
        configurationTrackerViewController.trackerType = trackerType
        configurationTrackerViewController.activeDate = activeDate
        
        configurationTrackerViewController.onCreate = { [weak self] (newTracker, trackerCategory) in
            self?.onCreate?(newTracker, trackerCategory)
            
            self?.dismiss(animated: true)
        }
        
        let navigationController = UINavigationController(rootViewController: configurationTrackerViewController)
        navigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = Theme.sheetPresentationCornerRadius
        }
        
        present(navigationController, animated: true)
    }
}
