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
    
    func newSpaceshipData() -> SpaceshipData {
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
        spaceshipData.baseDamage = Int16(GameMath.randomBaseDamage(rarity: .common))
        spaceshipData.level = 1
        spaceshipData.baseLife = Int16(GameMath.randomBaseLife(rarity: .common))
        spaceshipData.rarity = Int16(Spaceship.rarity.common.rawValue)
        spaceshipData.skin = Int16(Int.random(Spaceship.skins.count))
        spaceshipData.xp = 0
        
        return spaceshipData
    }
}
