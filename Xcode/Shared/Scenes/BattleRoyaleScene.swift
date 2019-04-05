//
//  BattleRoyaleScene.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 25/03/19.
//  Copyright © 2019 PabloHenri91. All rights reserved.
//

import SpriteKit

class BattleRoyaleScene: GameScene {

    weak var gameWorld: GameWorld!
    weak var gameCamera: GameCamera!
    
    enum zPosition: CGFloat {
        case gameWorld = 0
        case blackSpriteNode = 1000
        case boxBattleResult = 2000
        case boxUnlockSpaceship = 3000
    }
    
    enum state: String {
        
        case loading
        
        case battle
        
        case battleEnd
        case battleEndInterval
        case showBattleResult
        
        case mainMenu
        case credits
    }
    
    var state: state = .loading
    var nextState: state = .loading
    
    weak var spaceship: Spaceship!
    
    var lastBotUpdate: Double = 0
    
    var battleEndTime: Double = 0
    
    var battleBeginTime: Double = 0
    var maxBattleDuration: Double = 60 * 3
    
    override func load() {
        super.load()
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        self.backgroundColor = GameColors.backgroundColor
        
        let gameWorld = GameWorld(loadBorder: false)
        self.addChild(gameWorld)
        self.physicsWorld.contactDelegate = gameWorld
        
        let spaceship = Spaceship(level: 1 + Int.random(10), rarity: Spaceship.randomRarity(), loadPhysics: true, team: .blue)
        spaceship.setBitMasksToSpaceship()
        spaceship.physicsBody?.isDynamic = true
        
        gameWorld.addChild(spaceship)
        
        spaceship.loadHealthBar(gameWorld: gameWorld)
        spaceship.loadJetEffect(gameWorld: gameWorld)
        spaceship.loadWeaponRangeShapeNode(gameWorld: gameWorld)
        
        spaceship.updateHealthBarPosition()
        
        let gameCamera = GameCamera()
        spaceship.addChild(gameCamera)
        gameCamera.update()
        
        self.gameCamera = gameCamera
        self.spaceship = spaceship
        self.gameWorld = gameWorld
        
        Spaceship.setSelected(spaceship: spaceship)
        
        self.nextState = .battle
    }
    
    override func updateSize() {
        super.updateSize()
        self.gameCamera.update()
        self.gameWorld.updateSize()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if self.state == self.nextState {
            
            switch self.state {
                
            case .loading:
                break
                
            case .battle:
                self.spaceship.update()
                break
                
            case .battleEnd:
                self.spaceship.update()
                break
                
            case .battleEndInterval:
                self.spaceship.update()
                
                if currentTime - self.battleEndTime > 2 {
                    self.nextState = .showBattleResult
                }
                break
                
            case .showBattleResult:
                self.spaceship.update()
                break
                
            case .mainMenu:
                self.spaceship.update()
                break
            case .credits:
                self.spaceship.update()
                break
            }
        } else {
            self.state = self.nextState
            
            switch self.nextState {
                
            case .loading:
                break
                
            case .battle:
                if self.battleBeginTime == 0 {
                    Metrics.battleStart()
                    self.battleBeginTime = currentTime
                }
                break
                
            case .battleEnd:
                self.spaceship.update()
                self.battleEndTime = currentTime
                self.nextState = .battleEndInterval
                break
                
            case .battleEndInterval:
                break
                
            case .showBattleResult:
                
                break
                
            case .mainMenu:
                Music.sharedInstance.stop()
                let scene = MainMenuScene()
                self.view?.presentScene(scene, transition: GameScene.defaultTransition)
                break
            case .credits:
                self.view?.presentScene(CreditsScene(), transition: GameScene.defaultTransition)
                break
            }
        }
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        Shot.update()
        
        self.spaceship.didSimulatePhysics()
        
        self.gameCamera?.node?.position = self.spaceship.position
        self.gameCamera?.update(useLerp: true)
    }
    
    override func touchDown(touch: UITouch) {
        super.touchDown(touch: touch)
        
        switch self.state {
            
        case .loading:
            break
            
        case .battle:
            
            if let nearestSpaceship = self.nearestSpaceship(spaceships: [self.spaceship], touch: touch) {
                switch nearestSpaceship.team {
                case .blue:
                    nearestSpaceship.touchUp(touch: touch)
                    break
                case .red, .none:
                    Spaceship.selectedSpaceship?.setTarget(spaceship: nearestSpaceship)
                    break
                }
                return
            }
            
            Spaceship.selectedSpaceship?.touchUp(touch: touch)
            
            break
            
        case .battleEnd:
            break
            
        case .battleEndInterval:
            break
            
        case .showBattleResult:
            break
            
        case .mainMenu:
            break
        case .credits:
            break
        }
    }
    
    override func touchMoved(touch: UITouch) {
        super.touchMoved(touch: touch)
        
        switch self.state {
            
        case .loading:
            break
            
        case .battle:
            
            Spaceship.selectedSpaceship?.touchUp(touch: touch)
            
            break
            
        case .battleEnd:
            break
            
        case .battleEndInterval:
            break
            
        case .showBattleResult:
            break
            
        case .mainMenu:
            break
        case .credits:
            break
        }
    }
    
    override func touchUp(touch: UITouch) {
        super.touchUp(touch: touch)
        
        switch self.state {
            
        case .loading:
            break
            
        case .battle:
            
            if let nearestSpaceship = self.nearestSpaceship(spaceships: [self.spaceship], touch: touch) {
                switch nearestSpaceship.team {
                case .blue:
                    if (nearestSpaceship.position - nearestSpaceship.startingPosition).lengthSquared() > 4 {
                        nearestSpaceship.touchUp(touch: touch)
                    } else {
                        nearestSpaceship.physicsBody?.isDynamic = true
                        nearestSpaceship.retreating = false
                    }
                    break
                case .red, .none:
                    Spaceship.selectedSpaceship?.setTarget(spaceship: nearestSpaceship)
                    break
                }
                return
            }
            
            Spaceship.selectedSpaceship?.touchUp(touch: touch)
            
            break
            
        case .battleEnd:
            break
            
        case .battleEndInterval:
            break
            
        case .showBattleResult:
            break
            
        case .mainMenu:
            break
        case .credits:
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
