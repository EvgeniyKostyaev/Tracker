//
//  ConfigurationTrackerViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 19.08.2025.
//

import UIKit

enum ConfigurationTrackerViewControllerTheme {
    static let habitTitle: String = "Новая привычка"
    static let irregularTitle: String = "Новое нерегулярное событие"
    
    static let textFieldPlaceholder: String = "Введите название трекера"
    static let textFieldCornerRadius: CGFloat = 12.0
    
    static let actionButtonsCornerRadius: CGFloat = 12.0
    
    static let cancelButtonTitle: String = "Отменить"
    static let cancellButtonBorderWidth: CGFloat = 1.0
    static let createButtonTitle: String = "Создать"
}

final class ConfigurationTrackerViewController: UIViewController {
    
    // MARK: - Public properties
    var onCreate: ((Tracker) -> Void)?
    
    var trackerType: TrackerType = .habit
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ConfigurationTrackerViewControllerTheme.textFieldPlaceholder
        textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textField.layer.cornerRadius = ConfigurationTrackerViewControllerTheme.textFieldCornerRadius
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Private properties
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(ConfigurationTrackerViewControllerTheme.cancelButtonTitle, for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.borderWidth = ConfigurationTrackerViewControllerTheme.cancellButtonBorderWidth
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = ConfigurationTrackerViewControllerTheme.actionButtonsCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(ConfigurationTrackerViewControllerTheme.createButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = ConfigurationTrackerViewControllerTheme.actionButtonsCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = getTitle()
        setupLayout()
    }
    
    // MARK: - Actions
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createTapped() {
//        let tracker = Tracker(
//            name: nameTextField.text ?? "",
//            category: "Категория",
//            schedule: nil
//        )
//        onCreate?(tracker)
        dismiss(animated: true)
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    private func getTitle() -> String {
        switch (trackerType) {
        case .habit: return ConfigurationTrackerViewControllerTheme.habitTitle
        case .irregular: return ConfigurationTrackerViewControllerTheme.irregularTitle
        }
    }
    
    private func setupLayout() {
        view.addSubview(nameTextField)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 60),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.44),
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
    }
}
