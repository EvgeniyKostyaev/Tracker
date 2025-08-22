//
//  CreatingTrackerViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.05.2025.
//

import UIKit

enum CreatingTrackerViewControllerTeme {
    static let title: String = "Создание трекера"
    
    static let actionButtonFontSise: CGFloat =  16.0
    static let actionButtonCornerRadius: CGFloat =  16.0
    static let actionButtonHeightConstraint: CGFloat = 60.0
    
    static let habitButtonTitle: String = "Привычка"
    static let irregularEventButtonTitle: String = "Нерегулярное событие"
    
    static let stackViewSpacing: CGFloat = 16.0
    static let stackLeadingConstraint: CGFloat = 20
    static let stackTrailingConstraint: CGFloat = -20
    
    static let sheetPresentationCornerRadius: CGFloat = 16.0
}

final class CreatingTrackerViewController: UIViewController {
    
    // MARK: - Public properties
    var onCreate: ((Tracker, String) -> Void)?
    
    // MARK: - Private properties
    private lazy var habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(CreatingTrackerViewControllerTeme.habitButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: CreatingTrackerViewControllerTeme.actionButtonFontSise, weight: .medium)
        button.layer.cornerRadius = CreatingTrackerViewControllerTeme.actionButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(habitButtonTaped), for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(CreatingTrackerViewControllerTeme.irregularEventButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: CreatingTrackerViewControllerTeme.actionButtonFontSise, weight: .medium)
        button.layer.cornerRadius = CreatingTrackerViewControllerTeme.actionButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(irregularEventButtonTaped), for: .touchUpInside)
        return button
    }()
    
    private lazy var optionButtonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [habitButton, irregularEventButton])
        stack.axis = .vertical
        stack.spacing = CreatingTrackerViewControllerTeme.stackViewSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = CreatingTrackerViewControllerTeme.title
        
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
            optionButtonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CreatingTrackerViewControllerTeme.stackLeadingConstraint),
            optionButtonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CreatingTrackerViewControllerTeme.stackTrailingConstraint),
            optionButtonsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitButton.heightAnchor.constraint(equalToConstant: CreatingTrackerViewControllerTeme.actionButtonHeightConstraint),
            irregularEventButton.heightAnchor.constraint(equalToConstant: CreatingTrackerViewControllerTeme.actionButtonHeightConstraint)
        ])
    }
    
    private func presentConfigurationTrackerAsSheet(trackerType: TrackerType) {
        let configurationTrackerViewController = ConfigurationTrackerViewController()
        configurationTrackerViewController.trackerType = trackerType
        
        configurationTrackerViewController.onCreate = { [weak self] (newTracker, trackerCategory) in
            self?.onCreate?(newTracker, trackerCategory)
            
            self?.dismiss(animated: true)
        }
        
        let navigationController = UINavigationController(rootViewController: configurationTrackerViewController)
        navigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = CreatingTrackerViewControllerTeme.sheetPresentationCornerRadius
        }
        
        present(navigationController, animated: true)
    }
}
