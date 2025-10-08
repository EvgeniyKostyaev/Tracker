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
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

// MARK: - Tracker
extension CoreDataManager {
    func addTracker(_ tracker: Tracker, to category: TrackerCategoryEntity) {
        _ = tracker.toEntity(in: context, category: category)
        saveContext()
    }
}

// MARK: - Tracker Category
extension CoreDataManager {
    func fetchCategories() -> [TrackerCategory] {
        let request: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        let result = (try? context.fetch(request)) ?? []
        return result.map { $0.toModel() }
    }
    
    func createCategory(_ category: TrackerCategory) {
        let entity = TrackerCategoryEntity(context: context)
        entity.title = category.title
        category.trackers.forEach { tracker in
            _ = tracker.toEntity(in: context, category: entity)
        }
        saveContext()
    }
}
