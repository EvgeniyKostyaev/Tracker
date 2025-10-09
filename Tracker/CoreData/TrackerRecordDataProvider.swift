//
//  TrackerRecordDataProvider.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 09.10.2025.
//

import Foundation
import CoreData

protocol TrackerRecordDataProviderDelegate: AnyObject {
    func didUpdateRecords()
}

final class TrackerRecordDataProvider: NSObject {
    private let context = CoreDataManager.shared.context
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordEntity>?
    
    weak var delegate: TrackerRecordDataProviderDelegate?
    
    override init() {
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
        delegate?.didUpdateRecords()
    }
}
