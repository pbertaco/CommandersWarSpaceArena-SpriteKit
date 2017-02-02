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
        let playerData: PlayerData = self.insertNewObject()
        
        playerData.botLevel = 0
        playerData.level = 1
        playerData.modelVersion = 1
        playerData.name = ""
        playerData.points = 10000
        playerData.premiumPoints = 100
        playerData.xp = 0
        
        playerData.mothership = self.newMothershipData()
        
        for i in 0..<4 {
            let mothershipSlot: MothershipSlotData = self.newMothershipSlotData()
            mothershipSlot.index = Int16(i)
            let spaceshipData: SpaceshipData = self.newSpaceshipData(rarity: Spaceship.randomRarity())
            
            mothershipSlot.spaceship = spaceshipData
            
            playerData.mothership?.addToSlots(mothershipSlot)
            playerData.addToSpaceships(spaceshipData)
        }
        
        for _ in 0..<4 {
            let spaceshipData: SpaceshipData = self.newSpaceshipData(rarity: Spaceship.randomRarity())
            playerData.addToSpaceships(spaceshipData)
        }
        
        return playerData
    }
    
    func updateModelVersion() {
        if self.playerData.modelVersion < 1 {
            self.playerData.modelVersion = 1
        }
    }
}
