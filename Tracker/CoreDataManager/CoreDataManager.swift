//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Evgeniy Kostyaev on 08.09.2025.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
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
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Ошибка сохранения: \(error)")
            }
        }
    }
}
