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
    static let textFieldLimit: Int = 38
    
    static let actionButtonsCornerRadius: CGFloat = 12.0
    
    static let cancelButtonTitle: String = "Отменить"
    static let cancellButtonBorderWidth: CGFloat = 1.0
    static let createButtonTitle: String = "Создать"
    
    static let warningText: String = "Ограничение 38 символов"
}

final class ConfigurationTrackerViewController: UIViewController {
    
    // MARK: - Public properties
    var onCreate: ((Tracker) -> Void)?
    var trackerType: TrackerType = .habit
    
    // MARK: - Private properties
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = ConfigurationTrackerViewControllerTheme.textFieldPlaceholder
        textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textField.layer.cornerRadius = ConfigurationTrackerViewControllerTheme.textFieldCornerRadius
        textField.font = .systemFont(ofSize: 17)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .go
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = ConfigurationTrackerViewControllerTheme.warningText
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.textColor = .red
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Категория", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(categoryTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Расписание", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(scheduleTapped), for: .touchUpInside)
        return button
    }()
    
    private let categoryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "—"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scheduleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Пн, Ср, Пт"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = getTitle()
        
        setupLayout()
        setupOptionButtonsState()
        setupTapGesture()
    }
    
    // MARK: - Action methods
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createTapped() {
        dismiss(animated: true)
    }
    
    @objc private func categoryTapped() {
        // TODO: push/present Category screen
    }
    
    @objc private func scheduleTapped() {
        // TODO: push/present Schedule screen
    }
    
    // MARK: - Private methods
    private func getTitle() -> String {
        switch trackerType {
        case .habit: return ConfigurationTrackerViewControllerTheme.habitTitle
        case .irregular: return ConfigurationTrackerViewControllerTheme.irregularTitle
        }
    }
    
    private func enableCreateButton() {
        createButton.isEnabled = true
        createButton.backgroundColor = .black
    }
    
    private func disableCreateButton() {
        createButton.isEnabled = false
        createButton.backgroundColor = .lightGray
    }
    
    private func setupLayout() {
        view.addSubview(nameTextField)
        view.addSubview(warningLabel)
        
        view.addSubview(categoryButton)
        view.addSubview(separator)
        view.addSubview(scheduleButton)
        
        categoryButton.addSubview(categoryDescriptionLabel)
        scheduleButton.addSubview(scheduleDescriptionLabel)
        
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            warningLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            warningLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            categoryButton.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 24),
            categoryButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            separator.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            scheduleButton.topAnchor.constraint(equalTo: separator.bottomAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor),
            scheduleButton.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            
            categoryDescriptionLabel.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            categoryDescriptionLabel.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            
            scheduleDescriptionLabel.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor),
            scheduleDescriptionLabel.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -16),
            
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
    
    private func setupOptionButtonsState() {
        switch (trackerType) {
        case .habit:
            categoryButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            scheduleButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .irregular:
            separator.isHidden = true
            scheduleButton.isHidden = true
        }
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate methods
extension ConfigurationTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let textRange = Range(range, in: currentText) else { return true }
        
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        
        if updatedText.count > ConfigurationTrackerViewControllerTheme.textFieldLimit {
            warningLabel.isHidden = false
            return false
        } else {
            warningLabel.isHidden = true
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        warningLabel.isHidden = true
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
