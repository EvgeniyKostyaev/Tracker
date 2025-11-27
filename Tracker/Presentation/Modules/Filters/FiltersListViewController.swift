//
//  FiltersListViewController.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.11.2025.
//

import UIKit

private enum Theme {
    static let containerViewCornerRadius: CGFloat = 16.0
    static let tableViewSeparatorInset: CGFloat = 16.0
    static let sheetPresentationCornerRadius: CGFloat = 16.0
    
    enum TableView {
        static let tableViewTopConstraint: CGFloat = 16.0
        static let tableViewLeadingConstraint: CGFloat = 16.0
        static let tableViewTrailingConstraint: CGFloat = -16.0
        static let tableViewBottomConstraint: CGFloat = -16.0
    }
}

final class FiltersListViewController: UIViewController {
    
    // MARK: - Private Properties
    private var viewModel: FiltersListViewModel?
    
    private lazy var tableView: OptionTableView = {
        let tableView = OptionTableView(style: .plain)
        tableView.optionTableViewDelegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let navigationBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .trackerWhite
        appearance.shadowColor = .clear
        return appearance
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationBar()
        setupLayout()
        bindViewModel()
    }
    
    // MARK: - Public Methods
    func initialize(viewModel: FiltersListViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    // MARK: - Private Methods
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.showFiltersList = { [weak self] data in
            let (filtersList, currentFilter) = data
            
            self?.tableView.optionsList = filtersList.map({ $0.localized })
            
            if (currentFilter == .completed || currentFilter == .uncompleted) {
                self?.tableView.currentOption = currentFilter.localized
            }
            
            self?.tableView.reloadData()
        }
        
        viewModel.exitFromCurrentPage = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    private func setupView() {
        view.backgroundColor = .trackerWhite
        title = "filters_title".localized
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.TableView.tableViewTopConstraint),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.TableView.tableViewLeadingConstraint),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Theme.TableView.tableViewTrailingConstraint),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Theme.TableView.tableViewBottomConstraint)
        ])
    }
    
    private func bindViewModel() {
        viewModel?.viewIsReady()
    }
}

// MARK: - OptionTableViewDelegate Methods
extension FiltersListViewController: OptionTableViewDelegate {
    func onSelectOption(option: String) {
        viewModel?.onSelectFilterTitle(filterTitle: option)
    }
}
