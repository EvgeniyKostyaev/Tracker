//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.05.2025.
//

import UIKit

enum MainTabBarControllerTheme {
    static let trackersTabBarItemTitle: String = "Трекеры"
    static let statisticTabBarItemTitle: String = "Статистика"
}

final class MainTabBarController: UITabBarController {
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupTopSeparator()
    }
    
    // MARK: - Private Methods
    private func setupViewControllers() {
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(
            title: MainTabBarControllerTheme.trackersTabBarItemTitle,
            image: UIImage(resource: .tabTrackers),
            selectedImage: nil
        )
        
        let trackersNavigationController = UINavigationController.init(rootViewController: trackersViewController)
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: MainTabBarControllerTheme.statisticTabBarItemTitle,
            image: UIImage(resource: .tabStatistic),
            selectedImage: nil
        )
        
        self.viewControllers = [trackersNavigationController, statisticViewController]
    }
    
    private func setupTopSeparator() {
        let topSeparator = UIView()
        topSeparator.backgroundColor = .separator
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(topSeparator)
        
        NSLayoutConstraint.activate([
            topSeparator.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            topSeparator.topAnchor.constraint(equalTo: tabBar.topAnchor),
            topSeparator.heightAnchor.constraint(equalToConstant: 1.0)
        ])
    }
}
