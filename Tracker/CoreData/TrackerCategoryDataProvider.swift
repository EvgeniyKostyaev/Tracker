//
//  TrackerCategoryDataProvider.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 09.10.2025.
//

import Foundation
import CoreData

protocol TrackerCategoryDataProviderDelegate: AnyObject {
    func didUpdateCategories()
}

final class TrackerCategoryDataProvider: NSObject {
    private let context = CoreDataManager.shared.context
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryEntity>!
    
    weak var delegate: TrackerCategoryDataProviderDelegate?
    
    override init() {
        super.init()
        
        let request: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "title",
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
    }
    
    var trackerCategories: [TrackerCategory] {
        guard let entities = fetchedResultsController.fetchedObjects else { return [] }
        return entities.compactMap { $0.toModel() }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateCategories()
    }
}
