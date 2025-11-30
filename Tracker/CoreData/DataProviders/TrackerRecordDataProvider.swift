//
//  TrackerRecordDataProvider.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 09.10.2025.
//

import Foundation
import CoreData

final class TrackerRecordDataProvider: NSObject {
    static let shared = TrackerRecordDataProvider()
    static let recordsDidChangeNotification = Notification.Name("TrackerRecordsDidChange")
    
    private let context = CoreDataManager.shared.context
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordEntity>?
    
    private override init() {
        super.init()
        
        let request: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController?.delegate = self
        
        try? fetchedResultsController?.performFetch()
    }
    
    var trackerRecords: [TrackerRecord] {
        guard let entities = fetchedResultsController?.fetchedObjects else { return [] }
        return entities.compactMap { $0.toModel() }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        NotificationCenter.default.post(
            name: TrackerRecordDataProvider.recordsDidChangeNotification,
            object: nil
        )
    }
}
