//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.05.2025.
//

import UIKit

private enum Theme {
    enum EmptyStateView {
        static let emptyStateViewLeadingConstraint: CGFloat = 16.0
        static let emptyStateViewTrailingConstraint: CGFloat = -16.0
    }
}

final class StatisticViewController: UIViewController {
    
    // MARK: - Private Properties
    private lazy var emptyStateView: EmptyStateView = {
        let emptyStateView = EmptyStateView(image: UIImage(resource: .nothingAnalize), text: "statystic_empty_satate_title".localized)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        return emptyStateView
    }()
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        setupLayout()
    }
    
    // MARK: - Private Methods
    private func setupTitle() {
        title = "common_statistic".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupLayout() {
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.EmptyStateView.emptyStateViewLeadingConstraint),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.EmptyStateView.emptyStateViewTrailingConstraint)
        ])
    }
}
