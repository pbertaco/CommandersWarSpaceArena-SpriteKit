//
//  PlayerData.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/10/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import CoreData

extension MemoryCard {
    
    func newPlayerData() -> PlayerData {
        let playerData: PlayerData = self.insertNewObject()
        
        playerData.botLevel = 0
        #if os(OSX)
            playerData.deviceName = Host.current().localizedName!
        #else
            //playerData.deviceName = UIDevice.current.name
        #endif
        playerData.maxBotLevel = 0
        playerData.maxBotRarity = Int16(Spaceship.rarity.common.rawValue)
        playerData.maxSpaceshipLevel = 10
        playerData.modelVersion = 3
        playerData.music = true
        playerData.name = ""
        playerData.points = 10000
        playerData.premiumPoints = 256
        playerData.sound = true
        
        playerData.mothership = self.newMothershipData()
        
        let elements: [Elements] = [.water, .fire, .ice, .wind]
        
        for i in 0..<4 {
            let mothershipSlot: MothershipSlotData = self.newMothershipSlotData()
            mothershipSlot.index = Int16(i)
            let spaceshipData: SpaceshipData = self.newSpaceshipData(rarity: .common, color: Spaceship.randomColorFor(element: elements[i]))
            
            mothershipSlot.spaceship = spaceshipData
            
            playerData.mothership?.addToSlots(mothershipSlot)
        }
        
        for _ in 0..<4 {
            //let spaceshipData: SpaceshipData = self.newSpaceshipData(rarity: .common)
            //playerData.addToSpaceships(spaceshipData)
        }
        
        return playerData
    }
    
    func updateModelVersion() {
        if self.playerData.modelVersion < 1 {
            self.playerData.modelVersion = 1
        }
        
        if self.playerData.modelVersion < 2 {
            
            self.playerData.modelVersion = 2
            
            self.playerData.points = self.playerData.points + 1000000
            self.playerData.premiumPoints = self.playerData.premiumPoints + 1000
            
            let spaceshipData: SpaceshipData = self.newSpaceshipData(rarity: .legendary)
            
            spaceshipData.baseDamage = 36
            spaceshipData.baseLife = 1815
            spaceshipData.baseRange = 64
            spaceshipData.fearLevel = 0.5
            spaceshipData.baseSpeed = 18
            
            spaceshipData.colorRed = 1.0
            spaceshipData.colorGreen = 0.45
            spaceshipData.colorBlue = 0
            
            spaceshipData.level = 10
            spaceshipData.skin = 13
            
            playerData.addToSpaceships(spaceshipData)
        }
        
        if self.playerData.modelVersion < 3 {
            self.playerData.modelVersion = 3
            
            self.playerData.points = self.playerData.points + 1000000
            self.playerData.premiumPoints = self.playerData.premiumPoints + 1000
            
            #if os(OSX)
                self.playerData.deviceName = Host.current().localizedName!
            #else
                //self.playerData.deviceName = UIDevice.current.name
            #endif
        }
        
        if self.playerData.modelVersion < 4 {
            self.playerData.modelVersion = 4
            self.playerData.lastGift = 0;
        }
    }
}
