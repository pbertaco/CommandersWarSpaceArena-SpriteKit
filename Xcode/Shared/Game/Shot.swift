//
//  Shot.swift
//  CommandersWar
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
    
    var element: Element
    
    init(shooter: Spaceship, element: Element) {
        
        self.shooter = shooter
        self.element = element
        
        let color: SKColor = element.color
        
        let texture = SKTexture(imageNamed: "spark", filteringMode: GameScene.defaultFilteringMode)
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.color = color
        self.colorBlendFactor = 1
        self.blendMode = .add
        
        self.damage = shooter.damage
        self.rangeSquared = shooter.weaponRange * shooter.weaponRange
        self.startingPosition = shooter.position
        
        self.position = shooter.position
        self.zRotation = shooter.zRotation// + CGFloat.random(min: -0.2, max: 0.2)
        
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
        emitterNode.particleBirthRate = 60
        emitterNode.particleLifetime = 1
        emitterNode.particleAlpha = 1
        emitterNode.particleAlphaSpeed = -4
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
    
    func explosionEffect() {
        guard let targetNode = self.parent else { return }
        
        let emitterNode = SKEmitterNode()
        let texture = SKTexture(imageNamed: "spark")
        emitterNode.particleTexture = texture
        emitterNode.particleSize = CGSize(width: 5, height: 5)
        emitterNode.numParticlesToEmit = 5
        emitterNode.particleBirthRate = 1200
        emitterNode.particleLifetime = 1
        emitterNode.particleAlpha = 1
        emitterNode.particleAlphaSpeed = -1
        emitterNode.particleScaleSpeed = -1
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleColor = GameColors.explosion
        emitterNode.particleBlendMode = .add
        
        emitterNode.particleZPosition = GameWorld.zPosition.explosion.rawValue
        
        emitterNode.particleSpeed = 500/2
        emitterNode.particleSpeedRange = 1000/2
        emitterNode.emissionAngle = self.zRotation - π/2
        emitterNode.emissionAngleRange = π/2
        
        
        emitterNode.targetNode = targetNode
        emitterNode.position = self.position
        targetNode.addChild(emitterNode)
        
        emitterNode.run(SKAction.removeFromParentAfterDelay(1))
    }
    
    override func removeFromParent() {
        
        if self.damage <= 0 {
            self.explosionEffect()
        }
        
        Shot.set.remove(self)
        self.shooter?.canShot = true
        super.removeFromParent()
        
        self.emitterNode?.particleBirthRate = 0
        self.emitterNode?.run(SKAction.removeFromParentAfterDelay(1))
    }
    
}
