//
//  MemoryCard.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 1/6/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import CoreData

class MemoryCard {
    
    static let sharedInstance = MemoryCard()
    
    private var autoSave: Bool = false
    private var managedObjectContext: NSManagedObjectContext!
    
    var playerData: PlayerData!
    
    init() {
        self.managedObjectContext = self.persistentContainer.viewContext
        self.loadGame()
    }
    
    func newGame() {
        self.playerData = self.newPlayerData()
        self.autoSave = true
        self.saveGame()
    }
    
    func saveGame() {
        if self.autoSave {
            self.autoSave = false
            self.saveContext()
            self.autoSave = true
        }
    }
    
    func loadGame() {
        guard self.playerData == nil else { return }
        
        let fetchRequestData = self.fetchRequest() as [PlayerData]
        
        if fetchRequestData.count > 0 {
            self.playerData = fetchRequestData.last
            self.updateModelVersion()
            self.autoSave = true
        } else {
            self.newGame()
        }
    }
    
    func reset() {
        
        for item in self.fetchRequest() as [MothershipData] {
            self.managedObjectContext.delete(item)
        }
        
        for item in self.fetchRequest() as [PlayerData] {
            self.managedObjectContext.delete(item)
        }
        
        for item in self.fetchRequest() as [SpaceshipData] {
            self.managedObjectContext.delete(item)
        }
        
        for item in self.fetchRequest() as [MothershipSlotData] {
            self.managedObjectContext.delete(item)
        }
        
        self.playerData = nil
        
        self.autoSave = false
        self.newGame()
    }
    
    func fetchRequest<T: NSFetchRequestResult>() -> [T] {
        let entityName = "\(T.self)".components(separatedBy: ".").last!
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: entityName)
        return (try? self.managedObjectContext.fetch(fetchRequest)) ?? []
    }
    
    func insertNewObject<T>() -> T {
        let entityName = "\(T.self)".components(separatedBy: ".").last!
        print("New \(entityName)")
        // swiftlint:disable:next force_cast
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.managedObjectContext) as! T
        return managedObject
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
