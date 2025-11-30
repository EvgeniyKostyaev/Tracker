//
//  OptionTableView.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.11.2025.
//

import UIKit

protocol OptionTableViewDelegate: AnyObject {
    func onSelectOption(option: String)
}

final class OptionTableView: UITableView {
    
    // MARK: Public Methods
    weak var optionTableViewDelegate: OptionTableViewDelegate?
    
    var optionsList: [String] = []
    var currentOption: String = String()
    
    // MARK: - Initializers
    init(style: UITableView.Style = .plain) {
        super.init(frame: .zero, style: style)
        
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        register(OptionTableViewCell.self, forCellReuseIdentifier: OptionTableViewCell.identifier)
        backgroundColor = .clear
        allowsSelection = true
        isScrollEnabled = true
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        dataSource = self
        delegate = self
    }
}

// MARK: - UITableViewDataSource
extension OptionTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionTableViewCell.identifier, for: indexPath) as? OptionTableViewCell else { return UITableViewCell()}
        
        let option = optionsList[indexPath.row]
        let isActive = option == currentOption
        let isFirstCell = indexPath.row == 0
        let isLastCell = indexPath.row == optionsList.count - 1
        cell.configure(with: option, isActive: isActive, isFirstCell: isFirstCell, isLastCell: isLastCell)
        
        cell.backgroundColor = .clear
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension OptionTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = optionsList[indexPath.row]
        
        optionTableViewDelegate?.onSelectOption(option: option)
    }
}
