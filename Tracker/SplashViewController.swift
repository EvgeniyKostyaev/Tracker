//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 26.03.2025.
//

import UIKit

enum SplashViewControllerTheme {
    static let splashImageViewHeight: CGFloat = 94
    static let splashImageViewWidth: CGFloat = 91
}

final class SplashViewController: UIViewController {

    // MARK: - Private Properties
    private let splashImageView = {
        let splashImageView = UIImageView()
        
        splashImageView.image = UIImage(named: "launch_screen")
        
        return splashImageView
    }()
    
    // MARK: - Overrides Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        navigateToMainTabBarController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(resource: .blue)
        
        splashImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splashImageView)
        
        NSLayoutConstraint.activate([
            splashImageView.heightAnchor.constraint(equalToConstant: SplashViewControllerTheme.splashImageViewHeight),
            splashImageView.widthAnchor.constraint(equalToConstant: SplashViewControllerTheme.splashImageViewWidth),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Private Methods
//    private func navigateToMainTabBarController() {
//        guard let window = UIApplication.shared.windows.first else {
//            assertionFailure("Invalid window configuration")
//            return
//        }
//        
//        window.rootViewController = MainTabBarController()
//    }
}
