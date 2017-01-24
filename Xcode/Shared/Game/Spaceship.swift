//
//  Spaceship.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class Spaceship: SKSpriteNode {
    
    enum rarity: Int {
        case common, rare, epic, legendary
    }
    
    static var skins: [String] = [
        "spaceshipA", "spaceshipB", "spaceshipC", "spaceshipD", "spaceshipE",
        "spaceshipF", "spaceshipG", "spaceshipH"
    ]
    
    private(set) var spaceshipData: SpaceshipData?
    
    var level: Int {
        get { return self.level }
        set { self.spaceshipData?.level = Int16(newValue)
            self.level = newValue
        }
    }
    
    var damage: Int = 1
    var life: Int = 1
    var rarity: rarity = .common
    
    var skinIndex: Int = 0
    var colorRed: CGFloat = 1
    var colorGreen: CGFloat = 1
    var colorBlue: CGFloat = 1
    var baseDamage: Int = 1
    var baseLife: Int = 1
    
    
    var health: Int = 1
    
    var startingPosition = CGPoint.zero
    var startingZPosition: CGFloat = 0
    var destination = CGPoint.zero
    
    init(spaceshipData: SpaceshipData, loadPhysics: Bool = false) {
        super.init(texture: nil, color: SKColor.clear, size: CGSize.zero)
        self.spaceshipData = spaceshipData
        
        let color = SKColor(
            red: CGFloat(spaceshipData.colorRed),
            green: CGFloat(spaceshipData.colorGreen),
            blue: CGFloat(spaceshipData.colorBlue), alpha: 1)
        
        self.load(level: Int(spaceshipData.level),
                  baseDamage: Int(spaceshipData.baseDamage),
                  baseLife: Int(spaceshipData.baseLife),
                  skinIndex: Int(spaceshipData.skin), color: color,
                  loadPhysics: loadPhysics)
    }
    
    init(loadPhysics: Bool = false) {
        super.init(texture: nil, color: SKColor.clear, size: CGSize.zero)
        
        self.rarity = .common
        
        self.load(level: 1,
                  baseDamage: GameMath.randomBaseDamage(rarity: self.rarity),
                  baseLife: GameMath.randomBaseLife(rarity: self.rarity),
                  skinIndex: Int.random(Spaceship.skins.count),
                  color: Spaceship.randomColor(),
                  loadPhysics: loadPhysics)
    }
    
    func load(level: Int, baseDamage: Int, baseLife: Int,
              skinIndex: Int, color: SKColor, loadPhysics: Bool = false) {
        
        self.skinIndex = skinIndex
        
        let texture = Spaceship.skinTexture(index: skinIndex)
        self.texture = texture
        self.size = texture.size()
        self.setScaleToFit(width: 55, height: 55)
        
        self.color = color
        self.colorBlendFactor = 1
        
        self.life = GameMath.life(level: level, baseLife: baseLife)
        self.damage = GameMath.damage(level: level, baseDamage: baseDamage)
        
        self.health = self.life
        
        if loadPhysics {
            self.loadPhysics()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move() {
        if self.health > 0 {
            
        }
    }
    
    func didBeginContact(with bodyB: SKPhysicsBody) {
        if let bodyA = self.physicsBody {
            switch GameWorld.categoryBitMask(rawValue: bodyA.categoryBitMask | bodyB.categoryBitMask) {
            case [.mothershipSpaceship, .mothership]:
                break
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
    }
    
    func didEndContact(with bodyB: SKPhysicsBody) {
        if let bodyA = self.physicsBody {
            switch GameWorld.categoryBitMask(rawValue: bodyA.categoryBitMask | bodyB.categoryBitMask) {
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
    }
    
    func loadPhysics() {
        let physicsBody = SKPhysicsBody(circleOfRadius: 55/2)
        
        physicsBody.mass = 0.105592422187328
        physicsBody.restitution = 0.2
        physicsBody.linearDamping = 0.1
        physicsBody.angularDamping = 0.1
        
        self.physicsBody = physicsBody
        
        self.setBitMasksToMothershipSpaceship()
    }
    
    func setBitMasksToMothershipSpaceship() {
        if let physicsBody = self.physicsBody {
            physicsBody.isDynamic = false
            physicsBody.categoryBitMask = GameWorld.categoryBitMask.mothershipSpaceship.rawValue
            physicsBody.collisionBitMask = GameWorld.collisionBitMask.mothershipSpaceship.rawValue
            physicsBody.contactTestBitMask = GameWorld.contactTestBitMask.mothershipSpaceship.rawValue
        }
    }
    
    func setBitMasksToSpaceship() {
        if let physicsBody = self.physicsBody {
            physicsBody.isDynamic = true
            physicsBody.categoryBitMask = GameWorld.categoryBitMask.spaceship.rawValue
            physicsBody.collisionBitMask = GameWorld.collisionBitMask.spaceship.rawValue
            physicsBody.contactTestBitMask = GameWorld.contactTestBitMask.spaceship.rawValue
        }
    }
    
    static func skinTexture(index i: Int) -> SKTexture {
        let texture = SKTexture(imageNamed: Spaceship.skins[i])
        texture.filteringMode = GameScene.defaultFilteringMode
        return texture
    }
    
    static func randomColor() -> SKColor {
        var red = CGFloat.random()
        var green = CGFloat.random()
        var blue = CGFloat.random()
        let maxColor = 1 - max(max(red, green), blue)
        
        red = red + maxColor
        green = green + maxColor
        blue = blue + maxColor
        
        return SKColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
