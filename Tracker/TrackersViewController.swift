//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.05.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        setupSearchController()
        setupAddBarButton()
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
    
    @objc private func addButtonTapped() {
        print("Кнопка '+' нажата")
    }
}
