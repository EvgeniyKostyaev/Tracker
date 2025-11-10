//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.05.2025.
//

import UIKit

private enum Theme {
    static let title: String = "Трекеры"
    static let searchPlaceholder: String = "Поиск"
    static let emptySatateTitle: String = "Что будем отслеживать?"
    
    static let sheetPresentationCornerRadius: CGFloat = 16.0
    
    enum CollectionView {
        static let collectionViewHeaderHeight: CGFloat = 44.0
        static let collectionViewCellHeight: CGFloat = 140.0
        static let collectionViewCellCount: Int = 2
        static let collectionViewTopInset: CGFloat = 0.0
        static let collectionViewBottomInset: CGFloat = 0.0
        static let collectionViewLeftInset: CGFloat = 16.0
        static let collectionViewRightInset: CGFloat = 16.0
        static let collectionViewCellSpacing: CGFloat = 10.0
        static let collectionViewPaddingWidth = collectionViewLeftInset + collectionViewRightInset + CGFloat(collectionViewCellCount - 1) * collectionViewCellSpacing
    }
    
    enum EmptyStateView {
        static let emptyStateViewLeadingConstraint: CGFloat = 16.0
        static let emptyStateViewTrailingConstraint: CGFloat = -16.0
    }
}

final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    private let filterTrackersUseCase = FilterTrackersUseCase()
    
    private let trackerCategoryDataProvider = TrackerCategoryDataProvider()
    private let trackerRecordDataProvider = TrackerRecordDataProvider()
    
    private var trackerCategories: [TrackerCategory] = []
    private var activeDate: Date = Date()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        collectionView.register(TrackerSupplementaryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSupplementaryHeaderView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var emptyStateView: EmptyStateView = {
        let emptyStateView = EmptyStateView(image: UIImage(resource: .noItems), text: Theme.emptySatateTitle)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        return emptyStateView
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerCategoryDataProvider.delegate = self
        trackerRecordDataProvider.delegate = self
        
        setupTitle()
        setupSearchController()
        setupAddBarButton()
        setupDatePicker()
        
        setupLayout()
        
        updateTrackersUI()
    }
    
    // MARK: - Action Methods
    @objc private func addButtonTapped() {
        presentCreatingTrackerAsSheet()
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        self.activeDate = sender.date
        
        updateTrackersUI()
    }
    
    // MARK: - Private Methods
    private func setupTitle() {
        title = Theme.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = Theme.searchPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
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
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.EmptyStateView.emptyStateViewLeadingConstraint),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.EmptyStateView.emptyStateViewTrailingConstraint),
        ])
    }
    
    private func updateTrackersUI() {
        let sourceTrackerCategories = trackerCategoryDataProvider.trackerCategories
        trackerCategories = filterTrackersUseCase.filterTrackerCategoriesList(sourceTrackerCategories, date: activeDate)
        
        if trackerCategories.count > 0 {
            collectionView.isHidden = false
            emptyStateView.isHidden = true
        } else {
            emptyStateView.isHidden = false
            collectionView.isHidden = true
        }
        
        collectionView.reloadData()
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
    
    private func isTrackerCompleted(for tracker: Tracker, from completedTrackers: [TrackerRecord]) -> Bool {
        completedTrackers.contains(where: { trackerRecord in
            return trackerRecord.trackerId == tracker.id && trackerRecord.date.isSameDayAs(activeDate)
        })
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

// MARK: - TrackerCategoryDataProviderDelegate Methods
extension TrackersViewController: TrackerCategoryDataProviderDelegate {
    func didUpdateCategories() {
        updateTrackersUI()
    }
}

// MARK: - TrackerRecordDataProviderDelegate Methods
extension TrackersViewController: TrackerRecordDataProviderDelegate {
    func didUpdateRecords() {
        collectionView.reloadData()
    }
}
