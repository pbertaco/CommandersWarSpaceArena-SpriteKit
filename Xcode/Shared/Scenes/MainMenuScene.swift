//
//  MainMenuScene.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

#if os(iOS)
    import FBSDKLoginKit
#endif

class MainMenuScene: GameScene {

    enum state: String {
        case mainMenu
        case battle
    }
    
    var state: state = .mainMenu
    var nextState: state = .mainMenu
    
    let playerData = MemoryCard.sharedInstance.playerData!
    
    override func load() {
        super.load()
        
        self.backgroundColor = GameColors.backgroundColor
        
        let mothershipSlots = MothershipSlots(x: 0, y: 289, horizontalAlignment: .center, verticalAlignment: .center)
        mothershipSlots.load(slots: self.playerData.mothership?.slots)
        self.addChild(mothershipSlots)
        
        let buttonPlay = Button(imageNamed: "button233x55", x: 71, y: 604, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonPlay.setIcon(imageNamed: "Play")
        buttonPlay.setColor(color: GameColors.controlRed)
        self.addChild(buttonPlay)
        buttonPlay.touchUpEvent = { [weak self] in
            self?.nextState = .battle
        }
        
        let buttonBuy = Button(imageNamed: "button55x55", x: 312, y: 604, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonBuy.setIcon(imageNamed: "Add Shopping Cart")
        buttonBuy.setColor(color: GameColors.controlYellow)
        self.addChild(buttonBuy)
        
        let buttonShips = Button(imageNamed: "button55x55", x: 8, y: 604, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonShips.setIcon(imageNamed: "Rocket")
        buttonShips.setColor(color: GameColors.controlBlue)
        self.addChild(buttonShips)
        
        let buttonSettings = Button(imageNamed: "button55x55", x: 312, y: 8, horizontalAlignment: .right, verticalAlignment: .top)
        buttonSettings.setIcon(imageNamed: "Settings")
        buttonSettings.setColor(color: GameColors.controlBlue)
        self.addChild(buttonSettings)
        
        let buttonGameCenter = Button(imageNamed: "button55x55", x: 312, y: 71, horizontalAlignment: .right, verticalAlignment: .top)
        buttonGameCenter.setIcon(imageNamed: "Tropy")
        buttonGameCenter.setColor(color: GameColors.controlBlue)
        self.addChild(buttonGameCenter)
        #if os(iOS)
            buttonGameCenter.touchUpEvent = { [weak self] in
                (self?.view?.window?.rootViewController as? GameViewController)?.presentGameCenterViewController()
            }
        #endif
        
        let buttonFacebook = Button(imageNamed: "button55x55", x: 312, y: 134, horizontalAlignment: .right, verticalAlignment: .top)
        buttonFacebook.setIcon(imageNamed: "Facebook")
        buttonFacebook.setColor(color: GameColors.controlBlue)
        self.addChild(buttonFacebook)
        #if os(iOS)
            buttonFacebook.touchUpEvent = { [weak buttonFacebook] in
                FacebookClient.sharedInstance.logInWith(successBlock: {
                    buttonFacebook?.removeFromParent()
                }, andFailureBlock: { (error: Error?) in
                    print(error?.localizedDescription ?? "Something went very wrong.")
                })
            }
        #endif
        
        let controlPremiumPoints = ControlPremiumPoints(x: 8, y: 8)
        controlPremiumPoints.setLabelPremiumPointsText(premiumPoints: self.playerData.premiumPoints)
        self.addChild(controlPremiumPoints)
        
        let controlPoints = ControlPoints(x: 8, y: 71)
        controlPoints.setLabelPointsText(points: self.playerData.points)
        self.addChild(controlPoints)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if self.state == self.nextState {
            
            switch self.state {
                
            case .mainMenu:
                break
            case .battle:
                break
            }
        } else {
            self.state = self.nextState
            
            switch self.nextState {
                
            case .mainMenu:
                break
            case .battle:
                self.view?.presentScene(BattleScene(), transition: GameScene.defaultTransition)
                break
            }
        }
    }
    
}
