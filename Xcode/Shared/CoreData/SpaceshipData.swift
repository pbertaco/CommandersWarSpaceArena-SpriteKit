//
//  SpaceshipData.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import CoreData
import CoreImage

extension MemoryCard {
    
    func newSpaceshipData(rarity: Spaceship.rarity) -> SpaceshipData {
        let spaceshipData: SpaceshipData = self.insertNewObject()
        
        let color: CIColor = {
            let color = CIColor(color: Spaceship.randomColor())
            #if os(OSX)
                return color!
            #else
                return color
            #endif
        }()
        
        spaceshipData.colorRed = Double(color.red)
        spaceshipData.colorGreen = Double(color.green)
        spaceshipData.colorBlue = Double(color.blue)
        spaceshipData.baseDamage = Int16(GameMath.randomBaseDamage(rarity: rarity))
        spaceshipData.level = 1
        spaceshipData.baseLife = Int16(GameMath.randomBaseLife(rarity: rarity))
        spaceshipData.baseRange = Int16(GameMath.randomBaseRange(rarity: rarity))
        spaceshipData.baseSpeed = Int16(GameMath.randomBaseSpeed(rarity: rarity))
        spaceshipData.rarity = Int16(rarity.rawValue)
        spaceshipData.skin = Int16(Int.random(Spaceship.skins.count))
        
        return spaceshipData
    }
    
    func newSpaceshipData(spaceship: Spaceship) -> SpaceshipData {
        let spaceshipData: SpaceshipData = self.insertNewObject()
        
        spaceshipData.colorRed = Double(spaceship.colorRed)
        spaceshipData.colorGreen = Double(spaceship.colorGreen)
        spaceshipData.colorBlue = Double(spaceship.colorBlue)
        spaceshipData.baseDamage = Int16(spaceship.baseDamage)
        spaceshipData.level = Int16(spaceship.level)
        spaceshipData.baseLife = Int16(spaceship.baseLife)
        spaceshipData.baseRange = Int16(spaceship.baseRange)
        spaceshipData.baseSpeed = Int16(spaceship.baseSpeed)
        spaceshipData.rarity = Int16(spaceship.rarity.rawValue)
        spaceshipData.skin = Int16(spaceship.skinIndex)
        
        return spaceshipData
        
    }
}
