//
//  Mothership.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/23/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class Mothership: SKSpriteNode {
    
    enum team {
        case blue
        case red
    }
    
    var team: team
    
    var spaceships = [Spaceship]()
    
    var maxHealth = 5800
    var health = 5800
    
    var healthBar: MothershipHealthBar?

    init(team: team) {
        
        self.team = team
        
        let texture = SKTexture(imageNamed: "mothership")
        texture.filteringMode = GameScene.defaultFilteringMode
        
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        var color: SKColor = .white
        
        switch team {
        case .blue:
            color = GameColors.blueTeam
            self.position = CGPoint(x: 0, y: -289)
            break
        case .red:
            color = GameColors.redTeam
            self.position = CGPoint(x: 0, y: 289)
            self.zRotation = π
            break
        }
        
        self.color = color
        self.colorBlendFactor = 1
        self.blendMode = .add
        
        self.loadPhysics(rectangleOf: self.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(enemyMothership: Mothership? = nil, enemySpaceships: [Spaceship] = []) {
        for spaceship in self.spaceships {
            spaceship.update(enemyMothership: enemyMothership, enemySpaceships: enemySpaceships, allySpaceships: self.spaceships)
        }
    }
    
    func didBeginContact(with bodyB: SKPhysicsBody) {
        if let bodyA = self.physicsBody {
            switch GameWorld.categoryBitMask(rawValue: bodyA.categoryBitMask | bodyB.categoryBitMask) {
                
            case [.shot, .mothership]:
                if let shot = bodyB.node as? Shot {
                    self.getHitBy(shot)
                }
                break
                
            case [.spaceshipShot, .mothership]:
                if let shot = bodyB.node as? Shot {
                    self.getHitBy(shot)
                }
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
    
    func getHitBy(_ shot: Shot) {
        if shot.damage > 0 {
            self.damageEffect(damage: shot.damage, position: shot.position)
        }
        
        if self.health > 0 && self.health - shot.damage <= 0 {
            self.die()
        } else {
            self.health = self.health - shot.damage
        }
        self.updateHealthBar(health: self.health, maxHealth: self.maxHealth)
        shot.damage = 0
        shot.removeFromParent()
    }
    
    func die() {
        self.health = 0
        
        self.isHidden = true
        self.healthBar?.isHidden = true
        
        for spaceship in self.spaceships {
            
            spaceship.canRespawn = false
            
            if self.intersects(spaceship) {
                spaceship.die()
                spaceship.updateHealthBar(health: spaceship.health, maxHealth: spaceship.maxHealth)
            }
            spaceship.labelRespawn?.text = ""
        }
    }
    
    func damageEffect(damage: Int, position: CGPoint) {
        
        let duration = 0.5
        
        let label = Label(text: damage.description, fontSize: .fontSize8, fontColor: SKColor.red)
        label.position = position
        self.parent?.addChild(label)
        
        label.run(SKAction.scale(to: 2, duration: 0))
        label.run(SKAction.scale(to: 1, duration: duration))
        
        
        label.run(SKAction.sequence([
            SKAction.wait(forDuration: duration/2),
            SKAction.fadeAlpha(to: 0, duration: duration/2),
            SKAction.removeFromParent()
            ]
        ))
    }
    
    func loadSpaceship(spaceship: Spaceship, gameWorld: GameWorld, i: Int) {
        
        spaceship.team = self.team
        
        var position = CGPoint.zero
        
        switch i {
        case 0:
            position = CGPoint(x: -129, y: 0)
            break
        case 1:
            position = CGPoint(x: -43, y: 0)
            break
        case 2:
            position = CGPoint(x: 43, y: 0)
            break
        case 3:
            position = CGPoint(x: 129, y: 0)
            break
        default:
            break
        }
        
        let spriteNode = SKSpriteNode(imageNamed: "mothershipSlot")
        spriteNode.position = position
        spriteNode.color = self.color
        spriteNode.colorBlendFactor = 1
        spriteNode.blendMode = .add
        self.addChild(spriteNode)
        
        spaceship.position = self.convert(position, to: gameWorld)
        spaceship.startingPosition = spaceship.position
        
        spaceship.zRotation = self.zRotation
        spaceship.startingZPosition = spaceship.zRotation
        
        gameWorld.addChild(spaceship)
        
        spaceship.loadWeaponRangeShapeNode(gameWorld: gameWorld)
        spaceship.loadHealthBar(gameWorld: gameWorld)
        spaceship.loadLabelRespawn(gameWorld: gameWorld)
        
    }
    
    func loadSpaceships(gameWorld: GameWorld) {
        var i = 0
        for spaceship in self.spaceships {
            self.loadSpaceship(spaceship: spaceship, gameWorld: gameWorld, i: i)
            i += 1
        }
    }
    
    func loadPhysics(rectangleOf size: CGSize) {
        
        self.zPosition = GameWorld.zPosition.mothership.rawValue
        
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = GameWorld.categoryBitMask.mothership.rawValue
        physicsBody.collisionBitMask = GameWorld.collisionBitMask.mothership.rawValue
        physicsBody.contactTestBitMask = GameWorld.contactTestBitMask.mothership.rawValue
        
        self.physicsBody = physicsBody
    }
    
    func loadHealthBar(gameWorld: GameWorld) {
        let healthBar = MothershipHealthBar(team: self.team)
        healthBar.position = self.position + healthBar.positionOffset
        
        gameWorld.addChild(healthBar)
        
        self.healthBar = healthBar
    }
    
    func updateHealthBarPosition() {
        if let healthBar = self.healthBar {
            healthBar.position = self.position + healthBar.positionOffset
        }
    }
    
    func updateHealthBar(health: Int, maxHealth: Int) {
        if let healthBar = self.healthBar {
            healthBar.update(health: health, maxHealth: maxHealth)
        }
    }

}
