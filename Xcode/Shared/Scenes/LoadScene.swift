//
//  LoadScene.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/10/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class LoadScene: GameScene {
    
    enum state: String {
        case load
        case mainMenu
    }
    
    var state: state = .load
    var nextState: state = .load
    
    init() {
        GameScene.defaultSize = CGSize(width: 375, height: 667)
        //GameScene.defaultFilteringMode = .nearest
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func load() {
        super.load()
        
        #if DEBUG
            self.view?.showsFPS = true
            //self.view?.showsDrawCount = true
            //self.view?.showsNodeCount = true
            //self.view?.showsPhysics = true
            
            //MemoryCard.sharedInstance.reset()
            //let playerData = MemoryCard.sharedInstance.playerData!
            //playerData.points = 9999999
            //playerData.premiumPoints = 9999999
        #endif
        
        self.backgroundColor = GameColors.backgroundColor
        
        self.addChild(Control(imageNamed: "launchScreenPortrait", x: 0, y: 0, horizontalAlignment: .center, verticalAlignment: .center))
        
        self.afterDelay(1) { [weak self] in
            self?.nextState = .mainMenu
        }
        
        Label.defaultFontName = .kenPixel
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if self.state == self.nextState {
            
            switch self.state {
                
            case .load:
                break
                
            case .mainMenu:
                break
            }
        } else {
            self.state = self.nextState
            
            switch self.nextState {
                
            case .load:
                break
                
            case .mainMenu:
                self.view?.presentScene(MainMenuScene(), transition: GameScene.defaultTransition)
                break
            }
        }
    }
}
