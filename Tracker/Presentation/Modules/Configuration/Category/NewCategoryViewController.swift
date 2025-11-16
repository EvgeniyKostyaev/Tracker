//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 04.11.2025.
//

import UIKit

private enum Theme {
    enum NameTextField {
        static let nameTextFieldCornerRadius: CGFloat = 16.0
        static let nameTextFieldLimit: Int = 30
        static let nameTextFieldLeftFrame: CGRect = CGRect(x: 0, y: 0, width: 12, height: 0)
        static let nameTextFieldFontSize: CGFloat = 17.0
        static let nameTextFieldHeightConstraint: CGFloat = 75.0
    }
    
    enum DoneButton {
        static let doneButtonCornerRadius: CGFloat = 16.0
        static let doneButtonBottomConstraint: CGFloat = -16.0
        static let doneButtonLeadingConstraint: CGFloat = 20.0
        static let doneButtonTrailingConstraint: CGFloat = -20.0
        static let doneButtonHeightConstraint: CGFloat = 60.0
    }
    
    static let alphaComponent: CGFloat = 0.3
}

final class NewCategoryViewController: UIViewController {
    
    // MARK: - Public Properties
    var onCreateCategory: ((String) -> Void)?
    
    // MARK: - Private Properties
    private var categoryName: String = String()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "new_category_text_field_placeholder".localized
        textField.backgroundColor = .trackerLightGray.withAlphaComponent(Theme.alphaComponent)
        textField.layer.cornerRadius = Theme.NameTextField.nameTextFieldCornerRadius
        textField.font = .systemFont(ofSize: Theme.NameTextField.nameTextFieldFontSize)
        textField.leftView = UIView(frame: Theme.NameTextField.nameTextFieldLeftFrame)
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .go
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("new_category_done_button_title".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = Theme.DoneButton.doneButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "new_category_title".localized
        
        updateDoneButtonState()
        
        setupTapGesture()
        
        setupLayout()
    }
    
    // MARK: - Action methods
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func doneTapped() {
        onCreateCategory?(categoryName)
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setupLayout() {
        view.addSubview(nameTextField)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            nameTextField.heightAnchor.constraint(equalToConstant: Theme.NameTextField.nameTextFieldHeightConstraint),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.DoneButton.doneButtonLeadingConstraint),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.DoneButton.doneButtonTrailingConstraint),
            doneButton.heightAnchor.constraint(equalToConstant: Theme.DoneButton.doneButtonHeightConstraint),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Theme.DoneButton.doneButtonBottomConstraint)
        ])
    }
    
    private func updateDoneButtonState() {
        if (isValidateCategory()) {
            enableDoneButton()
        } else {
            disableDoneButton()
        }
    }
    
    private func isValidateCategory() -> Bool {
        return !categoryName.isEmpty
    }
    
    private func enableDoneButton() {
        doneButton.isEnabled = true
        doneButton.backgroundColor = .black
    }
    
    private func disableDoneButton() {
        doneButton.isEnabled = false
        doneButton.backgroundColor = .trackerGray
    }
}

// MARK: - UITextFieldDelegate methods
extension NewCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let textRange = Range(range, in: currentText) else { return true }
        
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        
        if updatedText.count > Theme.NameTextField.nameTextFieldLimit {
            return false
        }
        
        categoryName = updatedText.trimmingCharacters(in: .whitespaces)
        
        updateDoneButtonState()
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        categoryName = String()
        
        updateDoneButtonState()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        
        return true
    }
}
