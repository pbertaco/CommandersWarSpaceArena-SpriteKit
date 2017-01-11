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
        playerData.xp = 0
        
        playerData.mothership = self.newMothershipData()
        
        for _ in 0..<4 {
            let spaceshipData: SpaceshipData = self.newSpaceshipData()
            playerData.mothership?.addToSpaceships(spaceshipData)
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
