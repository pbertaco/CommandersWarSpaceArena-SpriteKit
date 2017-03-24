//
//  GameMath.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameMath {
    
    static func unlockSpaceshipPriceInPremiumPoints(rarity: Spaceship.rarity) -> Int {
        let price = 12.5/2.0 * pow(2.0, Double(rarity.rawValue))
        return Int(price)
    }
    
    static func buySpaceshipPriceInPremiumPoints(rarity: Spaceship.rarity) -> Int {
        let price = 12.5 * pow(2.0, Double(rarity.rawValue))
        return Int(price)
    }
    
    static func buySpaceshipPriceInPoints(rarity: Spaceship.rarity) -> Int {
        let price = pow(2.0, Double(rarity.rawValue)) * 62500
        return Int(price)
    }
    
    static func xpForLevel(level x: Int) -> Int {
        let x = Double(x - 1)
        let xp = pow(2, x) * 1000
        return Int(xp)
    }
    
    static func randomBaseRange(rarity: Spaceship.rarity) -> Int {
        let min: CGFloat = 0.9
        let max: CGFloat = 1.1
        
        var range = CGFloat.random(min: min, max: max)
        
        switch rarity {
        case .common:
            range = range * 178
            break
        case .rare:
            range = range * 122
            break
        case .epic:
            range = range * 84
            break
        case .legendary:
            range = range * 58
            break
        }
        
        return Int(round(range))
    }
    
    static func range(level: Int, baseRange: Int) -> Int {
        return Int(Double(baseRange) * pow(1.1, Double(level - 1)))
    }
    
    static func randomBaseDamage(rarity: Spaceship.rarity) -> Int {
        let min: CGFloat = 0.9
        let max: CGFloat = 1.1
        
        var damage = CGFloat.random(min: min, max: max)
        
        switch rarity {
        case .common:
            damage = damage * 11
            break
        case .rare:
            damage = damage * 16
            break
        case .epic:
            damage = damage * 23
            break
        case .legendary:
            damage = damage * 33
            break
        }
        
        return Int(round(damage))
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
            life = life * 550
            break
        case .rare:
            life = life * 800
            break
        case .epic:
            life = life * 1150
            break
        case .legendary:
            life = life * 1650
            break
        }
        
        return Int(round(life))
    }
    
    static func maxHealth(level: Int, baseLife: Int) -> Int {
        return Int(Double(baseLife) * pow(1.1, Double(level - 1)))
    }
    
    static func randomBaseSpeed(rarity: Spaceship.rarity) -> Int {
        let min: CGFloat = 0.9
        let max: CGFloat = 1.1
        
        var speed = CGFloat.random(min: min, max: max)
        
        switch rarity {
        case .common:
            speed = speed * 13
            break
        case .rare:
            speed = speed * 14
            break
        case .epic:
            speed = speed * 15
            break
        case .legendary:
            speed = speed * 16
            break
        }
        
        return Int(round(speed))
    }
    
    static func speed(level: Int, baseSpeed: Int) -> Int {
        return Int(Double(baseSpeed) * pow(1.1, Double(level - 1)))
    }
    
    static func spaceshipMaxVelocitySquared(level: Int, speedAtribute: Int) -> CGFloat {
        let maxVelocity = CGFloat(speedAtribute) * 6
        return maxVelocity * maxVelocity
    }
}
