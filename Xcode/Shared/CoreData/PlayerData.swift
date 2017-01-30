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
        
        playerData.level = 1
        playerData.modelVersion = 1
        playerData.name = ""
        playerData.points = 10000
        playerData.premiumPoints = 100
        playerData.xp = 0
        
        playerData.mothership = self.newMothershipData()
        
        let rarityList: [Spaceship.rarity] = [.common, .common, .common, .common]
        
        var i = 0
        for rarity in rarityList {
            let mothershipSlot: MothershipSlotData = self.newMothershipSlotData()
            mothershipSlot.index = Int16(i)
            i = i + 1
            let spaceshipData: SpaceshipData = self.newSpaceshipData(rarity: rarity)
            
            mothershipSlot.spaceship = spaceshipData
            
            playerData.mothership?.addToSlots(mothershipSlot)
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
