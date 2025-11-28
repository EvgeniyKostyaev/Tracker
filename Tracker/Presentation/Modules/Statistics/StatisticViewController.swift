//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.05.2025.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
    }
    
    // MARK: - Private Methods
    private func setupTitle() {
        title = "common_statistic".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}
