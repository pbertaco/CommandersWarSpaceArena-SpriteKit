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
            self.playerData.date = Date()
            let fetchRequestData = self.fetchRequest() as [PlayerData]
            
            if fetchRequestData.count > 1 {
                self.playerData = self.merge(fetchRequestData: fetchRequestData)
            }
            
            self.saveContext()
            self.autoSave = true
        }
    }
    
    func loadGame() {
        let fetchRequestData = self.fetchRequest() as [PlayerData]
        
        if fetchRequestData.count > 0 {
            if fetchRequestData.count > 1 {
                self.playerData = self.merge(fetchRequestData: fetchRequestData)
            } else {
                self.playerData = fetchRequestData.last
            }
            
            self.updateModelVersion()
            self.autoSave = true
        } else {
            self.newGame()
        }
    }
    
    func merge(fetchRequestData: [PlayerData]) -> PlayerData? {
        
        guard let playerData = fetchRequestData.sorted(by: { (x, y) -> Bool in
            return x.date ?? Date() < y.date ?? Date()
        }).first else { return nil }
        
        for i in fetchRequestData {
            if i == playerData {
                continue
            }
            
            i.points = i.points - MemoryCard.startingPoints
            playerData.points = playerData.points + (i.points > 0 ? i.points : 0)
            i.premiumPoints = i.premiumPoints - MemoryCard.startingPremiumPoints
            playerData.premiumPoints = playerData.premiumPoints + (i.premiumPoints > 0 ? i.premiumPoints : 0)
            
            for spaceshipData in i.spaceships as? Set<SpaceshipData> ?? [] {
                let spaceship = Spaceship(spaceshipData: spaceshipData).createCopy()
                playerData.addToSpaceships(self.newSpaceshipData(spaceship: spaceship))
                self.managedObjectContext.delete(spaceshipData)
            }
            
            for mothershipSlotData in i.mothership?.slots as? Set<MothershipSlotData> ?? [] {
                if let spaceshipData = mothershipSlotData.spaceship {
                    let spaceship = Spaceship(spaceshipData: spaceshipData).createCopy()
                    
                    if spaceship.level > 1 || spaceship.rarity.rawValue > 1 {
                        playerData.addToSpaceships(self.newSpaceshipData(spaceship: spaceship))
                    }
                    
                    self.managedObjectContext.delete(spaceshipData)
                }
            }
            
            self.managedObjectContext.delete(i)
        }
        
        return playerData
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
        context.mergePolicy = NSOverwriteMergePolicy
        
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
