//
//  ConfigurationTrackerViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 19.08.2025.
//

import UIKit

private enum Theme {
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
    
    static let alphaComponent: CGFloat = 0.3
    
    enum ConfigurationStackView {
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
    
    enum CollectionView {
        static let collectionViewHeaderHeight: CGFloat = 44.0
        static let collectionViewCellHeight: CGFloat = 52.0
        static let collectionViewCellCount: Int = 6
        static let collectionViewTopInset: CGFloat = 10.0
        static let collectionViewBottomInset: CGFloat = 0.0
        static let collectionViewLeftInset: CGFloat = 16.0
        static let collectionViewRightInset: CGFloat = 16.0
        static let collectionViewCellSpacing: CGFloat = 10.0
        static let collectionViewPaddingWidth = collectionViewLeftInset + collectionViewRightInset + CGFloat(collectionViewCellCount - 1) * collectionViewCellSpacing
        
        static let collectionViewTopConstraint: CGFloat = 20.0
        static let collectionViewHeightConstraint: CGFloat = 230.0
    }
}

final class ConfigurationTrackerViewController: UIViewController {
    
    // MARK: - Public properties
    var onCreate: ((Tracker, String) -> Void)?
    var trackerType: TrackerType = .habit
    var activeDate: Date = Date()
    
    // MARK: - Private properties
    private var trackerName: String = String()
    private var trackerCategory: String = String()
    private var trackerActiveDaysWeeks: [DayWeeks] = []
    private var trackerEmoji: String = String()
    private var trackerColor: UIColor = .clear
    
    private let emojies: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let colors: [UIColor] = [
        .trackerColorCollection1, .trackerColorCollection2, .trackerColorCollection3, .trackerColorCollection4, .trackerColorCollection5, .trackerColorCollection6,
        .trackerColorCollection7, .trackerColorCollection8, .trackerColorCollection9, .trackerColorCollection10, .trackerColorCollection11, .trackerColorCollection12,
        .trackerColorCollection13, .trackerColorCollection14, .trackerColorCollection15, .trackerColorCollection16, .trackerColorCollection17, .trackerColorCollection18
    ]
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = Theme.textFieldPlaceholder
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
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = Theme.warningText
        label.font = .systemFont(ofSize: Theme.warningLabelFontSize)
        label.textAlignment = .center
        label.textColor = .trackerRed
        label.isHidden = true
        return label
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, warningLabel])
        stackView.axis = .vertical
        stackView.spacing = Theme.ConfigurationStackView.stackViewSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .trackerLightGray
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
        button.backgroundColor = .trackerLightGray.withAlphaComponent(Theme.alphaComponent)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Theme.ActionButtons.configurationButtonsCornerRadius
        button.addTarget(self, action: #selector(categoryTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Theme.categoryButtonTitle
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: Theme.ActionButtons.configurationTitleLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = getCategoryRepresentation()
        label.textColor = .trackerGray
        label.font = UIFont.systemFont(ofSize: Theme.ActionButtons.configurationDescriptionLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [categoryTitleLabel, categoryDescriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = Theme.ConfigurationStackView.stackViewScheduleSpacing
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .trackerLightGray.withAlphaComponent(Theme.alphaComponent)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Theme.ActionButtons.configurationButtonsCornerRadius
        button.addTarget(self, action: #selector(scheduleTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var scheduleTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Theme.scheduleButtonTitle
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: Theme.ActionButtons.configurationTitleLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scheduleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = getActiveDaysWeeksRepresentation()
        label.textColor = .trackerGray
        label.font = UIFont.systemFont(ofSize: Theme.ActionButtons.configurationDescriptionLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scheduleButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [scheduleTitleLabel, scheduleDescriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = Theme.ConfigurationStackView.stackViewScheduleSpacing
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var configurationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [categoryButton, separator, scheduleButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var emojiCollectionController: EmojiCollectionController = {
        let emojiCollectionController = EmojiCollectionController.init(collectionView: emojiCollectionView)
        emojiCollectionController.emojies = emojies
        emojiCollectionController.onSelectEmoji = { [weak self] selectedEmoji in
            self?.trackerEmoji = selectedEmoji
            self?.updateCreateButtonState()
        }
        
        return emojiCollectionController
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var colorCollectionController: ColorCollectionController = {
        let colorCollectionController = ColorCollectionController.init(collectionView: colorCollectionView)
        colorCollectionController.colors = colors
        colorCollectionController.onSelectColor = { [weak self] selectedColor in
            self?.trackerColor = selectedColor
            self?.updateCreateButtonState()
        }
        
        return colorCollectionController
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Theme.cancelButtonTitle, for: .normal)
        button.setTitleColor(.trackerRed, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = Theme.ActionButtons.cancellButtonBorderWidth
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = Theme.ActionButtons.actionButtonsCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Theme.createButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .trackerGray
        button.layer.cornerRadius = Theme.ActionButtons.actionButtonsCornerRadius
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
        
        _ = emojiCollectionController
        _ = colorCollectionController
        
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
        presentCategoriesListAsSheet(trackerCategory: trackerCategory)
    }
    
    @objc private func scheduleTapped() {
        presentScheduleAsSheet(activeDaysWeeks: trackerActiveDaysWeeks)
    }
    
    // MARK: - Private methods
    private func getTitle() -> String {
        switch trackerType {
        case .habit: return Theme.habitTitle
        case .irregular: return Theme.irregularTitle
        }
    }
    
    private func getCategoryRepresentation() -> String {
        return trackerCategory
    }
    
    private func getActiveDaysWeeksRepresentation() -> String {
        var activeDaysWeeksRepresentation = String()
        
        if (trackerActiveDaysWeeks.count == Theme.allDaysOfWeekCount) {
            activeDaysWeeksRepresentation = Theme.everyDayRepresentation
        } else {
            trackerActiveDaysWeeks.enumerated().forEach { (index, activeDayWeeks) in
                let activeDayWeeksRepresentation = (index == trackerActiveDaysWeeks.count - 1) ? activeDayWeeks.shortRepresentation : activeDayWeeks.shortRepresentation + ", "
                activeDaysWeeksRepresentation.append(activeDayWeeksRepresentation)
            }
        }
        
        return activeDaysWeeksRepresentation
    }
    
    private func setupEmojiCollectionController() {
        
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(nameStackView)
        
        contentView.addSubview(configurationStackView)
        
        categoryButton.addSubview(categoryButtonStackView)
        scheduleButton.addSubview(scheduleButtonStackView)
        
        categoryButton.addSubview(categoryDisclosureIndicator)
        scheduleButton.addSubview(scheduleDisclosureIndicator)
        
        contentView.addSubview(emojiCollectionView)
        contentView.addSubview(colorCollectionView)
        
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -20.0),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Theme.ConfigurationStackView.stackViewTopConstraint),
            nameStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.ConfigurationStackView.stackViewLeadingConstraint),
            nameStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Theme.ConfigurationStackView.stackViewTrailingConstraint),
            
            nameTextField.heightAnchor.constraint(equalToConstant: Theme.NameTextField.nameTextFieldHeightConstraint),
            nameTextField.leadingAnchor.constraint(equalTo: nameStackView.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: nameStackView.trailingAnchor),
            
            configurationStackView.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: Theme.ActionButtons.categoryButtonTopConstraint),
            configurationStackView.leadingAnchor.constraint(equalTo: nameStackView.leadingAnchor),
            configurationStackView.trailingAnchor.constraint(equalTo: nameStackView.trailingAnchor),
            
            categoryButton.heightAnchor.constraint(equalToConstant: Theme.ActionButtons.configurationButtonsHeightConstraint),
            
            separator.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: Theme.Separator.separatorLeadingConstraint),
            separator.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: Theme.Separator.separatorTrailingConstraint),
            separator.heightAnchor.constraint(equalToConstant: Theme.Separator.separatorHeightConstraint),
            
            scheduleButton.heightAnchor.constraint(equalToConstant: Theme.ActionButtons.configurationButtonsHeightConstraint),
            
            categoryButtonStackView.topAnchor.constraint(equalTo: categoryButton.topAnchor, constant: Theme.ConfigurationStackView.stackViewConfigurationTopConstraint),
            categoryButtonStackView.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: Theme.ConfigurationStackView.stackViewConfigurationLeadingConstraint),
            categoryButtonStackView.trailingAnchor.constraint(equalTo: categoryDisclosureIndicator.leadingAnchor, constant: Theme.ConfigurationStackView.stackViewConfigurationTrailingConstraint),
            categoryButtonStackView.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: Theme.ConfigurationStackView.stackViewConfigurationBottomConstraint),
            
            scheduleButtonStackView.topAnchor.constraint(equalTo: scheduleButton.topAnchor, constant: Theme.ConfigurationStackView.stackViewConfigurationTopConstraint),
            scheduleButtonStackView.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: Theme.ConfigurationStackView.stackViewConfigurationLeadingConstraint),
            scheduleButtonStackView.trailingAnchor.constraint(equalTo: scheduleDisclosureIndicator.leadingAnchor, constant: Theme.ConfigurationStackView.stackViewConfigurationTrailingConstraint),
            scheduleButtonStackView.bottomAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: Theme.ConfigurationStackView.stackViewConfigurationBottomConstraint),
            
            categoryDisclosureIndicator.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            categoryDisclosureIndicator.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: Theme.configurationDisclosureIndicatorTrailingConstraint),
            
            scheduleDisclosureIndicator.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor),
            scheduleDisclosureIndicator.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: Theme.configurationDisclosureIndicatorTrailingConstraint),
            
            emojiCollectionView.topAnchor.constraint(equalTo: configurationStackView.bottomAnchor, constant: Theme.CollectionView.collectionViewTopConstraint),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: Theme.CollectionView.collectionViewHeightConstraint),
            
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: Theme.CollectionView.collectionViewTopConstraint),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: Theme.CollectionView.collectionViewHeightConstraint),
            colorCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.ActionButtons.cancelButtonLeadingConstraint),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Theme.ActionButtons.cancelButtonBottomConstraint),
            cancelButton.heightAnchor.constraint(equalToConstant: Theme.ActionButtons.cancelButtonHeightConstraint),
            cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Theme.ActionButtons.cancelButtonWidthConstraintMultiplier),
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.ActionButtons.createButtonTrailingConstraint),
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
    
    private func presentCategoriesListAsSheet(trackerCategory: String) {
        let categoriesListViewController = CategoriesListViewController()
        categoriesListViewController.trackerCategory = trackerCategory
        
        categoriesListViewController.onSelectCategory = { [weak self] newTrackerCategory in
            self?.trackerCategory = newTrackerCategory
            self?.categoryDescriptionLabel.text = self?.getCategoryRepresentation()
            
            self?.updateCreateButtonState()
        }
        
        let navigationController = UINavigationController(rootViewController: categoriesListViewController)
        navigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = Theme.sheetPresentationCornerRadius
        }
        
        present(navigationController, animated: true)
    }
    
    private func presentScheduleAsSheet(activeDaysWeeks: [DayWeeks]) {
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.activeDaysWeeks = activeDaysWeeks
        
        scheduleViewController.onSave = { [weak self] newActiveDays in
            self?.trackerActiveDaysWeeks = newActiveDays
            self?.scheduleDescriptionLabel.text = self?.getActiveDaysWeeksRepresentation()
            
            self?.updateCreateButtonState()
        }
        
        let navigationController = UINavigationController(rootViewController: scheduleViewController)
        navigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = Theme.sheetPresentationCornerRadius
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
            return !trackerName.isEmpty && !trackerCategory.isEmpty && !trackerActiveDaysWeeks.isEmpty && !trackerEmoji.isEmpty && trackerColor != .clear
        case .irregular:
            return !trackerName.isEmpty && !trackerCategory.isEmpty && !trackerEmoji.isEmpty && trackerColor != .clear
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
            id: UUID(),
            title: trackerName,
            color: trackerColor,
            emoji: trackerEmoji,
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
        
        if updatedText.count > Theme.NameTextField.nameTextFieldLimit {
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
        
        trackerName = String()
        
        updateCreateButtonState()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
