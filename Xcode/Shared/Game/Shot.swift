//
//  Shot.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/26/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class Shot: SKSpriteNode {
    
    static var set = Set<Shot>()
    
    weak var shooter: Spaceship?
    
    var damage = 1
    var rangeSquared: CGFloat = 0
    var startingPosition = CGPoint.zero
    
    weak var emitterNode: SKEmitterNode?
    
    init(shooter: Spaceship) {
        
        self.shooter = shooter
        
        var color: SKColor = .white
        
        switch shooter.team {
        case .blue:
            color = GameColors.blueTeam
            break
        case .red:
            color = GameColors.redTeam
            break
        }
        
        let texture = SKTexture(imageNamed: "spark", filteringMode: GameScene.defaultFilteringMode)
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.color = color
        self.colorBlendFactor = 1
        self.blendMode = .add
        
        self.damage = shooter.damage
        self.rangeSquared = shooter.weaponRange * shooter.weaponRange
        self.startingPosition = shooter.position
        
        self.position = shooter.position
        self.zRotation = shooter.zRotation + CGFloat.random(min: -0.1, max: 0.1)
        
        self.loadPhysics(shooter: shooter)
        
        self.loadEmitterNode(targetNode: shooter.parent, color: color)
        
        Shot.set.insert(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func update() {
        for shot in Shot.set {
            shot.update()
        }
    }
    
    func update() {
        if (self.position - self.startingPosition).lengthSquared() > self.rangeSquared {
            self.removeFromParent()
        } else {
            if let emitterNode = self.emitterNode {
                emitterNode.position = self.position
            }
        }
    }
    
    func loadPhysics(shooter: Spaceship) {
        
        self.zPosition = GameWorld.zPosition.shot.rawValue
        
        let physicsBody = SKPhysicsBody(rectangleOf: self.size)
        
        physicsBody.categoryBitMask = GameWorld.categoryBitMask.spaceshipShot.rawValue
        physicsBody.collisionBitMask = GameWorld.collisionBitMask.spaceshipShot.rawValue
        physicsBody.contactTestBitMask = GameWorld.contactTestBitMask.spaceshipShot.rawValue
        
        physicsBody.linearDamping = 0
        physicsBody.angularDamping = 0
        
        let speed: CGFloat = 3300/5
        
        physicsBody.velocity = CGVector(dx: -sin(self.zRotation) * speed, dy: cos(self.zRotation) * speed)
        
        if let shooterPhysicsBody = self.shooter?.physicsBody {
            physicsBody.velocity = physicsBody.velocity + shooterPhysicsBody.velocity
        }
        
        self.physicsBody = physicsBody
    }
    
    func setBitMasksToShot() {
        if let physicsBody = self.physicsBody {
            physicsBody.categoryBitMask = GameWorld.categoryBitMask.shot.rawValue
            physicsBody.collisionBitMask = GameWorld.collisionBitMask.shot.rawValue
            physicsBody.contactTestBitMask = GameWorld.contactTestBitMask.shot.rawValue
        }
    }
    
    func loadEmitterNode(targetNode: SKNode?, color: SKColor) {
        let emitterNode = SKEmitterNode()
        let texture = SKTexture(imageNamed: "spark")
        emitterNode.particleTexture = texture
        emitterNode.particleSize = CGSize(width: 8, height: 8)
        emitterNode.particleBirthRate = 240
        emitterNode.particleLifetime = 1
        emitterNode.particleAlpha = 0.25
        emitterNode.particleAlphaSpeed = -1
        emitterNode.particleScaleSpeed = -1
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleColor = color
        emitterNode.particleBlendMode = .add
        
        emitterNode.particleZPosition = self.zPosition - 1
        
        emitterNode.particlePositionRange = CGVector(dx: 8, dy: 8)
        
        emitterNode.targetNode = targetNode
        targetNode?.addChild(emitterNode)
        
        self.emitterNode = emitterNode
        
        self.update()
    }
    
    override func removeFromParent() {
        Shot.set.remove(self)
        self.shooter?.canShot = true
        super.removeFromParent()
        
        self.emitterNode?.particleBirthRate = 0
        self.emitterNode?.run(SKAction.removeFromParentAfterDelay(1))
    }
    
}
