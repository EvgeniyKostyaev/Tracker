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
    
    // MARK: - Private properties
    private let habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(CreatingTrackerViewControllerTeme.habitButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: CreatingTrackerViewControllerTeme.actionButtonFontSise, weight: .medium)
        button.layer.cornerRadius = CreatingTrackerViewControllerTeme.actionButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let irregularEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(CreatingTrackerViewControllerTeme.irregularEventButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: CreatingTrackerViewControllerTeme.actionButtonFontSise, weight: .medium)
        button.layer.cornerRadius = CreatingTrackerViewControllerTeme.actionButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = CreatingTrackerViewControllerTeme.title
        
        setupLayout()
        
        habitButton.addTarget(self, action: #selector(habitButtonTaped), for: .touchUpInside)
        irregularEventButton.addTarget(self, action: #selector(irregularEventButtonTaped), for: .touchUpInside)
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
        let stack = UIStackView(arrangedSubviews: [habitButton, irregularEventButton])
        stack.axis = .vertical
        stack.spacing = CreatingTrackerViewControllerTeme.stackViewSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CreatingTrackerViewControllerTeme.stackLeadingConstraint),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CreatingTrackerViewControllerTeme.stackTrailingConstraint),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitButton.heightAnchor.constraint(equalToConstant: CreatingTrackerViewControllerTeme.actionButtonHeightConstraint),
            irregularEventButton.heightAnchor.constraint(equalToConstant: CreatingTrackerViewControllerTeme.actionButtonHeightConstraint)
        ])
    }
    
    private func presentConfigurationTrackerAsSheet(trackerType: TrackerType) {
        let configurationTrackerViewController = ConfigurationTrackerViewController()
        configurationTrackerViewController.trackerType = trackerType
        let navigationController = UINavigationController(rootViewController: configurationTrackerViewController)
        navigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = CreatingTrackerViewControllerTeme.sheetPresentationCornerRadius
        }
        
        present(navigationController, animated: true)
    }
}
