//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.05.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    private var trackers: [Any] = []
    
    private var categories: [TrackerCategory] = []
    
    private var completedTrackers: [TrackerRecord] = []
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        setupSearchController()
        setupAddBarButton()
        setupDatePicker()
        
        updateEmptyState()
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
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
        print("Кнопка '+' нажата")
    }
}
