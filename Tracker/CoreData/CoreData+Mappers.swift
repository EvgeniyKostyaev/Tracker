//
//  CoreData+Mappers.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 15.09.2025.
//

import UIKit
import CoreData

// MARK: - Tracker ↔ TrackerEntity
extension Tracker {
    func toEntity(in context: NSManagedObjectContext,
                  category: TrackerCategoryEntity) -> TrackerEntity {
        let entity = TrackerEntity(context: context)
        entity.id = id
        entity.title = title
        entity.colorHex = color.hexString
        entity.emoji = emoji
        entity.type = type.rawValue
        entity.scheduleKind = schedule == nil ? 0 : 1
        entity.scheduleDaysMask = schedule?.daysWeeks?.toMask() ?? 0
        entity.scheduleDate = schedule?.date
        entity.category = category
        return entity
    }
}

extension TrackerEntity {
    func toModel() -> Tracker {
        return Tracker(
            id: id ?? UUID(),
            title: title ?? String(),
            color: UIColor.from(hex: colorHex ?? "#000000"),
            emoji: emoji ?? String(),
            type: TrackerType(rawValue: type ?? "habit") ?? .habit,
            schedule: scheduleKind == 0 ? nil :
                Schedule(
                    daysWeeks: DayWeeks.from(mask: scheduleDaysMask),
                    date: scheduleDate
                )
        )
    }
}

extension TrackerEntity {
    func update(from tracker: Tracker, category: TrackerCategoryEntity) {
        self.id = tracker.id
        self.title = tracker.title
        self.colorHex = tracker.color.hexString
        self.emoji = tracker.emoji
        self.type = tracker.type.rawValue
        self.scheduleKind = tracker.schedule == nil ? 0 : 1
        self.scheduleDaysMask = tracker.schedule?.daysWeeks?.toMask() ?? 0
        self.scheduleDate = tracker.schedule?.date
        self.category = category
    }
}

// MARK: - TrackerCategory ↔ TrackerCategoryEntity
extension TrackerCategory {
    func toEntity(in context: NSManagedObjectContext) -> TrackerCategoryEntity {
            let entity = TrackerCategoryEntity(context: context)
            entity.title = self.title
            
            let trackerEntities = self.trackers.map { tracker in
                tracker.toEntity(in: context, category: entity)
            }
            
            entity.trackers = NSSet(array: trackerEntities)
            
            return entity
        }
}

extension TrackerCategoryEntity {
    func toModel() -> TrackerCategory {
        return TrackerCategory(
            title: title ?? String(),
            trackers: (trackers?.allObjects as? [TrackerEntity])?.map { $0.toModel() } ?? []
        )
    }
}

// MARK: - TrackerRecord ↔ TrackerRecordEntity
extension TrackerRecord {
    func toEntity(in context: NSManagedObjectContext, trackerEntity: TrackerEntity) -> TrackerRecordEntity {
        let entity = TrackerRecordEntity(context: context)
        entity.date = date
        entity.tracker = trackerEntity
        return entity
    }
}

extension TrackerRecordEntity {
    func toModel() -> TrackerRecord? {
        guard let tracker = tracker,
              let date = date else { return nil }

        return TrackerRecord(
            trackerId: tracker.id ?? UUID(),
            date: date
        )
    }
}


