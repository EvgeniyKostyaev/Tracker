//
//  FilterTrackersUseCase.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 13.08.2025.
//

import Foundation

class FilterTrackersUseCase {
    
    // MARK: - Public methods
    func filterTrackerCategoriesList(_ trackerCategories: [TrackerCategory], date: Date) -> [TrackerCategory] {
        var trackerCategoriesList: [TrackerCategory] = []
        
        trackerCategories.forEach { trackerCategory in
            var newTrackerCategory = trackerCategory
            newTrackerCategory.trackers = filterTrackersList(trackerCategory.trackers, date: date)
            if (!newTrackerCategory.trackers.isEmpty) {
                trackerCategoriesList.append(newTrackerCategory)
            }
        }
        
        return trackerCategoriesList
    }
    
    // MARK: - Private methods
    private func filterTrackersList(_ trackers: [Tracker], date: Date) -> [Tracker] {
        return trackers.filter { tracker in
            let dayWeeks = tracker.schedule?.daysWeeks.first(where: { (dayWeeks) in
                return dayWeeks?.rawValue == date.dayOfWeek
            })
            
            return dayWeeks != nil
        }
    }
}
