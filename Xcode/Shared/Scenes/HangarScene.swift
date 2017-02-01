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

}
