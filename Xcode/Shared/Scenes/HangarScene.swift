//
//  HangarScene.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/30/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class HangarScene: GameScene {
    
    enum state: String {
        case hangar
        case mainMenu
    }
    
    var state: state = .hangar
    var nextState: state = .hangar
    
    let playerData = MemoryCard.sharedInstance.playerData!
    
    var scrollNode: ScrollNode!
    
    override func load() {
        super.load()
        
        self.backgroundColor = GameColors.backgroundColor
        
        let buttonBack = Button(imageNamed: "button55x55", x: 8, y: 604, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonBack.setIcon(imageNamed: "Back")
        buttonBack.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonBack)
        buttonBack.touchUpEvent = { [weak self] in
            self?.nextState = .mainMenu
        }
        
        
        var cells = [SpaceshipHangarCell]()
        
        if let playerDataSpaceships = (self.playerData.spaceships as? Set<SpaceshipData>)?.sorted(by: { (a: SpaceshipData, b: SpaceshipData) -> Bool in
            
            let aIndex = a.parentMothershipSlot?.index ?? 4
            let bIndex = b.parentMothershipSlot?.index ?? 4
            
            return aIndex < bIndex
        }) {
            for spaceshipData in playerDataSpaceships {
                let spaceship = Spaceship(spaceshipData: spaceshipData)
                cells.append(SpaceshipHangarCell(spaceship: spaceship))
            }
        }
        
        self.scrollNode = ScrollNode(cells: cells, x: 71, y: 110, horizontalAlignment: .center, verticalAlignment: .top)
        self.addChild(self.scrollNode)
        
        let control = Control(imageNamed: "box89x89", x: 375/2, y: -2, horizontalAlignment: .center)
        control.anchorPoint.x = 0.5
        control.size.width = GameScene.currentSize.width * 3
        self.addChild(control)
        
        let controlPremiumPoints = ControlPremiumPoints(x: 8, y: 15)
        controlPremiumPoints.setLabelPremiumPointsText(premiumPoints: self.playerData.premiumPoints)
        self.addChild(controlPremiumPoints)
        
        let controlPoints = ControlPoints(x: 223, y: 15, horizontalAlignment: .right)
        controlPoints.setLabelPointsText(points: self.playerData.points)
        self.addChild(controlPoints)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if self.state == self.nextState {
            
            switch self.state {
                
            case .hangar:
                break
                
            case .mainMenu:
                break
            }
        } else {
            self.state = self.nextState
            
            switch self.nextState {
                
            case .hangar:
                break
                
            case .mainMenu:
                self.view?.presentScene(MainMenuScene(), transition: GameScene.defaultTransition)
                break
            }
        }
    }
    
    override func touchMoved(touch: UITouch) {
        super.touchMoved(touch: touch)
        
        if self.scrollNode.contains(touch.location(in: self)) {
            self.scrollNode.touchMoved(touchDelta: touch.delta)
        }
        
    }

}
