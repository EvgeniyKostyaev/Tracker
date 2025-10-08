//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 08.10.2025.
//

import Foundation
import CoreData

final class TrackerRecordStore {
    
    private let context = CoreDataManager.shared.context

    // MARK: - Create
    func addRecord(_ record: TrackerRecord) {
        guard let trackerEntity = fetchTracker(by: record.trackerId) else {
            print("❌ Не найден TrackerEntity с id \(record.trackerId)")
            return
        }

        _ = record.toEntity(in: context, trackerEntity: trackerEntity)
        saveContext()
    }

    // MARK: - Fetch
    func fetchAllRecords() -> [TrackerRecord] {
        let request: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()

        do {
            let entities = try context.fetch(request)
            return entities.compactMap { $0.toModel() }
        } catch {
            print("Ошибка получения TrackerRecords: \(error)")
            return []
        }
    }

    func fetchRecords(for trackerId: UUID) -> [TrackerRecord] {
        let request: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
        
        request.predicate = NSPredicate(format: "tracker.id != nil AND tracker.id == %@", trackerId as CVarArg)

        do {
            let entities = try context.fetch(request)
            return entities.compactMap { $0.toModel() }
        } catch {
            print("Ошибка получения записей трекера \(trackerId): \(error)")
            return []
        }
    }
    
    // MARK: - Delete
    func deleteRecord(for trackerId: UUID, date: Date) {
        let request: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "tracker.id == %@ AND date == %@",
            trackerId as CVarArg, date as CVarArg
        )
        if let record = try? context.fetch(request).first {
            context.delete(record)
            saveContext()
        }
    }

    // MARK: - Private Helpers
    private func fetchTracker(by id: UUID) -> TrackerEntity? {
        let request: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return (try? context.fetch(request))?.first
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                print("Ошибка сохранения контекста: \(error)")
            }
        }
    }
}
