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
        container.loadPersistentStores { (storeDesc, error) in
            if let error = error {
                fatalError("failed to load perStore")
            }
        }
        return container
        
    }()
 
 
    
}
