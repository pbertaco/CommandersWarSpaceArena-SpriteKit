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
    
    enum state: String {
        case battle
    }
    
    var state: state = .battle
    var nextState: state = .battle
    
    let playerData = MemoryCard.sharedInstance.playerData!
    
    var mothership: Mothership!
    var botMothership: Mothership!
    
    override func load() {
        super.load()
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
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
        
        
        self.mothership = Mothership(team: Mothership.team.blue)
        self.gameWorld.addChild(self.mothership)
        if let slots = (self.playerData.mothership?.slots as? Set<MothershipSlotData>)?.sorted(by: {
            return $0.index < $1.index
        }) {
            for slot in slots {
                if let spaceshipData = slot.spaceship {
                    let spaceship = Spaceship(spaceshipData: spaceshipData, loadPhysics: true)
                    self.mothership.spaceships.append(spaceship)
                }
            }
        }
        self.mothership.loadSpaceships(gameWorld: self.gameWorld)
        
        self.botMothership = Mothership(team: Mothership.team.red)
        self.gameWorld.addChild(self.botMothership)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        self.mothership.update()
        self.botMothership.update()
    }
    
    override func didFinishUpdate() {
        super.didFinishUpdate()
        self.gameCamera.update()
    }
    
    override func touchDown(touch: UITouch) {
        super.touchDown(touch: touch)
        
        switch self.state {
        case .battle:
            
            if let parent = self.botMothership.parent {
                if self.botMothership.contains(touch.location(in: parent)) {
                    Spaceship.selectedSpaceship?.setTarget(mothership: self.botMothership)
                    return
                }
            }
            
            if let nearestSpaceship = self.nearestSpaceship(spaceships: self.mothership.spaceships + self.botMothership.spaceships, touch: touch) {
                switch nearestSpaceship.team {
                case .blue:
                    nearestSpaceship.touchUp(touch: touch)
                    break
                case .red:
                    Spaceship.selectedSpaceship?.setTarget(spaceship: nearestSpaceship)
                    break
                }
                return
            }
            
            if let parent = self.mothership.parent {
                if self.mothership.contains(touch.location(in: parent)) {
                    Spaceship.selectedSpaceship?.retreat()
                    return
                }
            }
            
            Spaceship.selectedSpaceship?.touchUp(touch: touch)
            
            break
        }
    }
    
    override func touchMoved(touch: UITouch) {
        super.touchMoved(touch: touch)
        
        switch self.state {
        case .battle:
            
            if let parent = self.botMothership.parent {
                if self.botMothership.contains(touch.location(in: parent)) {
                    return
                }
            }
            
            if let parent = self.mothership.parent {
                if self.mothership.contains(touch.location(in: parent)) {
                    return
                }
            }
            
            Spaceship.selectedSpaceship?.touchUp(touch: touch)
            
            break
        }
    }
    
    override func touchUp(touch: UITouch) {
        super.touchUp(touch: touch)
        
        switch self.state {
        case .battle:
            
            if let parent = self.botMothership.parent {
                if self.botMothership.contains(touch.location(in: parent)) {
                    Spaceship.selectedSpaceship?.setTarget(mothership: self.botMothership)
                    return
                }
            }
            
            if let nearestSpaceship = self.nearestSpaceship(spaceships: self.mothership.spaceships + self.botMothership.spaceships, touch: touch) {
                switch nearestSpaceship.team {
                case .blue:
                    if nearestSpaceship.position.distanceTo(nearestSpaceship.startingPosition) > 2 {
                        nearestSpaceship.touchUp(touch: touch)
                    }
                    break
                case .red:
                    Spaceship.selectedSpaceship?.setTarget(spaceship: nearestSpaceship)
                    break
                }
                return
            }
            
            if let parent = self.mothership.parent {
                if self.mothership.contains(touch.location(in: parent)) {
                    if let selectedSpaceship = Spaceship.selectedSpaceship {
                        if selectedSpaceship.position.distanceTo(selectedSpaceship.startingPosition) > 2 {
                            selectedSpaceship.retreat()
                        }
                    }
                    return
                }
            }
            
            Spaceship.selectedSpaceship?.touchUp(touch: touch)
            
            break
        }
    }
    
    func nearestSpaceship(spaceships: [Spaceship], touch: UITouch) -> Spaceship? {
        
        var spaceshipsAtPoint = [Spaceship]()
        
        for spaceship in spaceships {
            if spaceship.health > 0 {
                if let parent = spaceship.parent {
                    if spaceship.contains(touch.location(in: parent)) {
                        spaceshipsAtPoint.append(spaceship)
                    }
                }
            }
        }
        
        var nearestSpaceship: Spaceship? = nil
        
        for spaceship in spaceshipsAtPoint {
            if let parent = spaceship.parent {
                if nearestSpaceship != nil { 
                    let touchPosition = touch.location(in: parent)
                    if touchPosition.distanceTo(spaceship.position) < touchPosition.distanceTo(nearestSpaceship!.position) {
                        nearestSpaceship = spaceship
                    }
                } else {
                    nearestSpaceship = spaceship
                }
            }
        }
        
        return nearestSpaceship
    }
    
}
