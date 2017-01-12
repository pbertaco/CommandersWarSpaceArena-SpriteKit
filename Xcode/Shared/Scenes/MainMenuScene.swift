//
//  MainMenuScene.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class MainMenuScene: GameScene {

    enum state: String {
        case mainMenu
    }
    
    var state: state = .mainMenu
    var nextState: state = .mainMenu
    
    let playerData = MemoryCard.sharedInstance.playerData
    
    override func load() {
        super.load()
        
        self.backgroundColor = GameColors.backgroundColor
        
        let mothershipSlots = MothershipSlots(x: 144, y: 143, horizontalAlignment: .center, verticalAlignment: .center)
        mothershipSlots.load(slots: self.playerData?.mothership?.slots)
        self.addChild(mothershipSlots)
        
        let buttonPlay = Button(imageNamed: "button233x55", x: 218, y: 312, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonPlay.setIcon(imageNamed: "Play")
        buttonPlay.setColor(color: GameColors.buttonRed)
        self.addChild(buttonPlay)
        
        let buttonBuy = Button(imageNamed: "button55x55", x: 469, y: 312, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonBuy.setIcon(imageNamed: "Add Shopping Cart")
        buttonBuy.setColor(color: GameColors.buttonYellow)
        self.addChild(buttonBuy)
        
        let buttonShips = Button(imageNamed: "button55x55", x: 144, y: 312, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonShips.setIcon(imageNamed: "Rocket")
        buttonShips.setColor(color: GameColors.buttonBlue)
        self.addChild(buttonShips)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if self.state == self.nextState {
            
            switch self.state {
                
            case .mainMenu:
                break
            }
        } else {
            self.state = self.nextState
            
            switch self.nextState {
                
            case .mainMenu:
                break
            }
        }
    }
}
