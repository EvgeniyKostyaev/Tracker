//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 26.03.2025.
//

import UIKit

private enum Theme {
    static let splashImageViewHeight: CGFloat = 94
    static let splashImageViewWidth: CGFloat = 91
}


final class SplashViewController: UIViewController {
    
    // MARK: - Private Properties
    private let appSettings: AppSettingsProtocol?
    
    private let splashImageView: UIImageView = {
        let splashImageView = UIImageView()
        
        splashImageView.image = UIImage.init(resource: .launchScreen)
        splashImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return splashImageView
    }()
    
    // MARK: - Initializers
    init() {
        appSettings = AppSettings()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigateToMainTabBarController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(resource: .trackerBlue)
        
        setupLayout()
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        view.addSubview(splashImageView)
        
        NSLayoutConstraint.activate([
            splashImageView.heightAnchor.constraint(equalToConstant: Theme.splashImageViewHeight),
            splashImageView.widthAnchor.constraint(equalToConstant: Theme.splashImageViewWidth),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func navigateToMainTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        if let isFirstLaunch = appSettings?.isFirstLaunch, isFirstLaunch {
            window.rootViewController = OnboardingPageViewController()
        } else {
            window.rootViewController = MainTabBarController()
        }
    }
}
