//
//  CoreDataManager.swift
//  FunWithCoreData
//
//  Created by Miklos Kekkoi on 11/7/17.
//  Copyright © 2017 Miklos Kekkoi. All rights reserved.
//

import CoreData


struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FunWithCoreData")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("failed to load perStore")
            }
        }
        return container
        
    }()
    
    func fetchNotes() -> [UserNote] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<UserNote>(entityName: "UserNote")
        do {
            let notes = try context.fetch(fetchRequest)
            
            return notes
            
        } catch let fetchErr {
            print(fetchErr)
            return []
        }
    }
 
}
