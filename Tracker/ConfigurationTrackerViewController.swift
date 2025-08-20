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
    static let textFieldLeftFrame: CGRect = CGRect(x: 0, y: 0, width: 12, height: 0)
    
    static let actionButtonsCornerRadius: CGFloat = 12.0
    
    static let configurationButtonsCornerRadius: CGFloat = 12.0
    static let configurationButtonsleftInset: CGFloat = 12.0
    static let configurationDescriptionLabelFontSize: CGFloat = 14.0
    
    static let categoryButtonTitle: String = "Категория"
    static let scheduleButtonTitle: String = "Расписание"
    
    static let cancelButtonTitle: String = "Отменить"
    static let cancellButtonBorderWidth: CGFloat = 1.0
    static let createButtonTitle: String = "Создать"
    
    static let warningText: String = "Ограничение 38 символов"
    
    static let nameTextFieldFontSize: CGFloat = 17.0
    static let warningLabelFontSize: CGFloat = 17.0
    
    static let nameTextFieldTopConstraint: CGFloat = 24.0
    static let nameTextFieldLeadingConstraint: CGFloat = 16.0
    static let nameTextFieldTrailingConstraint: CGFloat = -16.0
    static let nameTextFieldHeightConstraint: CGFloat = 75.0
    
    static let warningLabelTopConstraint: CGFloat = 8.0
    static let categoryButtonTopConstraint: CGFloat = 24.0
    
    static let configurationButtonsHeightConstraint: CGFloat = 75.0
    
    static let separatorLeadingConstraint: CGFloat = 16.0
    static let separatorTrailingConstraint: CGFloat = -16.0
    static let separatorHeightConstraint: CGFloat = 1.0
    
    static let configurationDescriptionLabelTrailingConstraint: CGFloat = -16.0
    
    static let cancelButtonLeadingConstraint: CGFloat = 20.0
    static let cancelButtonBottomConstraint: CGFloat = -16.0
    static let cancelButtonHeightConstraint: CGFloat = 60.0
    static let cancelButtonWidthConstraintMultiplier: CGFloat = 0.44
    
    static let createButtonTrailingConstraint: CGFloat = -20.0
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
        textField.font = .systemFont(ofSize: ConfigurationTrackerViewControllerTheme.nameTextFieldFontSize)
        textField.leftView = UIView(frame: ConfigurationTrackerViewControllerTheme.textFieldLeftFrame)
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .go
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = ConfigurationTrackerViewControllerTheme.warningText
        label.font = .systemFont(ofSize: ConfigurationTrackerViewControllerTheme.warningLabelFontSize)
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
        button.setTitle(ConfigurationTrackerViewControllerTheme.categoryButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: ConfigurationTrackerViewControllerTheme.configurationButtonsleftInset, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = ConfigurationTrackerViewControllerTheme.configurationButtonsCornerRadius
        button.addTarget(self, action: #selector(categoryTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(ConfigurationTrackerViewControllerTheme.scheduleButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: ConfigurationTrackerViewControllerTheme.configurationButtonsleftInset, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = ConfigurationTrackerViewControllerTheme.configurationButtonsCornerRadius
        button.addTarget(self, action: #selector(scheduleTapped), for: .touchUpInside)
        return button
    }()
    
    private let categoryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "—"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: ConfigurationTrackerViewControllerTheme.configurationDescriptionLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scheduleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Пн, Ср, Пт"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: ConfigurationTrackerViewControllerTheme.configurationDescriptionLabelFontSize)
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
        setupConfigurationButtonsState()
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
        
    }
    
    @objc private func scheduleTapped() {
        
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
        view.addSubview(scheduleButton)
        view.addSubview(separator)
        
        categoryButton.addSubview(categoryDescriptionLabel)
        scheduleButton.addSubview(scheduleDescriptionLabel)
        
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ConfigurationTrackerViewControllerTheme.nameTextFieldTopConstraint),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConfigurationTrackerViewControllerTheme.nameTextFieldLeadingConstraint),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ConfigurationTrackerViewControllerTheme.nameTextFieldTrailingConstraint),
            nameTextField.heightAnchor.constraint(equalToConstant: ConfigurationTrackerViewControllerTheme.nameTextFieldHeightConstraint),
            
            warningLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: ConfigurationTrackerViewControllerTheme.warningLabelTopConstraint),
            warningLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            categoryButton.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: ConfigurationTrackerViewControllerTheme.categoryButtonTopConstraint),
            categoryButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: ConfigurationTrackerViewControllerTheme.configurationButtonsHeightConstraint),
            
            separator.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: ConfigurationTrackerViewControllerTheme.separatorLeadingConstraint),
            separator.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: ConfigurationTrackerViewControllerTheme.separatorTrailingConstraint),
            separator.heightAnchor.constraint(equalToConstant: ConfigurationTrackerViewControllerTheme.separatorHeightConstraint),
            
            scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor),
            scheduleButton.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor),
            scheduleButton.heightAnchor.constraint(equalToConstant: ConfigurationTrackerViewControllerTheme.configurationButtonsHeightConstraint),
            
            categoryDescriptionLabel.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            categoryDescriptionLabel.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: ConfigurationTrackerViewControllerTheme.configurationDescriptionLabelTrailingConstraint),
            
            scheduleDescriptionLabel.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor),
            scheduleDescriptionLabel.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: ConfigurationTrackerViewControllerTheme.configurationDescriptionLabelTrailingConstraint),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConfigurationTrackerViewControllerTheme.cancelButtonLeadingConstraint),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: ConfigurationTrackerViewControllerTheme.cancelButtonBottomConstraint),
            cancelButton.heightAnchor.constraint(equalToConstant: ConfigurationTrackerViewControllerTheme.cancelButtonHeightConstraint),
            cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: ConfigurationTrackerViewControllerTheme.cancelButtonWidthConstraintMultiplier),
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ConfigurationTrackerViewControllerTheme.createButtonTrailingConstraint),
            createButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
    }
    
    private func setupConfigurationButtonsState() {
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
