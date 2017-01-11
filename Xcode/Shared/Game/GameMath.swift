//
//  GameMath.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameMath {

    static func randomBaseDamage(rarity: Spaceship.rarity) -> Int {
        let min: CGFloat = 0.9
        let max: CGFloat = 1.1
        
        var damage = CGFloat.random(min: min, max: max)
        
        switch rarity {
        case .common:
            damage = damage * 10
            break
        case .rare:
            damage = damage * 14
            break
        case .epic:
            damage = damage * 20
            break
        case .legendary:
            damage = damage * 29
            break
        }
        
        return Int(damage)
    }
    
    static func damage(level: Int, baseDamage: Int) -> Int {
        return Int(Double(baseDamage) * pow(1.1, Double(level - 1)))
    }
    
    static func randomBaseLife(rarity: Spaceship.rarity) -> Int {
        let min: CGFloat = 0.9
        let max: CGFloat = 1.1
        
        var life = CGFloat.random(min: min, max: max)
        
        switch rarity {
        case .common:
            life = life * 150
            break
        case .rare:
            life = life * 210
            break
        case .epic:
            life = life * 300
            break
        case .legendary:
            life = life * 435
            break
        }
        
        return Int(life)
    }
    
    static func life(level: Int, baseLife: Int) -> Int {
        return Int(Double(baseLife) * pow(1.1, Double(level - 1)))
    }
}
