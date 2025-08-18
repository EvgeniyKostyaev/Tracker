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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = CreatingTrackerViewControllerTeme.title
        
        setupLayout()
        
        habitButton.addTarget(self, action: #selector(habitButtonTaped), for: .touchUpInside)
        irregularEventButton.addTarget(self, action: #selector(irregularEventButtonTaped), for: .touchUpInside)
    }
    
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
    
    // MARK: - Actions
    @objc private func habitButtonTaped() {
//        let habitViewController = HabitViewController()
//        presentAsSheet(habitViewController)
    }
    
    @objc private func irregularEventButtonTaped() {
//        let irregularEventViewController = IrregularEventViewController()
//        presentAsSheet(irregularEventViewController)
    }
    
    private func presentAsSheet(_ vc: UIViewController) {
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = CreatingTrackerViewControllerTeme.sheetPresentationCornerRadius
        }
        
        present(nav, animated: true)
    }
}
