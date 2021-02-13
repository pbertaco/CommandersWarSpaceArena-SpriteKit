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
    
    static func unlockSpaceshipPriceInPoints(rarity: Spaceship.rarity) -> Int {
        let price = 62500.0/2.0 * pow(2.0, Double(rarity.rawValue))
        return Int(price)
    }
    
    static func buySpaceshipPriceInPoints(rarity: Spaceship.rarity) -> Int {
        let price = 62500.0 * pow(2.0, Double(rarity.rawValue))
        return Int(price)
    }
    
    static func xpForLevel(level x: Int) -> Int {
        let x = Double(x - 1)
        let xp = pow(2, x) * 1000
        return Int(xp)
    }
    
    static func randomBaseRange(rarity: Spaceship.rarity) -> Int {
        let min: CGFloat = 0.8
        let max: CGFloat = 1.2
        
        var range = CGFloat.random(min: min, max: max)
        
        switch rarity {
        case .common:
            range = range * 178
            break
        case .uncommon:
            range = range * 122
            break
        case .rare:
            range = range * 122
            break
        case .heroic:
            range = range * 84
            break
        case .epic:
            range = range * 84
            break
        case .legendary:
            range = range * 58
            break
        case .supreme:
            range = range * 58
            break
        case .boss:
            range = range * 58 * 2
            break
        }
        
        return Int(round(range))
    }
    
    static func range(level: Int, baseRange: Int) -> Int {
        return Int(Double(baseRange) * pow(1.1, Double(level - 1)))
    }
    
    static func randomBaseDamage(rarity: Spaceship.rarity) -> Int {
        let min: CGFloat = 0.8
        let max: CGFloat = 1.2
        
        var damage = CGFloat.random(min: min, max: max)
        
        switch rarity {
        case .common:
            damage = damage * 11
            break
        case .uncommon:
            damage = damage * 16
            break
        case .rare:
            damage = damage * 23
            break
        case .heroic:
            damage = damage * 34
            break
        case .epic:
            damage = damage * 50
            break
        case .legendary:
            damage = damage * 73
            break
        case .supreme:
            damage = damage * 107
            break
        case .boss:
            damage = damage * 107 * 2
            break
        }
        
        return Int(round(damage))
    }
    
    static func damage(level: Int, baseDamage: Int) -> Int {
        return Int(Double(baseDamage) * pow(1.1, Double(level - 1)))
    }
    
    static func randomBaseLife(rarity: Spaceship.rarity) -> Int {
        let min: CGFloat = 0.8
        let max: CGFloat = 1.2
        
        var life = CGFloat.random(min: min, max: max)
        
        switch rarity {
        case .common:
            life = life * 550
            break
        case .uncommon:
            life = life * 800
            break
        case .rare:
            life = life * 1150
            break
        case .heroic:
            life = life * 1700
            break
        case .epic:
            life = life * 2500
            break
        case .legendary:
            life = life * 3650
            break
        case .supreme:
            life = life * 5350
            break
        case .boss:
            life = life * 5350 * 10
            break
        }
        
        return Int(round(life))
    }
    
    static func maxHealth(level: Int, baseLife: Int) -> Int {
        return Int(Double(baseLife) * pow(1.1, Double(level - 1)))
    }
    
    static func randomBaseSpeed(rarity: Spaceship.rarity) -> Int {
        let min: CGFloat = 0.8
        let max: CGFloat = 1.2
        
        var speed = CGFloat.random(min: min, max: max)
        
        switch rarity {
        case .common:
            speed = speed * 20
            break
        case .uncommon:
            speed = speed * 19
            break
        case .rare:
            speed = speed * 18
            break
        case .heroic:
            speed = speed * 17
            break
        case .epic:
            speed = speed * 16
            break
        case .legendary:
            speed = speed * 15
            break
        case .supreme:
            speed = speed * 14
            break
        case .boss:
            speed = speed * 14 * 2
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
    
    static func randomFear() -> CGFloat {
        let min: CGFloat = 0.0
        let max: CGFloat = 1.0
        
        let fear = CGFloat.random(min: min, max: max)
        
        return fear
    }
}
