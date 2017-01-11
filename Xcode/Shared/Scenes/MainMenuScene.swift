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
    
    override func load() {
        super.load()
        
        self.backgroundColor = GameColors.backgroundColor
        
        self.addChild(MothershipSpaceships(x: 144, y: 143, horizontalAlignment: .center, verticalAlignment: .center))
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
