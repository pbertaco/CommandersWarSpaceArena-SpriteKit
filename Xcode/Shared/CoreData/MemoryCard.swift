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
    
    var playerData: PlayerData!
    
    init() {
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
        
        if(fetchRequestData.count > 0) {
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
        return try! self.managedObjectContext.fetch(fetchRequest)
    }
    
    func insertNewObject<T>() -> T {
        let entityName = "\(T.self)".components(separatedBy: ".").last!
        print("New \(entityName)")
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.managedObjectContext) as! T
        return managedObject
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        
        let url = urls.last!.appendingPathComponent(Bundle.main.bundleIdentifier!)
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: url.path) {
            try! fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return url
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let url = Bundle.main.url(forResource: "Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: url)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let fileManager = FileManager.default
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let productName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        
        #if DEBUG
            let fileName = "\(productName)Debug.sqlite"
        #else
            let fileName = "\(productName).sqlite"
        #endif
        
        let url: URL = {
            if let url = fileManager.url(forUbiquityContainerIdentifier: "iCloud\(Bundle.main.bundleIdentifier!)") {
                return url.appendingPathComponent(fileName)
            } else {
                return self.applicationDocumentsDirectory.appendingPathComponent(fileName)
            }
        }()
        
        do {
            
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch let error as NSError {
            #if DEBUG
                try! fileManager.removeItem(at: url)
                exit(1)
            #endif
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if self.managedObjectContext.hasChanges {
            try! managedObjectContext.save()
        }
    }
}
