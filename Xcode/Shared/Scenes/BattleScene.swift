//
//  BattleScene.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/18/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class BattleScene: GameScene {
    
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
    }
    
    var state: state = .loading
    var nextState: state = .loading
    
    weak var mothership: Mothership!
    weak var botMothership: Mothership!
    
    
    var lastBotUpdate: Double = 0
    
    var battleEndTime: Double = 0
    
    var battleBeginTime: Double = 0
    
    override func load() {
        super.load()
        
        Music.sharedInstance.playMusic(withType: .battle)
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        self.backgroundColor = GameColors.backgroundColor
        
        let gameWorld = GameWorld()
        self.addChild(gameWorld)
        self.physicsWorld.contactDelegate = gameWorld
        
        let gameCamera = GameCamera()
        let gameCameraNode = SKNode()
        gameCamera.node = gameCameraNode
        gameWorld.addChild(gameCamera)
        gameWorld.addChild(gameCameraNode)
        gameCamera.update()
        
        
        let mothership = Mothership(team: Mothership.team.blue)
        mothership.loadHealthBar(gameWorld: gameWorld)
        gameWorld.addChild(mothership)
        if let slots = (playerData.mothership?.slots as? Set<MothershipSlotData>)?.sorted(by: {
            return $0.index < $1.index
        }) {
            for slot in slots {
                if let spaceshipData = slot.spaceship {
                    let spaceship = Spaceship(spaceshipData: spaceshipData, loadPhysics: true)
                    mothership.spaceships.append(spaceship)
                }
            }
        }
        mothership.loadSpaceships(gameWorld: gameWorld)
        
        let botMothership = Mothership(team: Mothership.team.red)
        botMothership.loadHealthBar(gameWorld: gameWorld)
        gameWorld.addChild(botMothership)
        
        let mission = Mission.types[Int(playerData.botLevel)]
        
        for rarity in mission.rarities {
            botMothership.spaceships.append(Spaceship(
                level: (mission.level + Int.random(min: -2, max: 0)).clamped(1...10),
                rarity: rarity,
                loadPhysics: true, team: .red))
        }
        botMothership.loadSpaceships(gameWorld: gameWorld)
        
        mothership.updateMaxHealth(enemySpaceships: botMothership.spaceships)
        botMothership.updateMaxHealth(enemySpaceships: mothership.spaceships)
        
        mothership.update()
        botMothership.update()
        
        self.nextState = .battle
        
        self.gameWorld = gameWorld
        self.gameCamera = gameCamera
        self.mothership = mothership
        self.botMothership = botMothership
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
                
                if self.mothership.health <= 0 || self.botMothership.health <= 0 {
                    self.nextState = .battleEnd
                }
                
                self.mothership.update(enemyMothership: self.botMothership, enemySpaceships: self.botMothership.spaceships)
                self.botMothership.update(enemyMothership: self.mothership, enemySpaceships: self.mothership.spaceships)
                
                if currentTime - self.lastBotUpdate > 1 {
                    
                    self.lastBotUpdate = currentTime
                    
                    let aliveBotSpaceships = self.botMothership.spaceships.filter({
                        
                        if let destination = $0.destination {
                            if destination == $0.startingPosition {
                                return false
                            }
                        }
                        
                        if ($0.position - $0.startingPosition).lengthSquared() < 4 {
                            return $0.health >= $0.maxHealth
                        } else {
                            return $0.health > 0
                        }
                    })
                    
                    if aliveBotSpaceships.count > 0 {
                        
                        let botSpaceship = aliveBotSpaceships[Int.random(aliveBotSpaceships.count)]
                        
                        let aliveSpaceships = self.mothership.spaceships.filter({ (spaceship: Spaceship) -> Bool in
                            if spaceship.health > 0 {
                                if let targetMothership = spaceship.targetNode as? Mothership {
                                    let point = CGPoint(x: spaceship.position.x, y: targetMothership.position.y)
                                    if spaceship.position.distanceTo(point) <= spaceship.weaponRange + 89/2 {
                                        return true
                                    }
                                }
                            }
                            return false
                        }).sorted(by: { $0.health < $1.health })
                        
                        if aliveSpaceships.count > 0 {
                            botSpaceship.setTarget(spaceship: aliveSpaceships[0])
                        } else {
                            if botSpaceship.targetNode != nil {
                                if botSpaceship.health < botSpaceship.maxHealth/2 {
                                    botSpaceship.retreat()
                                }
                            } else {
                                if let physicsBody = botSpaceship.physicsBody {
                                    if physicsBody.isDynamic || botSpaceship.health == botSpaceship.maxHealth {
                                        if botSpaceship.health < botSpaceship.maxHealth {
                                            botSpaceship.retreat()
                                        } else {
                                            let x = Int.random(min: -55/2, max: 55/2)
                                            let y = Int.random(min: -89, max: -89/2)
                                            let point = botSpaceship.position + CGPoint(x: x, y: y)
                                            if self.mothership.contains(point) {
                                                botSpaceship.setTarget(mothership: self.mothership)
                                            } else {
                                                botSpaceship.physicsBody?.isDynamic = true
                                                botSpaceship.destination = point
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                break
                
            case .battleEnd:
                self.mothership.update()
                self.botMothership.update()
                break
                
            case .battleEndInterval:
                self.mothership.update()
                self.botMothership.update()
                
                if currentTime - self.battleEndTime > 2 {
                    self.nextState = .showBattleResult
                }
                break
                
            case .showBattleResult:
                self.mothership.update()
                self.botMothership.update()
                break
                
            case .mainMenu:
                self.mothership.update()
                self.botMothership.update()
                break
            }
        } else {
            self.state = self.nextState
            
            switch self.nextState {
                
            case .loading:
                break
                
            case .battle:
                if self.battleBeginTime == 0 {
                    self.battleBeginTime = currentTime
                }
                break
                
            case .battleEnd:
                self.mothership.endBattle()
                self.botMothership.endBattle()
                self.battleEndTime = currentTime
                self.nextState = .battleEndInterval
                break
                
            case .battleEndInterval:
                break
                
            case .showBattleResult:
                
                let boxBattleResult = BoxBattleResult(mothership: self.mothership, botMothership: self.botMothership)
                boxBattleResult.zPosition = zPosition.boxBattleResult.rawValue
                self.blackSpriteNode.isHidden = false
                self.blackSpriteNode.zPosition = zPosition.blackSpriteNode.rawValue
                self.addChild(boxBattleResult)
                
                boxBattleResult.buttonOK.addHandler { [weak self, weak boxBattleResult] in
                    guard let this = self else { return }
                    
                    if this.mothership.health > 0 {
                        if let rarity = Spaceship.randomRarity() {
                            boxBattleResult?.removeFromParent()
                            let boxUnlockSpaceship = BoxUnlockSpaceship(rarity: rarity)
                            boxUnlockSpaceship.zPosition = BattleScene.zPosition.boxUnlockSpaceship.rawValue
                            this.addChild(boxUnlockSpaceship)
                            
                            boxUnlockSpaceship.buttonIgnore?.addHandler {
                                this.nextState = .mainMenu
                            }
                            
                            boxUnlockSpaceship.buttonUnlock?.addHandler {
                                this.afterDelay(3, runBlock: {
                                    this.nextState = .mainMenu
                                })
                            }
                            
                        } else {
                            this.nextState = .mainMenu
                        }
                    } else {
                        this.nextState = .mainMenu
                    }
                }
                
                if self.botMothership.health <= 0 && self.mothership.health <= 0 {
                    
                } else {
                    if self.botMothership.health <= 0 {
                        Metrics.win()
                        if self.battleEndTime - self.battleBeginTime < 60 * 3 {
                            self.updateBotOnWin()
                        } else {
                            self.updateBotOnLose()
                        }
                    } else {
                        Metrics.lose()
                        if self.battleEndTime - self.battleBeginTime < 60 * 3 {
                            self.updateBotOnLose()
                        } else {
                            self.updateBotOnLose()
                            self.updateBotOnLose()
                        }
                    }
                }
                break
                
            case .mainMenu:
                self.view?.presentScene(MainMenuScene(), transition: GameScene.defaultTransition)
                break
            }
        }
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        Shot.update()
        
        self.mothership.didSimulatePhysics()
        self.botMothership.didSimulatePhysics()
        
    }
    
    override func touchDown(touch: UITouch) {
        super.touchDown(touch: touch)
        
        switch self.state {
            
        case .loading:
            break
            
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
                case .red, .none:
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
            
        case .battleEnd:
            break
            
        case .battleEndInterval:
            break
            
        case .showBattleResult:
            break
            
        case .mainMenu:
            break
        }
    }
    
    override func touchMoved(touch: UITouch) {
        super.touchMoved(touch: touch)
        
        switch self.state {
            
        case .loading:
            break
            
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
            
        case .battleEnd:
            break
            
        case .battleEndInterval:
            break
            
        case .showBattleResult:
            break
            
        case .mainMenu:
            break
        }
    }
    
    override func touchUp(touch: UITouch) {
        super.touchUp(touch: touch)
        
        switch self.state {
            
        case .loading:
            break
            
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
                    if (nearestSpaceship.position - nearestSpaceship.startingPosition).lengthSquared() > 4 {
                        nearestSpaceship.touchUp(touch: touch)
                    } else {
                        nearestSpaceship.physicsBody?.isDynamic = true
                    }
                    break
                case .red, .none:
                    Spaceship.selectedSpaceship?.setTarget(spaceship: nearestSpaceship)
                    break
                }
                return
            }
            
            if let parent = self.mothership.parent {
                if self.mothership.contains(touch.location(in: parent)) {
                    if let selectedSpaceship = Spaceship.selectedSpaceship {
                        if selectedSpaceship.position.distanceTo(selectedSpaceship.startingPosition) > 4 {
                            selectedSpaceship.retreat()
                        }
                    }
                    return
                }
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
    
    func updateBotOnWin() {
        let playerData = MemoryCard.sharedInstance.playerData!
        if playerData.botLevel < Int16(Mission.types.count - 1) {
            playerData.botLevel = playerData.botLevel + 1
        }
        
        if playerData.maxBotLevel < playerData.botLevel {
            playerData.maxBotLevel = playerData.botLevel
        }
    }
    
    func updateBotOnLose() {
        let playerData = MemoryCard.sharedInstance.playerData!
        if playerData.botLevel > 0 {
            playerData.botLevel = playerData.botLevel - 1
        }
    }
    
}
