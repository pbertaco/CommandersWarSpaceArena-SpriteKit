//
//  Mission.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 2/2/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class Mission {
    
    var level: Int
    var rarities: [Spaceship.rarity]
    
    init(level: Int, rarities: [Spaceship.rarity]) {
        self.level = level
        self.rarities = rarities
    }
    
    static var types: [Mission] = [
        Mission(level: 1, rarities: [.common, .common, .common, .common]),
        Mission(level: 1, rarities: [.rare, .common, .common, .common]),
        Mission(level: 1, rarities: [.rare, .rare, .common, .common]),
        Mission(level: 1, rarities: [.epic, .common, .common, .common]),
        Mission(level: 2, rarities: [.rare, .rare, .rare, .common]),
        Mission(level: 2, rarities: [.epic, .rare, .common, .common]),
        Mission(level: 2, rarities: [.rare, .rare, .rare, .rare]),
        Mission(level: 3, rarities: [.epic, .rare, .rare, .common]),
        Mission(level: 3, rarities: [.legendary, .common, .common, .common]),
        Mission(level: 3, rarities: [.epic, .epic, .common, .common]),
        Mission(level: 3, rarities: [.epic, .rare, .rare, .rare]),
        Mission(level: 4, rarities: [.legendary, .rare, .common, .common]),
        Mission(level: 4, rarities: [.epic, .epic, .rare, .common]),
        Mission(level: 4, rarities: [.legendary, .rare, .rare, .common]),
        Mission(level: 5, rarities: [.epic, .epic, .rare, .rare]),
        Mission(level: 5, rarities: [.legendary, .epic, .common, .common]),
        Mission(level: 5, rarities: [.epic, .epic, .epic, .common]),
        Mission(level: 5, rarities: [.legendary, .rare, .rare, .rare]),
        Mission(level: 6, rarities: [.legendary, .epic, .rare, .common]),
        Mission(level: 6, rarities: [.epic, .epic, .epic, .rare]),
        Mission(level: 6, rarities: [.legendary, .epic, .rare, .rare]),
        Mission(level: 7, rarities: [.legendary, .legendary, .common, .common]),
        Mission(level: 7, rarities: [.legendary, .epic, .epic, .common]),
        Mission(level: 7, rarities: [.epic, .epic, .epic, .epic]),
        Mission(level: 7, rarities: [.legendary, .legendary, .rare, .common]),
        Mission(level: 8, rarities: [.legendary, .epic, .epic, .rare]),
        Mission(level: 8, rarities: [.legendary, .legendary, .rare, .rare]),
        Mission(level: 8, rarities: [.legendary, .legendary, .epic, .common]),
        Mission(level: 9, rarities: [.legendary, .epic, .epic, .epic]),
        Mission(level: 9, rarities: [.legendary, .legendary, .epic, .rare]),
        Mission(level: 9, rarities: [.legendary, .legendary, .legendary, .common]),
        Mission(level: 9, rarities: [.legendary, .legendary, .epic, .epic]),
        Mission(level: 10, rarities: [.legendary, .legendary, .legendary, .rare]),
        Mission(level: 10, rarities: [.legendary, .legendary, .legendary, .epic]),
        Mission(level: 10, rarities: [.legendary, .legendary, .legendary, .legendary])
    ]
}
