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
        case credits
    }
    
    var state: state = .loading
    var nextState: state = .loading
    
    weak var mothership: Mothership!
    weak var botMothership: Mothership!
    
    
    var lastBotUpdate: Double = 0
    
    var battleEndTime: Double = 0
    
    var battleBeginTime: Double = 0
    var maxBattleDuration: Double = 60 * 3
    
    override func load() {
        super.load()
        
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
        
        for rarity in mission.rarities.shuffled() {
            var color: SKColor?
            if Int.random(Mission.types.count) > Int(playerData.botLevel) {
                color = mission.color
            }
            botMothership.spaceships.append(Spaceship(
                level: (mission.level + Int.random(min: -2, max: 0)).clamped(1...10),
                rarity: rarity,
                loadPhysics: true, team: .red, color: color))
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
                    
                    var health = 0
                    for spaceship in self.mothership.spaceships {
                        health = health + spaceship.health
                    }
                    if health <= 0 || currentTime - self.battleBeginTime > self.maxBattleDuration {
                        self.mothership.health = self.mothership.health - (self.mothership.maxHealth/10)
                        self.mothership.updateHealthBar(health: self.mothership.health, maxHealth: self.mothership.maxHealth)
                        if self.mothership.health <= 0 {
                            self.mothership.die(shooter: nil)
                        } else {
                            self.run(self.mothership.explosionAction())
                        }
                    }
                    
                    health = 0
                    for spaceship in self.botMothership.spaceships {
                        health = health + spaceship.health
                    }
                    if health <= 0 || currentTime - self.battleBeginTime > self.maxBattleDuration {
                        self.botMothership.health = self.botMothership.health - (self.botMothership.maxHealth/10)
                        self.botMothership.updateHealthBar(health: self.botMothership.health, maxHealth: self.botMothership.maxHealth)
                        if self.botMothership.health <= 0 {
                            self.botMothership.die(shooter: nil)
                        } else {
                            self.run(self.botMothership.explosionAction())
                        }
                    }
                    
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
                            return spaceship.health > 0
                        }).sorted(by: { (a: Spaceship, b: Spaceship) -> Bool in
                            let x = a.health * (a.element.weakness == botSpaceship.element.element ? 4 : 1) / (a.element.strength == botSpaceship.element.element ? 4 : 1)
                            let y = b.health * (b.element.weakness == botSpaceship.element.element ? 4 : 1) / (b.element.strength == botSpaceship.element.element ? 4 : 1)
                            return x < y
                        })
                        
                        let targets = aliveSpaceships.filter({ (spaceship: Spaceship) -> Bool in
                            if let targetMothership = spaceship.targetNode as? Mothership {
                                let point = CGPoint(x: spaceship.position.x, y: targetMothership.position.y)
                                if spaceship.position.distanceTo(point) <= spaceship.weaponRange + 89/2 {
                                    return true
                                }
                            }
                            return false
                        })
                        
                        if targets.count > 0 {
                            botSpaceship.setTarget(spaceship: targets.first!)
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
                                            
                                            let targets = aliveSpaceships.filter({ (spaceship: Spaceship) -> Bool in
                                                if (spaceship.targetNode as? Spaceship) != nil {
                                                    return spaceship.element.weakness == botSpaceship.element.element
                                                }
                                                return false
                                            })
                                            
                                            if targets.count > 0 {
                                                botSpaceship.setTarget(spaceship: targets.first!)
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
            case .credits:
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
                    Metrics.battleStart()
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
                
                boxBattleResult.buttonOK.addHandler { [weak self] in
                    guard let `self` = self else { return }
                    
                    let playerData = MemoryCard.sharedInstance.playerData!
                    
                    if playerData.botLevel >= Int16(Mission.types.count - 1) {
                        self.nextState = .credits
                    } else {
                        self.nextState = .mainMenu
                    }
                }
                
                if self.botMothership.health <= 0 && self.mothership.health <= 0 {
                    
                } else {
                    if self.botMothership.health <= 0 {
                        
                        var deaths = 0
                        for i in self.mothership.spaceships {
                            deaths = deaths + i.deaths
                        }
                        if deaths <= 0 {
                            self.updateBotOnWin()
                        }
                        
                        Metrics.win(score: boxBattleResult.score)
                        if self.battleEndTime - self.battleBeginTime <= 60 * 3 {
                            self.updateBotOnWin()
                            if self.battleEndTime - self.battleBeginTime <= 60 * 2 {
                                self.updateBotOnWin()
                                if self.battleEndTime - self.battleBeginTime <= 60 * 1 {
                                    self.updateBotOnWin()
                                }
                            }
                        } else {
                            self.updateBotOnLose()
                        }
                    } else {
                        Metrics.lose(score: boxBattleResult.score)
                        if self.battleEndTime - self.battleBeginTime <= 60 * 3 {
                            self.updateBotOnLose()
                        } else {
                            self.updateBotOnLose()
                            self.updateBotOnLose()
                        }
                    }
                }
                break
                
            case .mainMenu:
                Music.sharedInstance.stop()
                
                let scene = MainMenuScene()
                
                if self.mothership.health > 0 {
                    let playerData = MemoryCard.sharedInstance.playerData!
                    
                    var rarity: Spaceship.rarity = Spaceship.randomRarity()
                    if Int16(rarity.rawValue) > playerData.maxBotRarity {
                        rarity = Spaceship.rarity(rawValue: Int(playerData.maxBotRarity))!
                    }
                    let spaceship = self.botMothership.spaceships[Int.random(self.botMothership.spaceships.count)]
                    spaceship.level = Int.random(spaceship.battleStartLevel).clamped(1...10)
                    let boxUnlockSpaceship = BoxUnlockSpaceship(spaceship: spaceship.createCopy())
                    boxUnlockSpaceship.zPosition = MainMenuScene.zPosition.box.rawValue
                    scene.addChild(boxUnlockSpaceship)
                    
                    scene.blackSpriteNode.isHidden = false
                    scene.blackSpriteNode.zPosition = MainMenuScene.zPosition.blackSpriteNode.rawValue
                    
                    boxUnlockSpaceship.buttonUnlockWithPoints?.addHandler { [weak scene] in
                        scene?.afterDelay(3, runBlock: { [weak scene] in
                            scene?.nextState = .hangar
                        })
                    }
                    
                    boxUnlockSpaceship.buttonUnlockWithPremiumPoints?.addHandler { [weak scene] in
                        scene?.afterDelay(3, runBlock: { [weak scene] in
                            scene?.nextState = .hangar
                        })
                    }
                    
                    scene.blackSpriteNode.addHandler { [weak scene, weak boxUnlockSpaceship] in
                        boxUnlockSpaceship?.removeFromParent()
                        scene?.blackSpriteNode.isHidden = true
                    }
                }
                
                self.view?.presentScene(scene, transition: GameScene.defaultTransition)
                break
            case .credits:
                self.view?.presentScene(CreditsScene(), transition: GameScene.defaultTransition)
                break
            }
        }
    }
    
    override func fpsCountUpdate(fps: Int) {
        
        if fps >= 30 {
            if self.needMusic {
                self.needMusic = false
                Music.sharedInstance.playMusic(withType: .battle)
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
                        nearestSpaceship.retreating = false
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
                            selectedSpaceship.retreating = true
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
    
    func updateBotOnWin() {
        let playerData = MemoryCard.sharedInstance.playerData!
        
        if playerData.botLevel >= Int16(Mission.types.count) {
            #if os(iOS)
                GameViewController.sharedInstance()?.save(achievementIdentifier: "masterOfTheGalaxy")
            #endif
        }
        
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
