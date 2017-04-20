//
//  ChooseMissionScene.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 2/9/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class ChooseMissionScene: GameScene {
    
    enum state: String {
        case chooseMission
        case mainMenu
        case battle
    }
    
    var state: state = .chooseMission
    var nextState: state = .chooseMission
    
    weak var stars: Stars!

    override func load() {
        super.load()
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        self.backgroundColor = GameColors.backgroundColor
        
        let stars = Stars()
        stars.position.x = stars.position.x + GameScene.currentSize.width/2
        stars.position.y = stars.position.y - GameScene.currentSize.height/2
        self.addChild(stars)
        self.stars = stars
        
        let buttonBack = Button(imageNamed: "button_55x55", x: 8, y: 604, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonBack.setIcon(imageNamed: "Back")
        buttonBack.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonBack)
        buttonBack.addHandler { [weak self] in
            self?.nextState = .mainMenu
        }
        
        var missionCells = [MissionCell]()
        
        for i in 0..<Mission.types.count {
            
            var status = MissionCell.status.locked
            
            if Int16(i) < playerData.maxBotLevel {
                status = .completed
            } else {
                if Int16(i) == playerData.maxBotLevel {
                    status = .available
                }
            }
            
            missionCells.append(MissionCell(missionIndex: i, status: status, recommended: Int16(i) == playerData.botLevel, buttonPlayHandler: { [weak self] in
                self?.nextState = .battle
            }))
        }
        
        let scrollNode = ScrollNode(cells: missionCells, spacing: 8, scrollDirection: .vertical, x: 71, y: 110, horizontalAlignment: .center, verticalAlignment: .center)
        
        self.addChild(scrollNode)
        
        let x: Int = Int(GameScene.currentSize.width) + 4
        let control = Control(imageNamed: "box_\(x)x89", x: 375/2, y: -2, horizontalAlignment: .center)
        control.control?.anchorPoint.x = 0.5
        self.addChild(control)
        
        let controlPremiumPoints = ControlPremiumPoints(x: 8, y: 15)
        controlPremiumPoints.setLabelPremiumPointsText(premiumPoints: playerData.premiumPoints)
        self.addChild(controlPremiumPoints)
        
        let controlPoints = ControlPoints(x: 223, y: 15, horizontalAlignment: .right)
        controlPoints.setLabelPointsText(points: playerData.points)
        self.addChild(controlPoints)
        
        if playerData.botLevel > 0 {
            for _ in 0..<Int(playerData.botLevel) {
                scrollNode.forward()
            }
        }
    }
    
    override func updateSize() {
        super.updateSize()
        self.stars.updateSize()
        self.stars.position.x = self.stars.position.x + GameScene.currentSize.width/2
        self.stars.position.y = self.stars.position.y - GameScene.currentSize.height/2
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if self.state == self.nextState {
            
            switch self.state {
                
            case .chooseMission:
                break
                
            case .mainMenu:
                break
                
            case .battle:
                break
            }
        } else {
            self.state = self.nextState
            
            switch self.nextState {
                
            case .chooseMission:
                break
                
            case .mainMenu:
                self.view?.presentScene(MainMenuScene(), transition: GameScene.defaultTransition)
                break
            case .battle:
                Music.sharedInstance.stop()
                self.view?.presentScene(BattleScene(), transition: GameScene.defaultTransition)
                break
            }
        }
    }
    
    override func fpsCountUpdate(fps: Int) {
        
        if fps >= 30 {
            if self.needMusic {
                self.needMusic = false
                Music.sharedInstance.playMusic(withType: .menu)
            }
        }
    }
}
