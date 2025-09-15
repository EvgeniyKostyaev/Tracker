//
//  DataManager.swift.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 08.09.2025.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle.main.url(forResource: "TrackerModel", withExtension: "momd") else {
            fatalError("Не удалось найти .momd файл")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Не удалось загрузить файл модели")
        }
        
        let container = NSPersistentContainer(name: "TrackerModel", managedObjectModel: managedObjectModel)
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Не удалось загрузить хранилище: \(error)")
            }
        }
        return container
    }()
    
    var сontext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if сontext.hasChanges {
            do {
                try сontext.save()
            } catch {
                сontext.rollback()
            }
        }
    }
}

// MARK: - Tracker Category
extension CoreDataManager {
    func addCategory(title: String) -> TrackerCategoryEntity {
        let entity = TrackerCategoryEntity(context: сontext)
        entity.title = title
        saveContext()
        return entity
    }

    func fetchCategories() -> [TrackerCategoryEntity] {
        let request: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return (try? сontext.fetch(request)) ?? []
    }

    func deleteCategory(_ category: TrackerCategoryEntity) {
        сontext.delete(category)
        saveContext()
    }
}

// MARK: - Tracker
extension CoreDataManager {
    func addTracker(
        title: String,
        colorHex: String,
        emoji: String,
        type: String,
        scheduleKind: Int16,
        scheduleDaysMask: Int16,
        scheduleDate: Date?,
        category: TrackerCategoryEntity
    ) -> TrackerEntity {
        let tracker = TrackerEntity(context: сontext)
        tracker.title = title
        tracker.colorHex = colorHex
        tracker.emoji = emoji
        tracker.type = type
        tracker.scheduleKind = scheduleKind
        tracker.scheduleDaysMask = scheduleDaysMask
        tracker.scheduleDate = scheduleDate
        tracker.category = category

        saveContext()
        return tracker
    }

    func fetchTrackers(for date: Date? = nil) -> [TrackerEntity] {
        let request: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        return (try? сontext.fetch(request)) ?? []
    }

    func deleteTracker(_ tracker: TrackerEntity) {
        сontext.delete(tracker)
        saveContext()
    }
}

// MARK: - Tracker Record
extension CoreDataManager {
    func addRecord(tracker: TrackerEntity, date: Date) -> TrackerRecordEntity {
        let record = TrackerRecordEntity(context: сontext)
        record.date = date
        record.tracker = tracker
        saveContext()
        return record
    }

    func fetchRecords(for tracker: TrackerEntity) -> [TrackerRecordEntity] {
        let request: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
        request.predicate = NSPredicate(format: "tracker == %@", tracker)
        return (try? сontext.fetch(request)) ?? []
    }

    func deleteRecord(_ record: TrackerRecordEntity) {
        сontext.delete(record)
        saveContext()
    }
}


