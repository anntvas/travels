//
//  DataController.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//

import Foundation
import CoreData

class DataController {
    static let shared = DataController()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Travels")

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Failed to load Core Data stack: \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    func load() {
        // Просто обращаемся к persistentContainer, чтобы инициализировать
        _ = persistentContainer
    }
}
