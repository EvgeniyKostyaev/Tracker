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
        Tracker(
            id: Int(self.objectID.hash),
            title: self.title ?? String(),
            color: UIColor.from(hex: self.colorHex ?? "#000000"),
            emoji: self.emoji ?? String(),
            type: TrackerType(rawValue: self.type ?? "habit") ?? .habit,
            schedule: scheduleKind == 0 ? nil :
                Schedule(
                    daysWeeks: DayWeeks.from(mask: scheduleDaysMask),
                    date: scheduleDate
                )
        )
    }
}

// MARK: - TrackerCategory ↔ TrackerCategoryEntity
extension TrackerCategory {
    func toEntity(in context: NSManagedObjectContext) -> TrackerCategoryEntity {
        let entity = TrackerCategoryEntity(context: context)
        entity.title = title
        entity.trackers = NSSet(array: trackers.map { $0.toEntity(in: context, category: ) })
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
            trackerId: Int(bitPattern: tracker.id),
            date: date
        )
    }
}


