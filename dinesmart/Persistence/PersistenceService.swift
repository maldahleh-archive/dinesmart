//
//  PersistenceService.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-08-06.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "dinesmart")
        container.loadPersistentStores { description, error in
            if let error = error {
            }
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
