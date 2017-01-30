//
//  GameWorld.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/18/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameWorld: SKNode, SKPhysicsContactDelegate {
    
    enum zPosition: CGFloat {
        case mothership = -30
        case mothershipHealthBar = -20
        case shot = -10
        case spaceship = 0
        case spaceshipHealthBar = 10
    }
    
    static func current() -> GameWorld? {
        return GameWorld.lastInstance
    }
    private static weak var lastInstance: GameWorld? = nil
    
    override init() {
        super.init()
        
        GameWorld.lastInstance = self
        self.addChild(SKSpriteNode(imageNamed: "gameWorld"))
        self.loadPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadPhysics() {
        
        self.zPosition = BattleScene.zPosition.gameWorld.rawValue
        
        let size = GameScene.sketchSize
        let physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint(x: -size.width/2, y: -size.height/2), size: size))
        
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = GameWorld.categoryBitMask.world.rawValue
        physicsBody.collisionBitMask = GameWorld.collisionBitMask.world.rawValue
        physicsBody.contactTestBitMask = GameWorld.contactTestBitMask.world.rawValue
        
        self.physicsBody = physicsBody
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        var bodyA = contact.bodyA
        var bodyB = contact.bodyB
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }
        
        switch categoryBitMask(rawValue: bodyA.categoryBitMask | bodyB.categoryBitMask) {
            
            /*
             world
             spaceship
             mothershipSpaceship
             shot
             spaceshipShot
             mothership
             */
            
        case [.spaceship, .shot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didBeginContact(with: bodyB)
            }
            break
            
        case [.spaceship, .spaceshipShot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didBeginContact(with: bodyB)
            }
            break
            
        case [.mothershipSpaceship, .shot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didBeginContact(with: bodyB)
            }
            break
            
        case [.mothershipSpaceship, .spaceshipShot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didBeginContact(with: bodyB)
            }
            break
            
        case [.mothershipSpaceship, .mothership]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didBeginContact(with: bodyB)
            }
            break
            
        case [.shot, .mothership]:
            if let mothership = bodyB.node as? Mothership {
                mothership.didBeginContact(with: bodyA)
            }
            break
            
        case [.spaceshipShot, .mothership]:
            if let mothership = bodyB.node as? Mothership {
                mothership.didBeginContact(with: bodyA)
            }
            break
            
        default:
            #if DEBUG
                var bodyAcategoryBitMask = ""
                var bodyBcategoryBitMask = ""
                
                switch (bodyA.categoryBitMask) {
                    
                case categoryBitMask.world.rawValue:
                    bodyAcategoryBitMask = "world"
                    break
                case categoryBitMask.spaceship.rawValue:
                    bodyAcategoryBitMask = "spaceship"
                    break
                case categoryBitMask.mothershipSpaceship.rawValue:
                    bodyAcategoryBitMask = "mothershipSpaceship"
                    break
                case categoryBitMask.shot.rawValue:
                    bodyAcategoryBitMask = "shot"
                    break
                case categoryBitMask.spaceshipShot.rawValue:
                    bodyAcategoryBitMask = "spaceshipShot"
                    break
                case categoryBitMask.mothership.rawValue:
                    bodyAcategoryBitMask = "mothership"
                    break
                default:
                    bodyAcategoryBitMask = "unknown"
                    break
                }
                
                switch (bodyB.categoryBitMask) {
                    
                case categoryBitMask.world.rawValue:
                    bodyBcategoryBitMask = "world"
                    break
                case categoryBitMask.spaceship.rawValue:
                    bodyBcategoryBitMask = "spaceship"
                    break
                case categoryBitMask.mothershipSpaceship.rawValue:
                    bodyBcategoryBitMask = "mothershipSpaceship"
                    break
                case categoryBitMask.shot.rawValue:
                    bodyBcategoryBitMask = "shot"
                    break
                case categoryBitMask.spaceshipShot.rawValue:
                    bodyBcategoryBitMask = "spaceshipShot"
                    break
                case categoryBitMask.mothership.rawValue:
                    bodyBcategoryBitMask = "mothership"
                    break
                default:
                    bodyBcategoryBitMask = "unknown"
                    break
                }
                
                print("\(#function) case [.\(bodyAcategoryBitMask), .\(bodyBcategoryBitMask)]:")
                fatalError()
            #endif
            break
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        // Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        var bodyA = contact.bodyA
        var bodyB = contact.bodyB
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }
        
        switch categoryBitMask(rawValue: bodyA.categoryBitMask | bodyB.categoryBitMask) {
            
            /*
             world
             spaceship
             mothershipSpaceship
             shot
             spaceshipShot
             mothership
             */
            
        case [.spaceship, .shot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didBeginContact(with: bodyB)
            }
            break
            
        case [.spaceship, .spaceshipShot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didEndContact(with: bodyB)
            }
            break
            
        case [.mothershipSpaceship, .spaceshipShot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didEndContact(with: bodyB)
            }
            break
            
        case [.mothershipSpaceship, .mothership]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didEndContact(with: bodyB)
            }
            break
            
        default:
            #if DEBUG
                var bodyAcategoryBitMask = ""
                var bodyBcategoryBitMask = ""
                
                switch (bodyA.categoryBitMask) {
                    
                case categoryBitMask.world.rawValue:
                    bodyAcategoryBitMask = "world"
                    break
                case categoryBitMask.spaceship.rawValue:
                    bodyAcategoryBitMask = "spaceship"
                    break
                case categoryBitMask.mothershipSpaceship.rawValue:
                    bodyAcategoryBitMask = "mothershipSpaceship"
                    break
                case categoryBitMask.shot.rawValue:
                    bodyAcategoryBitMask = "shot"
                    break
                case categoryBitMask.spaceshipShot.rawValue:
                    bodyAcategoryBitMask = "spaceshipShot"
                    break
                case categoryBitMask.mothership.rawValue:
                    bodyAcategoryBitMask = "mothership"
                    break
                default:
                    bodyAcategoryBitMask = "unknown"
                    break
                }
                
                switch (bodyB.categoryBitMask) {
                    
                case categoryBitMask.world.rawValue:
                    bodyBcategoryBitMask = "world"
                    break
                case categoryBitMask.spaceship.rawValue:
                    bodyBcategoryBitMask = "spaceship"
                    break
                case categoryBitMask.mothershipSpaceship.rawValue:
                    bodyBcategoryBitMask = "mothershipSpaceship"
                    break
                case categoryBitMask.shot.rawValue:
                    bodyBcategoryBitMask = "shot"
                    break
                case categoryBitMask.spaceshipShot.rawValue:
                    bodyBcategoryBitMask = "spaceshipShot"
                    break
                case categoryBitMask.mothership.rawValue:
                    bodyBcategoryBitMask = "mothership"
                    break
                default:
                    bodyBcategoryBitMask = "unknown"
                    break
                }
                
                print("\(#function) case [.\(bodyAcategoryBitMask), .\(bodyBcategoryBitMask)]:")
                fatalError()
            #endif
            break
        }
    }
    
    struct categoryBitMask: OptionSet {
        let rawValue: UInt32
        
        static let world =                  categoryBitMask(rawValue: 1 << 0)
        static let spaceship =              categoryBitMask(rawValue: 1 << 1)
        static let mothershipSpaceship =    categoryBitMask(rawValue: 1 << 2)
        static let shot =                   categoryBitMask(rawValue: 1 << 3)
        static let spaceshipShot =          categoryBitMask(rawValue: 1 << 4)
        static let mothership =             categoryBitMask(rawValue: 1 << 5)
    }
    
    struct collisionBitMask {
        
        static let world: categoryBitMask = []
        static let spaceship: categoryBitMask = [.world, .spaceship, .mothershipSpaceship, .mothership]
        static let mothershipSpaceship: categoryBitMask = [.world, .spaceship, .mothershipSpaceship]
        static let shot: categoryBitMask = []
        static let spaceshipShot: categoryBitMask = []
        static let mothership: categoryBitMask = []
    }
    
    struct contactTestBitMask {
        
        static let world: categoryBitMask = []
        static let spaceship: categoryBitMask = [.shot, .spaceshipShot]
        static let mothershipSpaceship: categoryBitMask = [.shot, .spaceshipShot, .mothership]
        static let shot: categoryBitMask = [.spaceship, .mothershipSpaceship, .mothership]
        static let spaceshipShot: categoryBitMask = [.spaceship, .mothershipSpaceship, .mothership]
        static let mothership: categoryBitMask = [.mothershipSpaceship, .shot, .spaceshipShot]
    }
}
