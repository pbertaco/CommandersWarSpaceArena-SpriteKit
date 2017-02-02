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
        case hangar
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
        buttonPlay.set(color: GameColors.controlRed, blendMode: .add)
        self.addChild(buttonPlay)
        buttonPlay.touchUpEvent = { [weak self] in
            self?.nextState = .battle
        }
        
        let buttonBuy = Button(imageNamed: "button55x55", x: 312, y: 604, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonBuy.setIcon(imageNamed: "Add Shopping Cart")
        buttonBuy.set(color: GameColors.controlYellow, blendMode: .add)
        self.addChild(buttonBuy)
        
        let buttonShips = Button(imageNamed: "button55x55", x: 8, y: 604, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonShips.setIcon(imageNamed: "Rocket")
        buttonShips.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonShips)
        buttonShips.touchUpEvent = { [weak self] in
            self?.nextState = .hangar
        }
        
        let buttonSettings = Button(imageNamed: "button55x55", x: 312, y: 95, horizontalAlignment: .right, verticalAlignment: .top)
        buttonSettings.setIcon(imageNamed: "Settings")
        buttonSettings.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonSettings)
        
        let buttonGameCenter = Button(imageNamed: "button55x55", x: 312, y: 158, horizontalAlignment: .right, verticalAlignment: .top)
        buttonGameCenter.setIcon(imageNamed: "Tropy")
        buttonGameCenter.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonGameCenter)
        #if os(iOS)
            buttonGameCenter.touchUpEvent = { [weak self] in
                (self?.view?.window?.rootViewController as? GameViewController)?.presentGameCenterViewController()
            }
        #endif
        
        let buttonFacebook = Button(imageNamed: "button55x55", x: 312, y: 221, horizontalAlignment: .right, verticalAlignment: .top)
        buttonFacebook.setIcon(imageNamed: "Facebook")
        buttonFacebook.set(color: GameColors.controlBlue, blendMode: .add)
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
                
            case .mainMenu:
                break
            case .battle:
                break
            case .hangar:
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
            case .hangar:
                self.view?.presentScene(HangarScene(), transition: GameScene.defaultTransition)
                break
            }
        }
    }
    
}
