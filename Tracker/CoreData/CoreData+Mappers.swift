//
//  CoreData+Mappers.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 15.09.2025.
//

import UIKit
import CoreData

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
