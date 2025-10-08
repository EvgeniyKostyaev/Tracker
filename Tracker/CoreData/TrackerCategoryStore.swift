//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 08.10.2025.
//

import Foundation
import CoreData

final class TrackerCategoryStore {
    
    private let context = CoreDataManager.shared.context
    private let trackerStore = TrackerStore()
    
    // MARK: - Create
    func addCategory(_ category: TrackerCategory) {
        let categoryEntity = category.toEntity(in: context)
        
        for tracker in category.trackers {
            trackerStore.addTracker(tracker, to: categoryEntity)
        }
        
        saveContext()
    }
    
    // MARK: - Fetch
    func fetchAllCategories() -> [TrackerCategory] {
        let request: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            return entities.compactMap { $0.toModel() }
        } catch {
            print("Ошибка получения категорий: \(error)")
            return []
        }
    }
    
    func fetchCategory(by title: String) -> TrackerCategory? {
        let request: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first?.toModel()
        } catch {
            print("Ошибка получения категории с названием \(title): \(error)")
            return nil
        }
    }
    
    // MARK: - Delete
    func deleteCategory(by title: String) {
        let request: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1
        
        do {
            if let category = try context.fetch(request).first {
                context.delete(category)
                saveContext()
            }
        } catch {
            print("Ошибка удаления категории \(title): \(error)")
        }
    }
    
    // MARK: - Private Helpers
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                print("Ошибка сохранения контекста (TrackerCategoryStore): \(error)")
            }
        }
    }
}
