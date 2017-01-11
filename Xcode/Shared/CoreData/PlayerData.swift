//
//  PlayerData.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/10/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import CoreData


extension MemoryCard {
    
    func newPlayerData() -> PlayerData {
        let playerData = NSEntityDescription.insertNewObject(forEntityName: "PlayerData", into: self.managedObjectContext) as! PlayerData
        
        playerData.modelVersion = 1
        playerData.name = ""
        
        return playerData
    }
    
    func updateModelVersion() {
        if self.playerData.modelVersion < 1 {
            self.playerData.modelVersion = 1
        }
    }
}

extension PlayerData {
    
    func addData(value: NSManagedObject) {
        let items = self.mutableSetValue(forKey: "")
        items.add(value)
    }
    
    func removeData(value: NSManagedObject) {
        let items = self.mutableSetValue(forKey: "")
        items.remove(value)
    }
}
