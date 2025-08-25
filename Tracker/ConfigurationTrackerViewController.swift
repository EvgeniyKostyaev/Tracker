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
    static let categoryButtonTitle: String = "Категория"
    static let scheduleButtonTitle: String = "Расписание"
    static let cancelButtonTitle: String = "Отменить"
    static let createButtonTitle: String = "Создать"
    static let warningText: String = "Ограничение 38 символов"
    static let everyDayRepresentation: String = "Каждый день"
    
    static let warningLabelFontSize: CGFloat = 17.0
    
    static let configurationDescriptionLabelTrailingConstraint: CGFloat = -36.0
    static let configurationDisclosureIndicatorTrailingConstraint: CGFloat = -16.0
    
    static let sheetPresentationCornerRadius: CGFloat = 16.0
    
    static let allDaysOfWeekCount: Int = 7
    
    enum StackViewConfiguration {
        static let stackViewSpacing: CGFloat = 8.0
        static let stackViewTopConstraint: CGFloat = 24.0
        static let stackViewLeadingConstraint: CGFloat = 16.0
        static let stackViewTrailingConstraint: CGFloat = -16.0
        
        static let stackViewScheduleSpacing: CGFloat = 2.0
        
        static let stackViewConfigurationTopConstraint: CGFloat = 16.0
        static let stackViewConfigurationLeadingConstraint: CGFloat = 16.0
        static let stackViewConfigurationTrailingConstraint: CGFloat = -16.0
        static let stackViewConfigurationBottomConstraint: CGFloat = -16.0
    }
    
    enum NameTextField {
        static let nameTextFieldCornerRadius: CGFloat = 16.0
        static let nameTextFieldLimit: Int = 38
        static let nameTextFieldLeftFrame: CGRect = CGRect(x: 0, y: 0, width: 12, height: 0)
        static let nameTextFieldFontSize: CGFloat = 17.0
        static let nameTextFieldHeightConstraint: CGFloat = 75.0
    }
    
    enum ActionButtons {
        static let actionButtonsCornerRadius: CGFloat = 16.0
        
        static let categoryButtonTopConstraint: CGFloat = 24.0
        
        static let configurationButtonsCornerRadius: CGFloat = 16.0
        static let configurationButtonsleftInset: CGFloat = 12.0
        static let configurationTitleLabelFontSize: CGFloat = 17.0
        static let configurationDescriptionLabelFontSize: CGFloat = 17.0
        static let configurationButtonsHeightConstraint: CGFloat = 75.0
        
        static let cancellButtonBorderWidth: CGFloat = 1.0
        static let cancelButtonLeadingConstraint: CGFloat = 20.0
        static let cancelButtonBottomConstraint: CGFloat = -16.0
        static let cancelButtonHeightConstraint: CGFloat = 60.0
        static let cancelButtonWidthConstraintMultiplier: CGFloat = 0.44
        
        static let createButtonTrailingConstraint: CGFloat = -20.0
    }
    
    enum Separator {
        static let separatorLeadingConstraint: CGFloat = 16.0
        static let separatorTrailingConstraint: CGFloat = -16.0
        static let separatorHeightConstraint: CGFloat = 1.0
    }
}

final class ConfigurationTrackerViewController: UIViewController {
    
    // MARK: - Public properties
    var onCreate: ((Tracker, String) -> Void)?
    var trackerType: TrackerType = .habit
    var activeDate: Date = Date()
    
    // MARK: - Private properties
    private var trackerName = String()
    private var trackerCategory = "Важное" // this is stub for now
    private var trackerActiveDaysWeeks: [DayWeeks] = []
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = ConfigurationTrackerViewControllerTheme.textFieldPlaceholder
        textField.backgroundColor = .trackerLightGray
        textField.layer.cornerRadius = ConfigurationTrackerViewControllerTheme.NameTextField.nameTextFieldCornerRadius
        textField.font = .systemFont(ofSize: ConfigurationTrackerViewControllerTheme.NameTextField.nameTextFieldFontSize)
        textField.leftView = UIView(frame: ConfigurationTrackerViewControllerTheme.NameTextField.nameTextFieldLeftFrame)
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
        label.textColor = .trackerRed
        label.isHidden = true
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, warningLabel])
        stackView.axis = .vertical
        stackView.spacing = ConfigurationTrackerViewControllerTheme.StackViewConfiguration.stackViewSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let categoryDisclosureIndicator: UIImageView = {
        let indicator = UIImageView.init(image: .chevron)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let scheduleDisclosureIndicator: UIImageView = {
        let indicator = UIImageView.init(image: .chevron)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .trackerLightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = ConfigurationTrackerViewControllerTheme.ActionButtons.configurationButtonsCornerRadius
        button.addTarget(self, action: #selector(categoryTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ConfigurationTrackerViewControllerTheme.categoryButtonTitle
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: ConfigurationTrackerViewControllerTheme.ActionButtons.configurationTitleLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = getCategoryRepresentation()
        label.textColor = .trackerGray
        label.font = UIFont.systemFont(ofSize: ConfigurationTrackerViewControllerTheme.ActionButtons.configurationDescriptionLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackViewCategoryButton: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [categoryTitleLabel, categoryDescriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = ConfigurationTrackerViewControllerTheme.StackViewConfiguration.stackViewScheduleSpacing
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .trackerLightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = ConfigurationTrackerViewControllerTheme.ActionButtons.configurationButtonsCornerRadius
        button.addTarget(self, action: #selector(scheduleTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var scheduleTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ConfigurationTrackerViewControllerTheme.scheduleButtonTitle
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: ConfigurationTrackerViewControllerTheme.ActionButtons.configurationTitleLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scheduleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = getActiveDaysWeeksRepresentation()
        label.textColor = .trackerGray
        label.font = UIFont.systemFont(ofSize: ConfigurationTrackerViewControllerTheme.ActionButtons.configurationDescriptionLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackViewScheduleButton: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [scheduleTitleLabel, scheduleDescriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = ConfigurationTrackerViewControllerTheme.StackViewConfiguration.stackViewScheduleSpacing
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(ConfigurationTrackerViewControllerTheme.cancelButtonTitle, for: .normal)
        button.setTitleColor(.trackerRed, for: .normal)
        button.layer.borderWidth = ConfigurationTrackerViewControllerTheme.ActionButtons.cancellButtonBorderWidth
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = ConfigurationTrackerViewControllerTheme.ActionButtons.actionButtonsCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(ConfigurationTrackerViewControllerTheme.createButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .trackerGray
        button.layer.cornerRadius = ConfigurationTrackerViewControllerTheme.ActionButtons.actionButtonsCornerRadius
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
        
        updateCreateButtonState()
    }
    
    // MARK: - Action methods
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createTapped() {
        onCreate?(getNewTracker(), trackerCategory)
        
        dismiss(animated: true)
    }
    
    @objc private func categoryTapped() {
        
    }
    
    @objc private func scheduleTapped() {
        presentConfigurationScheduleAsSheet(activeDaysWeeks: trackerActiveDaysWeeks)
    }
    
    // MARK: - Private methods
    private func getTitle() -> String {
        switch trackerType {
        case .habit: return ConfigurationTrackerViewControllerTheme.habitTitle
        case .irregular: return ConfigurationTrackerViewControllerTheme.irregularTitle
        }
    }
    
    private func getCategoryRepresentation() -> String {
        return trackerCategory
    }
    
    private func getActiveDaysWeeksRepresentation() -> String {
        var activeDaysWeeksRepresentation = String()
        
        if (trackerActiveDaysWeeks.count == ConfigurationTrackerViewControllerTheme.allDaysOfWeekCount) {
            activeDaysWeeksRepresentation = ConfigurationTrackerViewControllerTheme.everyDayRepresentation
        } else {
            trackerActiveDaysWeeks.enumerated().forEach { (index, activeDayWeeks) in
                let activeDayWeeksRepresentation = (index == trackerActiveDaysWeeks.count - 1) ? activeDayWeeks.shortRepresentation : activeDayWeeks.shortRepresentation + ", "
                activeDaysWeeksRepresentation.append(activeDayWeeksRepresentation)
            }
        }
        
        return activeDaysWeeksRepresentation
    }
    
    private func setupLayout() {
        view.addSubview(stackView)
        
        view.addSubview(categoryButton)
        view.addSubview(scheduleButton)
        view.addSubview(separator)
        
        categoryButton.addSubview(stackViewCategoryButton)
        scheduleButton.addSubview(stackViewScheduleButton)
        
        categoryButton.addSubview(categoryDisclosureIndicator)
        scheduleButton.addSubview(scheduleDisclosureIndicator)
        
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ConfigurationTrackerViewControllerTheme.StackViewConfiguration.stackViewTopConstraint),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConfigurationTrackerViewControllerTheme.StackViewConfiguration.stackViewLeadingConstraint),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ConfigurationTrackerViewControllerTheme.StackViewConfiguration.stackViewTrailingConstraint),
            
            nameTextField.heightAnchor.constraint(equalToConstant: ConfigurationTrackerViewControllerTheme.NameTextField.nameTextFieldHeightConstraint),
            nameTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            categoryButton.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: ConfigurationTrackerViewControllerTheme.ActionButtons.categoryButtonTopConstraint),
            categoryButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: ConfigurationTrackerViewControllerTheme.ActionButtons.configurationButtonsHeightConstraint),
            
            separator.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: ConfigurationTrackerViewControllerTheme.Separator.separatorLeadingConstraint),
            separator.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: ConfigurationTrackerViewControllerTheme.Separator.separatorTrailingConstraint),
            separator.heightAnchor.constraint(equalToConstant: ConfigurationTrackerViewControllerTheme.Separator.separatorHeightConstraint),
            
            scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor),
            scheduleButton.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor),
            scheduleButton.heightAnchor.constraint(equalToConstant: ConfigurationTrackerViewControllerTheme.ActionButtons.configurationButtonsHeightConstraint),
            
            stackViewCategoryButton.topAnchor.constraint(equalTo: categoryButton.topAnchor, constant: ConfigurationTrackerViewControllerTheme.StackViewConfiguration.stackViewConfigurationTopConstraint),
            stackViewCategoryButton.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: ConfigurationTrackerViewControllerTheme.StackViewConfiguration.stackViewConfigurationLeadingConstraint),
            stackViewCategoryButton.trailingAnchor.constraint(equalTo: categoryDisclosureIndicator.leadingAnchor, constant: ConfigurationTrackerViewControllerTheme.StackViewConfiguration.stackViewConfigurationTrailingConstraint),
            stackViewCategoryButton.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: ConfigurationTrackerViewControllerTheme.StackViewConfiguration.stackViewConfigurationBottomConstraint),
            
            stackViewScheduleButton.topAnchor.constraint(equalTo: scheduleButton.topAnchor, constant: ConfigurationTrackerViewControllerTheme.StackViewConfiguration.stackViewConfigurationTopConstraint),
            stackViewScheduleButton.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: ConfigurationTrackerViewControllerTheme.StackViewConfiguration.stackViewConfigurationLeadingConstraint),
            stackViewScheduleButton.trailingAnchor.constraint(equalTo: scheduleDisclosureIndicator.leadingAnchor, constant: ConfigurationTrackerViewControllerTheme.StackViewConfiguration.stackViewConfigurationTrailingConstraint),
            stackViewScheduleButton.bottomAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: ConfigurationTrackerViewControllerTheme.StackViewConfiguration.stackViewConfigurationBottomConstraint),
            
            categoryDisclosureIndicator.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            categoryDisclosureIndicator.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: ConfigurationTrackerViewControllerTheme.configurationDisclosureIndicatorTrailingConstraint),
            
            scheduleDisclosureIndicator.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor),
            scheduleDisclosureIndicator.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: ConfigurationTrackerViewControllerTheme.configurationDisclosureIndicatorTrailingConstraint),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConfigurationTrackerViewControllerTheme.ActionButtons.cancelButtonLeadingConstraint),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: ConfigurationTrackerViewControllerTheme.ActionButtons.cancelButtonBottomConstraint),
            cancelButton.heightAnchor.constraint(equalToConstant: ConfigurationTrackerViewControllerTheme.ActionButtons.cancelButtonHeightConstraint),
            cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: ConfigurationTrackerViewControllerTheme.ActionButtons.cancelButtonWidthConstraintMultiplier),
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ConfigurationTrackerViewControllerTheme.ActionButtons.createButtonTrailingConstraint),
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
    
    private func presentConfigurationScheduleAsSheet(activeDaysWeeks: [DayWeeks]) {
        let configurationScheduleViewController = ConfigurationScheduleViewController()
        configurationScheduleViewController.activeDaysWeeks = activeDaysWeeks
        
        configurationScheduleViewController.onSave = { [weak self] newActiveDays in
            self?.trackerActiveDaysWeeks = newActiveDays
            self?.scheduleDescriptionLabel.text = self?.getActiveDaysWeeksRepresentation()
            
            self?.updateCreateButtonState()
        }
        
        let navigationController = UINavigationController(rootViewController: configurationScheduleViewController)
        navigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = ConfigurationTrackerViewControllerTheme.sheetPresentationCornerRadius
        }
        
        present(navigationController, animated: true)
    }
    
    private func updateCreateButtonState() {
        if (isValidateConfiguration()) {
            enableCreateButton()
        } else {
            disableCreateButton()
        }
    }
    
    private func isValidateConfiguration() -> Bool {
        switch (trackerType) {
        case .habit:
            return !trackerName.isEmpty && !trackerCategory.isEmpty && !trackerActiveDaysWeeks.isEmpty
        case .irregular:
            return !trackerName.isEmpty && !trackerCategory.isEmpty
        }
    }
    
    private func enableCreateButton() {
        createButton.isEnabled = true
        createButton.backgroundColor = .black
    }
    
    private func disableCreateButton() {
        createButton.isEnabled = false
        createButton.backgroundColor = .trackerGray
    }
    
    private func getNewTracker() -> Tracker {
        
        let schedule: Schedule
        
        switch trackerType {
        case .habit:
            schedule = Schedule(daysWeeks: trackerActiveDaysWeeks, date: nil)
        case .irregular:
            schedule = Schedule(daysWeeks: nil, date: activeDate)
        }
        
        let tracker = Tracker(
            id: Int.random(in: 0..<1000000),
            title: trackerName,
            color: .systemIndigo,
            emoji: "❤️",
            type: trackerType,
            schedule: schedule)
        
        return tracker
    }
}

// MARK: - UITextFieldDelegate methods
extension ConfigurationTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let textRange = Range(range, in: currentText) else { return true }
        
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        
        if updatedText.count > ConfigurationTrackerViewControllerTheme.NameTextField.nameTextFieldLimit {
            warningLabel.isHidden = false
            return false
        } else {
            warningLabel.isHidden = true
        }
        
        trackerName = updatedText.trimmingCharacters(in: .whitespaces)
        
        updateCreateButtonState()
        
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
