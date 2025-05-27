//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.05.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersViewController = TrackersViewController()
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(resource: .tabTrackers),
            selectedImage: nil
        )
        
        let statisticViewController = StatisticViewController()
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .tabStatistic),
            selectedImage: nil
        )
        
        self.viewControllers = [trackersViewController, statisticViewController]
    }
}
