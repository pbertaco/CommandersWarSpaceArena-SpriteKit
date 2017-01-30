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
        
        let texture = SKTexture(imageNamed: "shot")
        
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        self.color = color
        self.colorBlendFactor = 1
        self.blendMode = .add
        
        self.damage = shooter.damage
        self.rangeSquared = shooter.weaponRange * shooter.weaponRange
        self.startingPosition = shooter.position
        
        self.position = shooter.position
        self.zRotation = shooter.zRotation + CGFloat.random(min: -0.1, max: 0.1)
        
        self.loadPhysics(shooter: shooter)
        
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
        if self.position.distanceSquaredTo(self.startingPosition) > self.rangeSquared {
            self.removeFromParent()
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
    
    override func removeFromParent() {
        Shot.set.remove(self)
        self.shooter?.canShot = true
        super.removeFromParent()
    }
    
}
