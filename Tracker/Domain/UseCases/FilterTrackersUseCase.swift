//
//  FilterTrackersUseCase.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 13.08.2025.
//

import Foundation

final class FilterTrackersUseCase {
    
    // MARK: - Private Properties
    private let trackerRecordDataProvider = TrackerRecordDataProvider.shared
    
    // MARK: - Public methods
    func filterTrackerCategoriesList(_ trackerCategories: [TrackerCategory], date: Date, searchKeyword: String, filter: Filter) -> [TrackerCategory] {
        var trackerCategoriesList: [TrackerCategory] = []
        
        trackerCategories.forEach { trackerCategory in
            let filteredTrackersByFilter = filterTrackersListByFilter(trackerCategory.trackers, date: date, filter: filter)
            let filteredTrackersByKeyword = filterTrackersListBySearchKeyword(filteredTrackersByFilter, searchKeyword: searchKeyword)
            
            let filteredTrackers = filterTrackersListByDate(filteredTrackersByKeyword, date: date)
            if (!filteredTrackers.isEmpty) {
                trackerCategoriesList.append(TrackerCategory(title: trackerCategory.title, trackers: filteredTrackers))
            }
        }
        
        return trackerCategoriesList
    }
    
    // MARK: - Private methods
    private func filterTrackersListByFilter(_ trackers: [Tracker], date: Date, filter: Filter) -> [Tracker] {
        switch filter {
        case .all, .allToday: return trackers
        case .completed: return filterTrackersListByFilterCompleted(trackers, date: date)
        case .uncompleted: return filterTrackersListByFilterUncompleted(trackers, date: date)
        }
    }
    
    private func filterTrackersListByFilterCompleted(_ trackers: [Tracker], date: Date) -> [Tracker] {
        return trackers.filter { tracker in
            return tracker.isCompleted(on: date, from: trackerRecordDataProvider.trackerRecords)
        }
    }
    
    private func filterTrackersListByFilterUncompleted(_ trackers: [Tracker], date: Date) -> [Tracker] {
        return trackers.filter { tracker in
            return !tracker.isCompleted(on: date, from: trackerRecordDataProvider.trackerRecords)
        }
    }
    
    private func filterTrackersListBySearchKeyword(_ trackers: [Tracker], searchKeyword: String) -> [Tracker] {
        if searchKeyword.isEmpty {
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
                    return dayWeeks.rawValue == date.dayOfWeek
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
