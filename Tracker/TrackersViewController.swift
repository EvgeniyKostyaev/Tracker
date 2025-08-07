//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.05.2025.
//

import UIKit

enum TrackersViewControllerTheme {
    static let trackerSupplementaryHeaderViewHeight: CGFloat = 44.0
    static let trackerCollectionViewCellHeight: CGFloat = 148.0
}

final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    private var trackers: [Tracker] = []
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date = Date()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackerCategory = TrackerCategory(title: "Домашний уют", trackers: [])
        categories.append(trackerCategory)
        
        setupTitle()
        setupSearchController()
        setupAddBarButton()
        setupDatePicker()
        
        setupCollectionView()
        
//        updateEmptyState()
    }
    
    // MARK: - Private Methods
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
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func updateEmptyState() {
        if trackers.isEmpty {
            let emptyView = EmptyStateView(
                image: UIImage(resource: .noTrackers),
                text: "Что будем отслеживать?"
            )
            
            view.addSubview(emptyView)
            
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        } else {
            
        }
    }
    
    @objc private func addButtonTapped() {
        let newTracker = Tracker(
            id: 1,
            title: "Test",
            colorHex: "Test",
            emoji: "Test",
            type: .habit,
            schedule: nil
        )
        
        let newRowIndex = categories[0].trackers.count
        
        categories[0].trackers.append(newTracker)
        
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: [IndexPath.init(row: newRowIndex, section: 0)])
        }
        
        //        var lastIndex: Int = 0
        //        if (trackers.count > 1) {
        //            lastIndex = trackers.count - 1
        //        }
        //
        //        collectionView.performBatchUpdates {
        //            collectionView.insertItems(at: [IndexPath.init(row: lastIndex, section: 0)])
        //        }
        
        //        let trackerCategory = TrackerCategory(title: "Section test", trackers: [newTracker])
        //
        //        let newSectionIndex = categories.count
        //
        //        categories.append(trackerCategory)
        //
        //        collectionView.performBatchUpdates {
        //            collectionView.insertSections(IndexSet(integer: newSectionIndex))
        //        }
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        self.currentDate = sender.date
        
        // update tracers list
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
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

        header.titleLabel.text = categories[indexPath.section].title

        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell
        
        guard let cell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: TrackersViewControllerTheme.trackerSupplementaryHeaderViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: TrackersViewControllerTheme.trackerCollectionViewCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
