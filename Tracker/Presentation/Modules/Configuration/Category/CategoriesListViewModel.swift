//
//  CategoriesListViewModel.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 05.11.2025.
//

import Foundation

typealias Binding<T> = (T) -> Void
typealias BindingVoid = () -> Void

typealias CategoriesTuple = (categories: [TrackerCategory], selectedCategory: String)

final class CategoriesListViewModel {
    
    // MARK: - Public Properties
    var onSelectTrackerCategory: ((String) -> Void)?
    
    var currentCategory: String = String()
    
    var showCategoriesList:  Binding<CategoriesTuple>?
    var showEmptyState: BindingVoid?
    
    var exitFromCurrentPage: BindingVoid?
    
    // MARK: - Private Properties
    private let categoryStore = TrackerCategoryStore()
    
    private var categoriesList: [TrackerCategory] = []
    
    // MARK: - Public methods
    func viewIsReady() {
        loadCategoriesList()
    }
    
    func onCreateCategory(newCategoryTitle: String) {
        categoryStore.addCategory(TrackerCategory(title: newCategoryTitle, trackers: []))
        
        loadCategoriesList()
    }
    
    func onSelectTrackerCategory(categoryTitle: String) {
        onSelectTrackerCategory?(categoryTitle)
        
        exitFromCurrentPage?()
    }
    
    // MARK: - Private methods
    private func loadCategoriesList() {
        categoriesList = categoryStore.fetchAllCategories()
        
        if categoriesList.count > 0 {
            showCategoriesList?((categoriesList, currentCategory))
        } else {
            showEmptyState?()
        }
    }
}

