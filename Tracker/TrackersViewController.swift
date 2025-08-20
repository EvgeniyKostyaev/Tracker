//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.05.2025.
//

import UIKit

enum TrackersViewControllerTheme {
    static let collectionViewHeaderHeight: CGFloat = 44.0
    static let collectionViewCellHeight: CGFloat = 140.0
    static let collectionViewCellCount: Int = 2
    static let collectionViewTopInset: CGFloat = 0.0
    static let collectionViewBottomInset: CGFloat = 0.0
    static let collectionViewLeftInset: CGFloat = 16.0
    static let collectionViewRightInset: CGFloat = 16.0
    static let collectionViewCellSpacing: CGFloat = 10.0
    static let collectionViewPaddingWidth = collectionViewLeftInset + collectionViewRightInset + CGFloat(collectionViewCellCount - 1) * collectionViewCellSpacing
    
    static let sheetPresentationCornerRadius: CGFloat = 16.0
}

final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    private let filterTrackersUseCase = FilterTrackersUseCase()
    
    private var sourceTrackerCategories: [TrackerCategory] = []
    private var trackerCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var activeDate: Date = Date()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let emptyView = EmptyStateView(image: UIImage(resource: .noTrackers), text: "Что будем отслеживать?")
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        setupSearchController()
        setupAddBarButton()
        setupDatePicker()
        
        setupCollectionView()
        setupEmptyView()
        
        temporaryTrackersStub()
        updateTrackersUI()
    }
    
    // MARK: - Action methods
    @objc private func addButtonTapped() {
//        let categoryTitle = "Домашний уют"
//
//        let newTracker = Tracker(
//            id: 7,
//            title: "Поливать растения",
//            color: .systemIndigo,
//            emoji: "❤️",
//            type: .habit,
//            schedule: Schedule(weekdays: [Weekday(rawValue: activeDate.dayOfWeek)])
//        )
//
//        addTracker(newTracker, toCategory: categoryTitle)
//
//        updateTrackersUI()
        
        presentCreatingTrackerAsSheet()
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        self.activeDate = sender.date
        
        updateTrackersUI()
    }
    
    // MARK: - Private Methods
    private func temporaryTrackersStub() {
        let tracker1 = Tracker(
            id: 1,
            title: "Сделать уборку",
            color: .systemGreen,
            emoji: "❤️",
            type: .habit,
            schedule: Schedule(weekdays: [.saturday])
        )
        
        let tracker2 = Tracker(
            id: 2,
            title: "Помыть посуду",
            color: .systemRed,
            emoji: "❤️",
            type: .habit,
            schedule: Schedule(weekdays: [.tuesday, .wednesday, .thursday, .friday])
        )
        
        let tracker3 = Tracker(
            id: 3,
            title: "Подать показания счетчиков",
            color: .systemBlue,
            emoji: "❤️",
            type: .habit,
            schedule: nil
        )
        
        let tracker4 = Tracker(
            id: 4,
            title: "Свидание в слепую",
            color: .systemOrange,
            emoji: "❤️",
            type: .habit,
            schedule: nil
        )
        
        let tracker5 = Tracker(
            id: 5,
            title: "Плавание в бассейне",
            color: .systemYellow,
            emoji: "❤️",
            type: .habit,
            schedule: Schedule(weekdays: [.monday, .thursday, .friday, .sunday])
        )
        
        let homeCategory = TrackerCategory(title: "Домашний уют", trackers: [tracker1, tracker2, tracker3])
        let happyCategory = TrackerCategory(title: "Радостные мелочи", trackers: [tracker4, tracker5])
    
        sourceTrackerCategories.append(contentsOf: [homeCategory, happyCategory])
    }
    
    private func setupTitle() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Поиск"
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
    
    private func setupCollectionView() {
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        collectionView.register(TrackerSupplementaryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSupplementaryHeaderView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupEmptyView() {
        view.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateTrackersUI() {
        trackerCategories = filterTrackersUseCase.filterTrackerCategoriesList(sourceTrackerCategories, date: activeDate)
        
        if trackerCategories.count > 0 {
            collectionView.isHidden = false
            emptyView.isHidden = true
        } else {
            emptyView.isHidden = false
            collectionView.isHidden = true
        }
        
        collectionView.reloadData()
    }
    
    private func getCompletedDaysCount(for tracker: Tracker, from completedTrackers: [TrackerRecord]) -> Int {
        return completedTrackers.filter({ $0.trackerId == tracker.id }).count
    }
    
    private func addTracker(_ tracker: Tracker, toCategory categoryTitle: String) {
        var sectionIndex: Int
        
        if let existingIndex = sourceTrackerCategories.firstIndex(where: { $0.title == categoryTitle }) {
            sectionIndex = existingIndex
        } else {
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [])
            sourceTrackerCategories.append(newCategory)
            
            sectionIndex = sourceTrackerCategories.count - 1
            
//            collectionView.performBatchUpdates {
//                collectionView.insertSections(IndexSet(integer: sectionIndex))
//            }
        }
        
//        let newRowIndex = sourceTrackerCategories[sectionIndex].trackers.count
        sourceTrackerCategories[sectionIndex].trackers.append(tracker)
        
//        collectionView.performBatchUpdates {
//            collectionView.insertItems(at: [IndexPath(row: newRowIndex, section: sectionIndex)])
//        }
    }
    
    private func isTrackerCompleted(for tracker: Tracker, from completedTrackers: [TrackerRecord]) -> Bool {
        completedTrackers.contains(where: { trackerRecord in
            return trackerRecord.trackerId == tracker.id && trackerRecord.date.isSameDayAs(activeDate)
        })
    }
    
    private func presentCreatingTrackerAsSheet() {
        let navigationController = UINavigationController(rootViewController: CreatingTrackerViewController())
        navigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = TrackersViewControllerTheme.sheetPresentationCornerRadius
        }
        
        present(navigationController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource methods
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
        
        var tracker = trackerCategories[indexPath.section].trackers[indexPath.row]
        
        cell.delegate = self
        cell.object = indexPath
        
        tracker.completedDaysCount = getCompletedDaysCount(for: tracker, from: completedTrackers)
        tracker.isCompleted = isTrackerCompleted(for: tracker, from: completedTrackers)
        
        cell.configure(backgroundColor: tracker.color, title: tracker.title, emoji: tracker.emoji, dayCount: tracker.completedDaysCount, isCompleted: tracker.isCompleted)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout methods
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: TrackersViewControllerTheme.collectionViewHeaderHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - TrackersViewControllerTheme.collectionViewPaddingWidth
        let cellWidth =  availableWidth / CGFloat(TrackersViewControllerTheme.collectionViewCellCount)
        
        return CGSize(width: cellWidth,
                      height: TrackersViewControllerTheme.collectionViewCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: TrackersViewControllerTheme.collectionViewTopInset,
            left: TrackersViewControllerTheme.collectionViewLeftInset,
            bottom: TrackersViewControllerTheme.collectionViewBottomInset,
            right: TrackersViewControllerTheme.collectionViewRightInset
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return TrackersViewControllerTheme.collectionViewCellSpacing
    }
}

// MARK: - TrackerCollectionViewCellDelegate methods
extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func trackerCell(_ cell: TrackerCollectionViewCell, onClickPlusButton object: Any?) {
        if let indexPath = object as? IndexPath {
            
            let tracker = trackerCategories[indexPath.section].trackers[indexPath.row]
            
            let isCompleted = isTrackerCompleted(for: tracker, from: completedTrackers)
            
            if (isCompleted) {
                completedTrackers.removeAll(where: { $0.trackerId == tracker.id && $0.date.isSameDayAs(activeDate) })
            } else {
                completedTrackers.append(TrackerRecord(trackerId: tracker.id, date: activeDate))
            }
             
            collectionView.reloadData()
        }
    }
}
