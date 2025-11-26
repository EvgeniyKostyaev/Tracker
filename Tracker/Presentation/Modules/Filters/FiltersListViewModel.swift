//
//  FiltersListViewModel.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 27.11.2025.
//

import Foundation

typealias FiltersTuple = (filters: [Filter], currentFilter: Filter)

enum Filter: String {
    case all = "filters_all"
    case allToday = "filters_all_today"
    case completed = "filters_complited"
    case uncompleted = "filters_uncompleted"
    
    var localized: String {
        return rawValue.localized
    }
}

final class FiltersListViewModel {
    
    // MARK: - Public Properties
    var onSelectFilter: ((Filter) -> Void)?
    var currentFilter: Filter = .all
    var showFiltersList:  Binding<FiltersTuple>?
    var exitFromCurrentPage: BindingVoid?
    
    // MARK: - Public methods
    func viewIsReady() {
        let filtersList: [Filter] = [.all, .allToday, .completed, .uncompleted]
        
        showFiltersList?((filtersList, currentFilter))
    }
    
    func onSelectFilterTitle(filterTitle: String) {
        guard let filter = Filter(rawValue: filterTitle) else { return }
        
        onSelectFilter?(filter)
        
        exitFromCurrentPage?()
    }
}

