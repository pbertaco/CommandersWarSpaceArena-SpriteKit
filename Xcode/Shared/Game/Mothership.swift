//
//  Mothership.swift
//  CommandersWar
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
        
        let texture = SKTexture(imageNamed: "mothership", filteringMode: GameScene.defaultFilteringMode)
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
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
        
        self.set(color: color)
        
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
    
    func didSimulatePhysics() {
        for spaceship in self.spaceships {
            spaceship.didSimulatePhysics()
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
    
    func getHitBy(_ shot: Shot) {
        
        if shot.shooter?.team == self.team || shot.damage <= 0 {
            return
        }
        
        if let shooter = shot.shooter {
            if shooter.team != self.team {
                shooter.battlePoints = shooter.battlePoints + shot.damage/2
            }
        }
        
        self.damageEffect(damage: shot.damage, position: shot.position)
        
        if self.health > 0 && self.health - shot.damage <= 0 {
            self.die(shooter: shot.shooter)
        } else {
            self.health = self.health - shot.damage
        }
        self.updateHealthBar(health: self.health, maxHealth: self.maxHealth)
        shot.damage = 0
        shot.removeFromParent()
    }
    
    func die(shooter: Spaceship?) {
        
        self.health = 0
        self.explosionEffect()
        
        for spaceship in self.spaceships {
            
            spaceship.canRespawn = false
            
            if self.intersects(spaceship) {
                if spaceship.health > 0 {
                    spaceship.die(shooter: shooter)
                    spaceship.updateHealthBar(health: spaceship.health, maxHealth: spaceship.maxHealth)
                }
            }
            spaceship.labelRespawn?.text = ""
        }
        
        self.setBitMasksToDeadMothership()
    }
    
    func damageEffect(damage: Int, position: CGPoint) {
        
        let duration = 0.5
        
        let label = Label(text: damage.description, fontSize: .fontSize8, fontColor: SKColor.red)
        Control.set.remove(label)
        
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
    
    func explosionEffect() {
        guard let targetNode = self.parent else { return }
        let particleZPosition = GameWorld.zPosition.explosion.rawValue
        let position = self.position
        let particlePositionRange = CGVector(dx: self.size.width/2, dy: self.size.height/2)
        let texture = SKTexture(imageNamed: "spark")
        
        var action = SKAction.run {
            let emitterNode = SKEmitterNode()
            emitterNode.particleTexture = texture
            emitterNode.particleSize = CGSize(width: 21, height: 21)
            emitterNode.numParticlesToEmit = 200
            emitterNode.particleBirthRate = 12000
            emitterNode.particleLifetime = 1
            emitterNode.particleAlpha = 1
            emitterNode.particleAlphaSpeed = -1
            emitterNode.particleScaleSpeed = -1
            emitterNode.particleColorBlendFactor = 1
            emitterNode.particleColor = GameColors.explosion
            emitterNode.particleBlendMode = .add
            
            emitterNode.particleZPosition = particleZPosition
            
            emitterNode.particleSpeed = 500
            emitterNode.particleSpeedRange = 1000
            emitterNode.emissionAngleRange = π * 2.0
            
            emitterNode.targetNode = targetNode
            emitterNode.position = position + CGPoint(
                x: CGFloat.random(min: -particlePositionRange.dx, max: particlePositionRange.dx),
                y: CGFloat.random(min: -particlePositionRange.dy, max: particlePositionRange.dy))
            targetNode.addChild(emitterNode)
            
            emitterNode.run(SKAction.removeFromParentAfterDelay(1))
            GameWorld.current()?.explosionSoundEffect?.play()
            GameWorld.current()?.shake()
        }
        
        var actions = [SKAction]()
        actions.append(action)
        
        for _ in  1..<10 {
            let delay: TimeInterval = Double(CGFloat.random(min: 0.1, max: 0.5))
            actions.append(SKAction.afterDelay(delay, performAction: action))
        }
        
        action = SKAction.run { [weak self] in
            self?.isHidden = true
            self?.healthBar?.isHidden = true
        }
        
        actions.append(action)
        
        self.run(SKAction.sequence(actions))
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
        
        let spriteNode = SKSpriteNode(imageNamed: "mothershipSlot", filteringMode: GameScene.defaultFilteringMode)
        spriteNode.position = position
        spriteNode.color = self.color
        spriteNode.colorBlendFactor = 1
        self.addChild(spriteNode)
        
        spaceship.position = self.convert(position, to: gameWorld)
        spaceship.startingPosition = spaceship.position
        
        spaceship.zRotation = self.zRotation
        spaceship.startingZPosition = spaceship.zRotation
        
        gameWorld.addChild(spaceship)
        
        spaceship.loadWeaponRangeShapeNode(gameWorld: gameWorld)
        spaceship.loadHealthBar(gameWorld: gameWorld)
        spaceship.loadLabelRespawn(gameWorld: gameWorld)
        spaceship.loadJetEffect(gameWorld: gameWorld)
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
    
    func setBitMasksToDeadMothership() {
        if let physicsBody = self.physicsBody {
            physicsBody.categoryBitMask = GameWorld.categoryBitMask.deadMothership.rawValue
            physicsBody.collisionBitMask = GameWorld.categoryBitMask.deadMothership.rawValue
            physicsBody.contactTestBitMask = GameWorld.categoryBitMask.deadMothership.rawValue
        }
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
    
    func updateMaxHealth(enemySpaceships: [Spaceship]) {
        var totalDamage = 0
        var spaceshipCount = 0
        for spaceship in self.spaceships + enemySpaceships {
            totalDamage = totalDamage + spaceship.damage
            spaceshipCount = spaceshipCount + 1
        }
        
        if spaceshipCount > 0 {
            self.maxHealth = Int((Float(totalDamage)/Float(spaceshipCount)) * 200)
            self.health = self.maxHealth
        }
    }
    
    func endBattle() {
        for spaceship in self.spaceships {
            spaceship.destination = nil
            spaceship.targetNode = nil
            spaceship.canRespawn = false
        }
    }

}
