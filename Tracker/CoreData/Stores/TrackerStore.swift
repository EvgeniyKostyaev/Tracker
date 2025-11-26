//
//  TrackerStore.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 08.10.2025.
//

import Foundation
import CoreData

final class TrackerStore {
    
    private let context = CoreDataManager.shared.context
    
    // MARK: - Create
    func addTracker(_ tracker: Tracker, to category: TrackerCategoryEntity) {
        _ = tracker.toEntity(in: context, category: category)
        saveContext()
    }
    
    // MARK: - Fetch
    func fetchAllTrackers() -> [Tracker] {
        let request: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            return entities.compactMap { $0.toModel() }
        } catch {
            print("Ошибка получения трекеров: \(error)")
            return []
        }
    }
    
    func fetchTracker(by id: UUID) -> Tracker? {
        let request: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first?.toModel()
        } catch {
            print("Ошибка получения трекера \(id): \(error)")
            return nil
        }
    }
    
    // MARK: - Update
    func editTracker(_ tracker: Tracker, in category: TrackerCategoryEntity) {
        let request: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        request.fetchLimit = 1
        
        do {
            if let entity = try context.fetch(request).first {
                entity.update(from: tracker, category: category)
                saveContext()
            } else {
                print("Трекер с id \(tracker.id) не найден")
            }
        } catch {
            print("Ошибка обновления трекера \(tracker.id): \(error)")
        }
    }
    
    // MARK: - Delete
    func deleteTracker(by id: UUID) {
        let request: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            if let tracker = try context.fetch(request).first {
                context.delete(tracker)
                saveContext()
            }
        } catch {
            print("Ошибка удаления трекера \(id): \(error)")
        }
    }
    
    // MARK: - Private Helpers
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                print("Ошибка сохранения контекста (TrackerStore): \(error)")
            }
        }
    }
}
