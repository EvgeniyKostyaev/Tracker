//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.05.2025.
//

import UIKit

private enum Theme {
    static let sheetPresentationCornerRadius: CGFloat = 16.0
    
    enum FiltersButton {
        static let filtersButtonFontSise: CGFloat =  17.0
        static let filtersButtonCornerRadius: CGFloat =  16.0
        
        static let filtersButtonBottomConstraint: CGFloat = -16.0
        static let filtersButtonHeightConstraint: CGFloat = 50.0
        static let filtersButtonWidthConstraint: CGFloat = 114.0
    }
    
    enum CollectionView {
        static let collectionViewHeaderHeight: CGFloat = 44.0
        static let collectionViewCellHeight: CGFloat = 140.0
        static let collectionViewCellCount: Int = 2
        static let collectionViewTopInset: CGFloat = 0.0
        static let collectionViewBottomInset: CGFloat = 0.0
        static let collectionViewLeftInset: CGFloat = 16.0
        static let collectionViewRightInset: CGFloat = 16.0
        static let collectionViewCellSpacing: CGFloat = 10.0
        static let collectionViewPaddingWidth: CGFloat = collectionViewLeftInset + collectionViewRightInset + CGFloat(collectionViewCellCount - 1) * collectionViewCellSpacing
        static let collectionViewContentInset: UIEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: FiltersButton.filtersButtonHeightConstraint + (FiltersButton.filtersButtonBottomConstraint) * -1, right: 0)
    }
    
    enum EmptyStateView {
        static let emptyStateViewLeadingConstraint: CGFloat = 16.0
        static let emptyStateViewTrailingConstraint: CGFloat = -16.0
    }
}

final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    private var analyticsService = AnalyticsService.shared
    
    private let filterTrackersUseCase = FilterTrackersUseCase()
    
    private let trackerCategoryDataProvider = TrackerCategoryDataProvider()
    private let trackerRecordDataProvider = TrackerRecordDataProvider.shared
    
    private var trackerCategories: [TrackerCategory] = []
    private var activeDate: Date = Date()
    private var searchKeyword: String = String()
    private var filter: Filter = .all
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        collectionView.register(TrackerSupplementaryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSupplementaryHeaderView.identifier)
        
        collectionView.contentInset = Theme.CollectionView.collectionViewContentInset
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var emptyMainStateView: EmptyStateView = {
        let emptyMainStateView = EmptyStateView(image: UIImage(resource: .noItems), text: "trackers_empty_main_satate_title".localized)
        emptyMainStateView.translatesAutoresizingMaskIntoConstraints = false
        
        return emptyMainStateView
    }()
    
    private lazy var emptyFilterStateView: EmptyStateView = {
        let emptySearchStateView = EmptyStateView(image: UIImage(resource: .nothingFound), text: "trackers_empty_filter_satate_title".localized)
        emptySearchStateView.translatesAutoresizingMaskIntoConstraints = false
        
        return emptySearchStateView
    }()
    
    private lazy var filtersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("trackers_filters".localized, for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.backgroundColor = .trackerBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: Theme.FiltersButton.filtersButtonFontSise, weight: .medium)
        button.layer.cornerRadius = Theme.FiltersButton.filtersButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filtersButtonTaped), for: .touchUpInside)
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        return datePicker
    }()
    
    // MARK: - Overrides Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logOpenCloseEvent(AnalyticsConstants.Value.open)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        logOpenCloseEvent(AnalyticsConstants.Value.close)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerCategoryDataProvider.delegate = self
        setupNotifications()
        
        setupTitle()
        setupSearchController()
        setupAddBarButton()
        setupDatePicker()
        setupLayout()
        
        updateTrackersUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Action Methods
    @objc private func addButtonTapped() {
        logClickEvent(AnalyticsConstants.Value.addTrack)
        
        presentCreatingTrackerAsSheet()
    }
    
    // MARK: - Actions
    @objc private func filtersButtonTaped() {
        logClickEvent(AnalyticsConstants.Value.filter)
        
        presentFiltersListAsSheet(filter: filter)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        self.activeDate = sender.date
        
        updateTrackersUI()
    }
    
    // MARK: - Private Methods
    private func setupTitle() {
        title = "common_trackers".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "trackers_search_placeholder".localized
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupAddBarButton() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        addButton.tintColor = UIColor(resource: .trackerBlack)
        navigationItem.leftBarButtonItem = addButton
    }
    
    private func setupDatePicker() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        view.addSubview(emptyMainStateView)
        view.addSubview(emptyFilterStateView)
        view.addSubview(filtersButton)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyMainStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyMainStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyMainStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.EmptyStateView.emptyStateViewLeadingConstraint),
            emptyMainStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.EmptyStateView.emptyStateViewTrailingConstraint),
            
            emptyFilterStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyFilterStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyFilterStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.EmptyStateView.emptyStateViewLeadingConstraint),
            emptyFilterStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.EmptyStateView.emptyStateViewTrailingConstraint),
            
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Theme.FiltersButton.filtersButtonBottomConstraint),
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.heightAnchor.constraint(equalToConstant: Theme.FiltersButton.filtersButtonHeightConstraint),
            filtersButton.widthAnchor.constraint(equalToConstant: Theme.FiltersButton.filtersButtonWidthConstraint)
        ])
    }
    
    private func updateTrackersUI() {
        let sourceTrackerCategories = trackerCategoryDataProvider.trackerCategories
        trackerCategories = filterTrackersUseCase.filterTrackerCategoriesList(sourceTrackerCategories, date: activeDate, searchKeyword: searchKeyword, filter: filter)
        
        if trackerCategories.count > 0 {
            collectionView.isHidden = false
            emptyMainStateView.isHidden = true
            emptyFilterStateView.isHidden = true
            
            filtersButton.isHidden = false
        } else {
            if (searchKeyword.isEmpty && !isActiveFilter()) {
                emptyMainStateView.isHidden = false
                emptyFilterStateView.isHidden = true
                
                filtersButton.isHidden = true
            } else {
                emptyFilterStateView.isHidden = false
                emptyMainStateView.isHidden = true
                
                filtersButton.isHidden = false
            }
            
            collectionView.isHidden = true
        }
        
        updateFilterButtonState()
        
        collectionView.reloadData()
    }
    
    private func updateFilterButtonState() {
        filtersButton.backgroundColor = isActiveFilter() ? .trackerRed : .trackerBlue
    }
    
    private func getCompletedDaysCount(for tracker: Tracker, from completedTrackers: [TrackerRecord]) -> Int {
        return completedTrackers.filter({ $0.trackerId == tracker.id }).count
    }
    
    private func addTracker(_ tracker: Tracker, toCategory categoryTitle: String) {
        let categoryStore = TrackerCategoryStore()
        let trackerStore = TrackerStore()
        
        if let categoryEntity = categoryStore.fetchCategoryEntity(by: categoryTitle) {
            trackerStore.addTracker(tracker, to: categoryEntity)
        } else {
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [tracker])
            categoryStore.addCategory(newCategory)
        }
    }
    
    private func editTracker(_ tracker: Tracker, toCategory categoryTitle: String) {
        let categoryStore = TrackerCategoryStore()
        let trackerStore = TrackerStore()
        
        if let categoryEntity = categoryStore.fetchCategoryEntity(by: categoryTitle) {
            trackerStore.editTracker(tracker, in: categoryEntity)
        }
    }
    
    private func deleteTracker(_ tracker: Tracker) {
        let trackerStore = TrackerStore()
        
        trackerStore.deleteTracker(by: tracker.id)
    }
    
    private func isTrackerCompleted(for tracker: Tracker, from completedTrackers: [TrackerRecord]) -> Bool {
        completedTrackers.contains(where: { trackerRecord in
            return trackerRecord.trackerId == tracker.id && trackerRecord.date.isSameDayAs(activeDate)
        })
    }
    
    private func isActiveFilter() -> Bool {
        return filter == .completed || filter == .uncompleted
    }
    
    private func presentCreatingTrackerAsSheet() {
        let creatingTrackerViewController = CreatingTrackerViewController()
        creatingTrackerViewController.activeDate = activeDate
        creatingTrackerViewController.onCreate = { [weak self] (newTracker, trackerCategory) in
            self?.addTracker(newTracker, toCategory: trackerCategory)
            self?.updateTrackersUI()
            
            self?.dismiss(animated: true)
        }
        
        let navigationController = UINavigationController(rootViewController: creatingTrackerViewController)
        navigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = Theme.sheetPresentationCornerRadius
        }
        
        present(navigationController, animated: true)
    }
    
    private func presentConfigurationTrackerAsSheet(tracker: Tracker, trackerCategory: String) {
        let configurationTrackerViewController = ConfigurationTrackerViewController()
        configurationTrackerViewController.configurationType = .edit
        configurationTrackerViewController.trackerId = tracker.id
        configurationTrackerViewController.trackerType = tracker.type
        configurationTrackerViewController.trackerName = tracker.title
        configurationTrackerViewController.trackerCategory = trackerCategory
        configurationTrackerViewController.trackerActiveDaysWeeks = tracker.schedule?.daysWeeks ?? []
        configurationTrackerViewController.trackerEmoji = tracker.emoji
        configurationTrackerViewController.trackerColor = tracker.color
        configurationTrackerViewController.activeDate = activeDate
        configurationTrackerViewController.completedDaysCount = tracker.completedDaysCount(from: trackerRecordDataProvider.trackerRecords)
        
        configurationTrackerViewController.onEdit = { [weak self] (tracker, trackerCategory) in
            self?.editTracker(tracker, toCategory: trackerCategory)
            self?.updateTrackersUI()
            
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
    
    private func presentFiltersListAsSheet(filter: Filter) {
        let filtersListViewModel = FiltersListViewModel()
        filtersListViewModel.currentFilter = filter
        filtersListViewModel.onSelectFilter = { [weak self] selectedFilter in
            self?.filter = selectedFilter
            
            if ( self?.filter == .allToday) {
                self?.activeDate = Date()
                
                self?.datePicker.date = Date()
            }
            
            self?.updateTrackersUI()
        }
        
        let filtersListViewController = FiltersListViewController()
        filtersListViewController.initialize(viewModel: filtersListViewModel)
        
        let navigationController = UINavigationController(rootViewController: filtersListViewController)
        navigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = Theme.sheetPresentationCornerRadius
        }
        
        present(navigationController, animated: true)
    }
    
    private func showDeleteConfirmation(onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "trackers_delete_сonfirmation".localized,
            message: nil,
            preferredStyle: .actionSheet
        )

        let deleteAction = UIAlertAction(title: "common_delete".localized, style: .destructive) { _ in
            onConfirm()
        }

        let cancelAction = UIAlertAction(title: "common_cancel".localized, style: .cancel)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX,
                                        y: self.view.bounds.maxY,
                                        width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        present(alert, animated: true)
    }
    
    private func logOpenCloseEvent(_ value: String) {
        analyticsService.logEvent(
            name: AnalyticsConstants.event,
            params: [
                AnalyticsConstants.Key.event: value,
                AnalyticsConstants.Key.screen: AnalyticsConstants.Value.main
            ]
        )
    }
    
    private func logClickEvent(_ value: String) {
        analyticsService.logEvent(
            name: AnalyticsConstants.event,
            params: [
                AnalyticsConstants.Key.event: AnalyticsConstants.Value.click,
                AnalyticsConstants.Key.screen: AnalyticsConstants.Value.main,
                AnalyticsConstants.Key.item: value
            ]
        )
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRecordsUpdate),
            name: TrackerRecordDataProvider.recordsDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func handleRecordsUpdate() {
        print("TEST_111: didUpdateRecords")
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource Methods
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trackerCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackerCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerSupplementaryHeaderView.identifier,
            for: indexPath
        ) as? TrackerSupplementaryHeaderView
        
        guard let header else {
            return UICollectionReusableView()
        }

        header.titleLabel.text = trackerCategories[indexPath.section].title

        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let tracker = trackerCategories[indexPath.section].trackers[indexPath.row]
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        let completedDaysCount = tracker.completedDaysCount(from: trackerRecordDataProvider.trackerRecords)
        let isCompleted = tracker.isCompleted(on: activeDate, from: trackerRecordDataProvider.trackerRecords)
        let isAvailable = tracker.isAvailable(on: activeDate)
        
        cell.configure(backgroundColor: tracker.color, title: tracker.title, emoji: tracker.emoji, dayCount: completedDaysCount, isCompleted: isCompleted, isAvailable: isAvailable)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate Methods
extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else {
            return nil
        }
        
        let trackerCategory = trackerCategories[indexPath.section].title
        let tracker = trackerCategories[indexPath.section].trackers[indexPath.row]
        
        let locationInCell = collectionView.convert(point, to: cell)
        
        if cell.cardView.frame.contains(locationInCell) {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: {
                let previewController = UIViewController()
                
                guard let snapshot = cell.cardView.snapshotView(afterScreenUpdates: true) else { return nil }
                snapshot.frame = CGRect(x: 0, y: 0, width: cell.cardView.frame.width, height: cell.cardView.frame.height)
                
                previewController.view.addSubview(snapshot)
                previewController.preferredContentSize = cell.cardView.frame.size
                
                return previewController
            }) { _ in
                return UIMenu(children: [
                    UIAction(title: "trackers_edit".localized) { [weak self] _ in
                        self?.logClickEvent(AnalyticsConstants.Value.edit)
                        self?.presentConfigurationTrackerAsSheet(tracker: tracker, trackerCategory: trackerCategory)
                    },
                    UIAction(
                        title: "common_delete".localized,
                        attributes: .destructive
                    ) { [weak self] _ in
                        self?.logClickEvent(AnalyticsConstants.Value.delete)
                        self?.showDeleteConfirmation(onConfirm: {
                            self?.deleteTracker(tracker)
                            self?.updateTrackersUI()
                        })
                    }
                ])
            }
        }
        
        return nil
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Methods
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Theme.CollectionView.collectionViewHeaderHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - Theme.CollectionView.collectionViewPaddingWidth
        let cellWidth =  availableWidth / CGFloat(Theme.CollectionView.collectionViewCellCount)
        
        return CGSize(width: cellWidth,
                      height: Theme.CollectionView.collectionViewCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: Theme.CollectionView.collectionViewTopInset,
            left: Theme.CollectionView.collectionViewLeftInset,
            bottom: Theme.CollectionView.collectionViewBottomInset,
            right: Theme.CollectionView.collectionViewRightInset
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Theme.CollectionView.collectionViewCellSpacing
    }
}

// MARK: - TrackerCollectionViewCellDelegate Methods
extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func trackerCell(_ cell: TrackerCollectionViewCell, onClickPlusButton indexPath: IndexPath?) {
        guard let indexPath else { return }
        
        logClickEvent(AnalyticsConstants.Value.track)
            
        let tracker = trackerCategories[indexPath.section].trackers[indexPath.row]
        
        let isCompleted = isTrackerCompleted(for: tracker, from: trackerRecordDataProvider.trackerRecords)
        
        let trackerRecordStore = TrackerRecordStore()
        
        if (isCompleted) {
            trackerRecordStore.deleteRecord(for: tracker.id, date: activeDate)
        } else {
            trackerRecordStore.addRecord(TrackerRecord(trackerId: tracker.id, date: activeDate))
        }
    }
}

// MARK: - UISearchResultsUpdating Methods
extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            self.searchKeyword = searchText
        }
        
        updateTrackersUI()
    }
}

// MARK: - UISearchBarDelegate Methods
extension TrackersViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchKeyword = String()
        updateTrackersUI()
    }
}

// MARK: - TrackerCategoryDataProviderDelegate Methods
extension TrackersViewController: TrackerCategoryDataProviderDelegate {
    func didUpdateCategories() {
        updateTrackersUI()
    }
}
