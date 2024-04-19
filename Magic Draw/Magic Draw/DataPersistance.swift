//
//  DataPersistance.swift
//  Magic Draw
//
//  Created by Lincoln Price on 4/8/24.
//

import Foundation
import CoreData

struct PersistanceController {
    static let shared = PersistanceController()
    static var preview:PersistanceController = {
        let result = PersistanceController(memory: true)
        let viewContext = result.container.viewContext
        
        
        do {
            try viewContext.save()
        } catch {
            //finish
            let nsError = error as NSError
            fatalError("unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
     
    }()
     
    
    let container: NSPersistentContainer
    
    init(memory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if memory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                //finish
                fatalError("unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
