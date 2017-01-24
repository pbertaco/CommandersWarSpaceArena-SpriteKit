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
    
    var spaceships = [Spaceship]()

    init(team: team) {
        
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
            break
        }
        
        self.color = color
        self.colorBlendFactor = 1
        
        self.loadPhysics(rectangleOf: self.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSpaceship(spaceship: Spaceship, gameWorld: GameWorld, i: Int) {
        switch i {
        case 0:
            spaceship.position = self.convert(CGPoint(x: -129, y: 0), to: gameWorld)
            break
        case 1:
            spaceship.position = self.convert(CGPoint(x: -43, y: 0), to: gameWorld)
            break
        case 2:
            spaceship.position = self.convert(CGPoint(x: 43, y: 0), to: gameWorld)
            break
        case 3:
            spaceship.position = self.convert(CGPoint(x: 129, y: 0), to: gameWorld)
            break
        default:
            break
        }
        
        spaceship.startingPosition = spaceship.position
        spaceship.destination = spaceship.position
        
        spaceship.zRotation = self.zRotation
        spaceship.startingZPosition = spaceship.zRotation
        
        gameWorld.addChild(spaceship)
    }
    
    func loadSpaceships(gameWorld: GameWorld) {
        var i = 0
        for spaceship in self.spaceships {
            self.loadSpaceship(spaceship: spaceship, gameWorld: gameWorld, i: i)
            i += 1
        }
    }
    
    func loadPhysics(rectangleOf size: CGSize) {
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = GameWorld.categoryBitMask.mothership.rawValue
        physicsBody.collisionBitMask = GameWorld.collisionBitMask.mothership.rawValue
        physicsBody.contactTestBitMask = GameWorld.contactTestBitMask.mothership.rawValue
        
        self.physicsBody = physicsBody
    }
}
