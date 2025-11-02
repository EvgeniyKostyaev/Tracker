//
//  CategoriesListViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 02.11.2025.
//

import UIKit

private enum Theme {
    static let title: String = "Категория"
    static let addButtonTitle: String = "Добавить категорию"
    
    static let containerViewCornerRadius: CGFloat = 16.0
    static let tableViewSeparatorInset: CGFloat = 16.0
    
    static let alphaComponent: CGFloat = 0.3
    
    enum AddButton {
        static let addButtonCornerRadius: CGFloat = 16.0
        static let addButtonTopConstraint: CGFloat = 16.0
        static let addButtonLeadingConstraint: CGFloat = 20.0
        static let addButtonTrailingConstraint: CGFloat = -20.0
        static let addButtonHeightConstraint: CGFloat = 60.0
        static let addButtonBottomConstraint: CGFloat = -16.0
    }
    
    enum ContainerView {
        static let containerViewTopConstraint: CGFloat = 16.0
        static let containerViewLeadingConstraint: CGFloat = 16.0
        static let containerViewTrailingConstraint: CGFloat = -16.0
        static let containerViewHeightConstraint: CGFloat = 525.0
    }
}

final class CategoriesListViewController: UIViewController {
    
    // MARK: - Public Properties
    var onSelect: ((String) -> Void)?
    
    var trackerCategory: String = String()
    
    // MARK: - Private Properties
    private let categoriesList: [String] = ["Важное"]
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .trackerLightGray.withAlphaComponent(Theme.alphaComponent)
        view.layer.cornerRadius = Theme.containerViewCornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            CategoryTableViewCell.self,
            forCellReuseIdentifier: CategoryTableViewCell.identifier
        )
        tableView.backgroundColor = .clear
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Theme.addButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = Theme.AddButton.addButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return button
    }()
    
    private let navigationBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        return appearance
    }()
    
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = Theme.title
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupLayout()
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        view.addSubview(containerView)
        containerView.addSubview(tableView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.ContainerView.containerViewTopConstraint),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.ContainerView.containerViewLeadingConstraint),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.ContainerView.containerViewTrailingConstraint),
            containerView.heightAnchor.constraint(equalToConstant: Theme.ContainerView.containerViewHeightConstraint),
            
            tableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            addButton.topAnchor.constraint(greaterThanOrEqualTo: containerView.bottomAnchor, constant: Theme.AddButton.addButtonTopConstraint),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.AddButton.addButtonLeadingConstraint),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.AddButton.addButtonTrailingConstraint),
            addButton.heightAnchor.constraint(equalToConstant: Theme.AddButton.addButtonHeightConstraint),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Theme.AddButton.addButtonBottomConstraint)
        ])
    }
    
    @objc private func addTapped() {
        
    }
}

// MARK: - UITableViewDataSource
extension CategoriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else { return UITableViewCell()}
        
        let category = categoriesList[indexPath.row]
        let isActive = category == trackerCategory
        cell.configure(with: category, isActive: isActive)
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: Theme.tableViewSeparatorInset,
                bottom: 0,
                right: Theme.tableViewSeparatorInset
            )
        }
        
        cell.backgroundColor = .clear
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CategoriesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let category = categoriesList[indexPath.row]
        onSelect?(category)
        dismiss(animated: true)
    }
}
