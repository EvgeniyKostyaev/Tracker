//
//  CategoriesListViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 02.11.2025.
//

import UIKit

private enum Theme {
    static let containerViewCornerRadius: CGFloat = 16.0
    static let tableViewSeparatorInset: CGFloat = 16.0
    static let sheetPresentationCornerRadius: CGFloat = 16.0
    
    enum AddButton {
        static let addButtonCornerRadius: CGFloat = 16.0
        static let addButtonTopConstraint: CGFloat = 16.0
        static let addButtonLeadingConstraint: CGFloat = 20.0
        static let addButtonTrailingConstraint: CGFloat = -20.0
        static let addButtonHeightConstraint: CGFloat = 60.0
        static let addButtonBottomConstraint: CGFloat = -16.0
    }
    
    enum TableView {
        static let tableViewTopConstraint: CGFloat = 16.0
        static let tableViewLeadingConstraint: CGFloat = 16.0
        static let tableViewTrailingConstraint: CGFloat = -16.0
        static let tableViewBottomConstraint: CGFloat = -16.0
    }
    
    enum EmptyStateView {
        static let emptyStateViewLeadingConstraint: CGFloat = 32.0
        static let emptyStateViewTrailingConstraint: CGFloat = -32.0
    }
}

final class CategoriesListViewController: UIViewController {
    
    // MARK: - Private Properties
    private var viewModel: CategoriesListViewModel?
    
    private lazy var tableView: OptionTableView = {
        let tableView = OptionTableView(style: .plain)
        tableView.optionTableViewDelegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("categories_add_button_title".localized, for: .normal)
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
    
    private lazy var emptyStateView: EmptyStateView = {
        let emptyStateView = EmptyStateView(image: UIImage(resource: .noItems), text: "categories_empty_satate_title".localized)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        return emptyStateView
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationBar()
        setupLayout()
        bindViewModel()
    }
    
    // MARK: - Action methods
    @objc private func addTapped() {
        presentNewCategoryAsSheet()
    }
    
    // MARK: - Public Methods
    func initialize(viewModel: CategoriesListViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    // MARK: - Private Methods
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.showCategoriesList = { [weak self] data in
            let (categoriesList, currentCategory) = data
            
            self?.tableView.optionsList = categoriesList.map({ $0.title })
            self?.tableView.currentOption = currentCategory
            self?.tableView.reloadData()
            
            self?.tableView.isHidden = false
            self?.emptyStateView.isHidden = true
        }
        
        viewModel.showEmptyState = { [weak self] in
            self?.emptyStateView.isHidden = false
            self?.tableView.isHidden = true
        }
        
        viewModel.exitFromCurrentPage = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    private func setupView() {
        view.backgroundColor = .white
        title = "categories_title".localized
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.TableView.tableViewTopConstraint),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.TableView.tableViewLeadingConstraint),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.TableView.tableViewTrailingConstraint),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: Theme.TableView.tableViewBottomConstraint),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.EmptyStateView.emptyStateViewLeadingConstraint),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.EmptyStateView.emptyStateViewTrailingConstraint),
            
            addButton.topAnchor.constraint(greaterThanOrEqualTo: tableView.bottomAnchor, constant: Theme.AddButton.addButtonTopConstraint),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.AddButton.addButtonLeadingConstraint),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.AddButton.addButtonTrailingConstraint),
            addButton.heightAnchor.constraint(equalToConstant: Theme.AddButton.addButtonHeightConstraint),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Theme.AddButton.addButtonBottomConstraint)
        ])
    }
    
    private func bindViewModel() {
        viewModel?.viewIsReady()
    }
    
    private func presentNewCategoryAsSheet() {
        let newCategoryViewController = NewCategoryViewController()
        
        newCategoryViewController.onCreateCategory = { [weak self] newCategoryTitle in
            self?.viewModel?.onCreateCategory(newCategoryTitle: newCategoryTitle)
        }
        
        let navigationController = UINavigationController(rootViewController: newCategoryViewController)
        navigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = Theme.sheetPresentationCornerRadius
        }
        
        present(navigationController, animated: true)
    }
}

// MARK: - OptionTableViewDelegate Methods
extension CategoriesListViewController: OptionTableViewDelegate {
    func onSelectOption(option: String) {
        viewModel?.onSelectTrackerCategory(categoryTitle: option)
    }
}
