//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 01.11.2025.
//

import Foundation
import UIKit

class OnboardingPageViewController: UIPageViewController {
    
    // MARK: - Private Properties
    private enum Theme {
        static let buttonTitle: String = "Вот это технологии!"
        static let pageControlBottomConstraint: CGFloat = -24.0
        
        enum ActionButton {
            static let actionButtonFontSise: CGFloat =  16.0
            static let actionButtonCornerRadius: CGFloat =  16.0
            static let actionButtonHeightConstraint: CGFloat = 60.0
            static let actionButtonLeadingConstraint: CGFloat = 20.0
            static let actionButtonTrailingConstraint: CGFloat = -20.0
            static let actionButtonBottomConstraint: CGFloat = -50.0
        }
    }
    
    private lazy var pages: [UIViewController] = {
        let red = UIViewController()
        red.view.backgroundColor = .red
        
        let green = UIViewController()
        green.view.backgroundColor = .green
        
        return [red, green]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var okButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Theme.buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: Theme.ActionButton.actionButtonFontSise, weight: .medium)
        button.layer.cornerRadius = Theme.ActionButton.actionButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(okButtonTaped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        setupLayout()
    }
    
    // MARK: - Actions
    @objc private func okButtonTaped() {
        
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        view.addSubview(okButton)
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            okButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.ActionButton.actionButtonLeadingConstraint),
            okButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.ActionButton.actionButtonTrailingConstraint),
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Theme.ActionButton.actionButtonBottomConstraint),
            okButton.heightAnchor.constraint(equalToConstant: Theme.ActionButton.actionButtonHeightConstraint),
            
            pageControl.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: Theme.pageControlBottomConstraint),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - UIPageViewControllerDataSource Methods
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
}
    
// MARK: - UIPageViewControllerDelegate Methods
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
