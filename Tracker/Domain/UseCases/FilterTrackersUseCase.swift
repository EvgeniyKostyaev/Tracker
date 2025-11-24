//
//  FilterTrackersUseCase.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 13.08.2025.
//

import Foundation

class FilterTrackersUseCase {
    
    // MARK: - Public methods
    func filterTrackerCategoriesList(_ trackerCategories: [TrackerCategory], date: Date, searchKeyword: String) -> [TrackerCategory] {
        var trackerCategoriesList: [TrackerCategory] = []
        
        trackerCategories.forEach { trackerCategory in
            let filteredTrackersByKeyword = filterTrackersListBySearchKeyword(trackerCategory.trackers, searchKeyword: searchKeyword)
            
            let filteredTrackers = filterTrackersListByDate(filteredTrackersByKeyword, date: date)
            if (!filteredTrackers.isEmpty) {
                trackerCategoriesList.append(TrackerCategory(title: trackerCategory.title, trackers: filteredTrackers))
            }
        }
        
        return trackerCategoriesList
    }
    
    // MARK: - Private methods
    private func filterTrackersListBySearchKeyword(_ trackers: [Tracker], searchKeyword: String) -> [Tracker] {
        if (searchKeyword.isEmpty) {
            return trackers
        }
        
        return trackers.filter { tracker in
            return tracker.title.lowercased().contains(searchKeyword.lowercased())
        }
    }
    
    private func filterTrackersListByDate(_ trackers: [Tracker], date: Date) -> [Tracker] {
        return trackers.filter { tracker in
            
            switch (tracker.type) {
            case .habit:
                let dayWeeks = tracker.schedule?.daysWeeks?.first(where: { (dayWeeks) in
                    return dayWeeks?.rawValue == date.dayOfWeek
                })
                
                return dayWeeks != nil
            case .irregular:
                if let dayWeeks = tracker.schedule?.date {
                    return dayWeeks.isSameDayAs(date)
                }
                
                return false
            }
        }
    }
}
