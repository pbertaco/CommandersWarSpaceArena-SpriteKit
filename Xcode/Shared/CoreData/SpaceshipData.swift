//
//  SpaceshipData.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit
import CoreData
import CoreImage

extension MemoryCard {
    
    func newSpaceshipData(rarity: Spaceship.rarity, color: SKColor? = nil) -> SpaceshipData {
        let spaceshipData: SpaceshipData = self.insertNewObject()
        
        let color: CIColor = {
            let color = CIColor(color: color ?? Spaceship.randomColorFor(element: Spaceship.randomElements()))
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
        spaceshipData.fearLevel = Double(GameMath.randomFear())
        spaceshipData.baseSpeed = Int16(GameMath.randomBaseSpeed(rarity: rarity))
        spaceshipData.rarity = Int16(rarity.rawValue)
        spaceshipData.skin = Int16(Int.random(Spaceship.skins.count))
        spaceshipData.xp = 0
        
        return spaceshipData
    }
    
    func newSpaceshipData(spaceship: Spaceship) -> SpaceshipData {
        let spaceshipData: SpaceshipData = self.insertNewObject()
        
        let color: CIColor = {
            let color = CIColor(color: spaceship.color)
            #if os(OSX)
                return color!
            #else
                return color
            #endif
        }()
        
        spaceshipData.colorRed = Double(color.red)
        spaceshipData.colorGreen = Double(color.green)
        spaceshipData.colorBlue = Double(color.blue)
        spaceshipData.baseDamage = Int16(spaceship.baseDamage)
        spaceshipData.level = Int16(spaceship.level)
        spaceshipData.baseLife = Int16(spaceship.baseLife)
        spaceshipData.baseRange = Int16(spaceship.baseRange)
        spaceshipData.baseSpeed = Int16(spaceship.baseSpeed)
        spaceshipData.rarity = Int16(spaceship.rarity.rawValue)
        spaceshipData.skin = Int16(spaceship.skinIndex)
        spaceshipData.fearLevel = Double(spaceship.fearLevel)
        
        return spaceshipData
        
    }
}
