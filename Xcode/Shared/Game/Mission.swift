//
//  Mission.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 2/2/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class Mission {
    
    var level: Int
    var rarities: [Spaceship.rarity]
    var color: SKColor
    
    init(level: Int, rarities: [Spaceship.rarity], color: SKColor) {
        self.level = level
        self.rarities = rarities
        self.color = color
    }
    
    static var types: [Mission] = [
        Mission(level: 1, rarities: [.common, .common, .common, .common], color: SKColor(red: 0.8, green: 1.0, blue: 0.1, alpha: 1)),
        Mission(level: 1, rarities: [.rare, .common, .common, .common], color: SKColor(red: 1.0, green: 0.1, blue: 0.8, alpha: 1)),
        Mission(level: 1, rarities: [.rare, .rare, .common, .common], color: SKColor(red: 0.5, green: 1.0, blue: 0.2, alpha: 1)),
        Mission(level: 2, rarities: [.epic, .common, .common, .common], color: SKColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1)),
        Mission(level: 2, rarities: [.rare, .rare, .rare, .common], color: SKColor(red: 0.9, green: 1.0, blue: 0.2, alpha: 1)),
        Mission(level: 2, rarities: [.epic, .rare, .common, .common], color: SKColor(red: 1.0, green: 0.3, blue: 0.6, alpha: 1)),
        Mission(level: 3, rarities: [.rare, .rare, .rare, .rare], color: SKColor(red: 0.7, green: 0.7, blue: 1.0, alpha: 1)),
        Mission(level: 3, rarities: [.epic, .rare, .rare, .common], color: SKColor(red: 0.2, green: 0.7, blue: 1.0, alpha: 1)),
        Mission(level: 3, rarities: [.legendary, .common, .common, .common], color: SKColor(red: 1.0, green: 0.3, blue: 0.5, alpha: 1)),
        Mission(level: 4, rarities: [.epic, .epic, .common, .common], color: SKColor(red: 0.5, green: 0.6, blue: 1.0, alpha: 1)),
        Mission(level: 4, rarities: [.epic, .rare, .rare, .rare], color: SKColor(red: 1.0, green: 0.6, blue: 0.4, alpha: 1)),
        Mission(level: 4, rarities: [.legendary, .rare, .common, .common], color: SKColor(red: 1.0, green: 0.1, blue: 0.4, alpha: 1)),
        Mission(level: 5, rarities: [.epic, .epic, .rare, .common], color: SKColor(red: 1.0, green: 1.0, blue: 0.4, alpha: 1)),
        Mission(level: 5, rarities: [.legendary, .rare, .rare, .common], color: SKColor(red: 1.0, green: 0.9, blue: 0.6, alpha: 1)),
        Mission(level: 5, rarities: [.epic, .epic, .rare, .rare], color: SKColor(red: 0.1, green: 0.5, blue: 1.0, alpha: 1)),
        Mission(level: 6, rarities: [.legendary, .epic, .common, .common], color: SKColor(red: 0.3, green: 1.0, blue: 0.9, alpha: 1)),
        Mission(level: 6, rarities: [.epic, .epic, .epic, .common], color: SKColor(red: 0.9, green: 0.8, blue: 1.0, alpha: 1)),
        Mission(level: 6, rarities: [.legendary, .rare, .rare, .rare], color: SKColor(red: 0.8, green: 1.0, blue: 0.7, alpha: 1)),
        Mission(level: 7, rarities: [.legendary, .epic, .rare, .common], color: SKColor(red: 0.7, green: 1.0, blue: 1.0, alpha: 1)),
        Mission(level: 7, rarities: [.epic, .epic, .epic, .rare], color: SKColor(red: 1.0, green: 0.7, blue: 1.0, alpha: 1)),
        Mission(level: 7, rarities: [.legendary, .epic, .rare, .rare], color: SKColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1)),
        Mission(level: 8, rarities: [.legendary, .legendary, .common, .common], color: SKColor(red: 1.0, green: 0.5, blue: 0.9, alpha: 1)),
        Mission(level: 8, rarities: [.legendary, .epic, .epic, .common], color: SKColor(red: 0.9, green: 0.9, blue: 1.0, alpha: 1)),
        Mission(level: 8, rarities: [.epic, .epic, .epic, .epic], color: SKColor(red: 1.0, green: 0.5, blue: 0.8, alpha: 1)),
        Mission(level: 9, rarities: [.legendary, .legendary, .rare, .common], color: SKColor(red: 0.9, green: 1.0, blue: 0.5, alpha: 1)),
        Mission(level: 9, rarities: [.legendary, .epic, .epic, .rare], color: SKColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1)),
        Mission(level: 9, rarities: [.legendary, .legendary, .rare, .rare], color: SKColor(red: 0.6, green: 1.0, blue: 0.6, alpha: 1)),
        Mission(level: 10, rarities: [.legendary, .legendary, .epic, .common], color: SKColor(red: 0.9, green: 1.0, blue: 0.5, alpha: 1)),
        Mission(level: 10, rarities: [.legendary, .epic, .epic, .epic], color: SKColor(red: 0.9, green: 0.2, blue: 1.0, alpha: 1)),
        Mission(level: 10, rarities: [.legendary, .legendary, .epic, .rare], color: SKColor(red: 0.8, green: 0.3, blue: 1.0, alpha: 1)),
        Mission(level: 11, rarities: [.legendary, .legendary, .legendary, .common], color: SKColor(red: 0.4, green: 0.9, blue: 1.0, alpha: 1)),
        Mission(level: 11, rarities: [.legendary, .legendary, .epic, .epic], color: SKColor(red: 1.0, green: 1.0, blue: 0.6, alpha: 1)),
        Mission(level: 11, rarities: [.legendary, .legendary, .legendary, .rare], color: SKColor(red: 0.9, green: 0.7, blue: 1.0, alpha: 1)),
        Mission(level: 12, rarities: [.legendary, .legendary, .legendary, .epic], color: SKColor(red: 0.5, green: 0.3, blue: 1.0, alpha: 1)),
        Mission(level: 12, rarities: [.legendary, .legendary, .legendary, .legendary], color: SKColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1))

    ]
}
