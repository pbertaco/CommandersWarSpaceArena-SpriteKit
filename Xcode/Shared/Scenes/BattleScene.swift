//
//  BattleScene.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/18/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class BattleScene: GameScene {
    
    var gameWorld: GameWorld!
    var gameCamera: GameCamera!
    
    enum zPosition: CGFloat {
        case gameWorld = 0
        case hud = 100
    }
    
    let playerData = MemoryCard.sharedInstance.playerData!
    
    override func load() {
        super.load()
        
        self.backgroundColor = GameColors.backgroundColor
        
        self.gameWorld = GameWorld()
        self.gameWorld.zPosition = zPosition.gameWorld.rawValue
        self.addChild(self.gameWorld)
        self.physicsWorld.contactDelegate = self.gameWorld
        
        self.gameCamera = GameCamera()
        self.gameCamera.node = SKNode()
        self.gameWorld.addChild(self.gameCamera)
        self.gameWorld.addChild(self.gameCamera.node!)
        self.gameCamera.update()
        
        
        let mothership = Mothership(team: Mothership.team.blue)
        self.gameWorld.addChild(mothership)
        if let slots = (self.playerData.mothership?.slots as? Set<MothershipSlotData>)?.sorted(by: {
            return $0.index < $1.index
        }) {
            for slot in slots {
                if let spaceshipData = slot.spaceship {
                    let spaceship = Spaceship(spaceshipData: spaceshipData, loadPhysics: true)
                    mothership.spaceships.append(spaceship)
                }
            }
        }
        mothership.loadSpaceships(gameWorld: self.gameWorld)
        
        let botMothership = Mothership(team: Mothership.team.red)
        self.gameWorld.addChild(botMothership)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    override func didFinishUpdate() {
        super.didFinishUpdate()
        self.gameCamera.update()
    }
    
    override func touchDown(touch: UITouch) {
        super.touchDown(touch: touch)
    }
    
    override func touchMoved(touch: UITouch) {
        super.touchMoved(touch: touch)
    }
    
    override func touchUp(touch: UITouch) {
        super.touchUp(touch: touch)
    }
    
}
