//
//  MainMenuScene.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity
import AudioToolbox

#if os(iOS)
//    import FBSDKLoginKit
#endif

class MainMenuScene: GameScene {
    
    enum zPosition: CGFloat {
        case blackSpriteNode = 100000
        case box = 1000000
    }

    enum state: String {
        case mainMenu
        case battle
        case hangar
        case chooseMission
    }
    
    var state: state = .mainMenu
    var nextState: state = .mainMenu
    
    weak var stars: Stars!
    
    //MultiplayerOnline
    let serverManager = ServerManager.sharedInstance
    var lastOnlineUpdate: Double = 0
    var emitInterval: TimeInterval = 1/30
    
    var waitForPlayersTime: Double = 0
    var waitForPlayersTimeOut: Double = 10
    
    var waitSyncGameDataTime: Double = 0
    var waitSyncGameDataTimeOut: Double = 10
    
    override func load() {
        super.load()
        
        MemoryCard.sharedInstance.saveGame()
        
        let serverManager = ServerManager.sharedInstance
        
        serverManager.onAny { [weak self] (event: String, peerID: MCPeerID, items: Any) in
            guard self != nil else { return }
            switch event {
            case "connected":
                print("a player wants to play")
                print("show match request")
                break
            default:
                print("event: \(event), peerID: \(peerID), items: \(items)")
                break
            }
        }
        serverManager.startBrowsingForPeers()
        
        let buttonPlayOnline = Button(imageNamed: "button_55x55", x: 249, y: 95, horizontalAlignment: .right, verticalAlignment: .top)
        buttonPlayOnline.setIcon(imageNamed: "Bluetooth")
        buttonPlayOnline.set(color: GameColors.controlRed, blendMode: .add)
        self.addChild(buttonPlayOnline)
        buttonPlayOnline.addHandler { [weak self] in
            guard let `self` = self else { return }

            let boxSearchingForOpponent = BoxSearchingForOpponent()
            boxSearchingForOpponent.zPosition = MainMenuScene.zPosition.box.rawValue
            self.blackSpriteNode.isHidden = false
            self.blackSpriteNode.zPosition = MainMenuScene.zPosition.blackSpriteNode.rawValue
            self.addChild(boxSearchingForOpponent)

            serverManager.onAny { (event: String, peerID: MCPeerID, items: Any) in
                switch event {
                case "connected":
                    print("connected to server")
                    print("wait for match comfirmation")
                    break
                default:
                    print("event: \(event), peerID: \(peerID), items: \(items)")
                    break
                }
            }
            serverManager.startAdvertisingPeer()
        }
        
        self.registerUserNotificationSettings()
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        self.backgroundColor = GameColors.backgroundColor
        
        let stars = Stars()
        stars.position.x = stars.position.x + GameScene.currentSize.width/2
        stars.position.y = stars.position.y - GameScene.currentSize.height/2
        self.addChild(stars)
        self.stars = stars
        
        let mothershipSlots = MothershipSlots(x: 0, y: 289, horizontalAlignment: .center, verticalAlignment: .center)
        
        mothershipSlots.load(slots: playerData.mothership?.slots)
        self.addChild(mothershipSlots)
        
        let buttonPlay = Button(imageNamed: "button_233x55", x: 71, y: 604, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonPlay.setIcon(imageNamed: "Play")
        buttonPlay.set(color: GameColors.controlRed, blendMode: .add)
        self.addChild(buttonPlay)
        buttonPlay.addHandler { [weak self] in
            guard let `self` = self else { return }
            self.nextState = .battle
            #if os(iOS)
                GameViewController.sharedInstance()?.save(achievementIdentifier: "touchToStart")
            #endif
        }
        
        let buttonBuy = Button(imageNamed: "button_55x55", x: 312, y: 604, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonBuy.setIcon(imageNamed: "Add Shopping Cart")
        buttonBuy.set(color: GameColors.controlYellow, blendMode: .add)
        self.addChild(buttonBuy)
        
        let buttonShips = Button(imageNamed: "button_55x55", x: 8, y: 604, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonShips.setIcon(imageNamed: "Rocket")
        buttonShips.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonShips)
        buttonShips.addHandler { [weak self] in
            guard let `self` = self else { return }
            self.nextState = .hangar
        }
        
        let buttonSettings = Button(imageNamed: "button_55x55", x: 312, y: 95, horizontalAlignment: .right, verticalAlignment: .top)
        buttonSettings.setIcon(imageNamed: "Settings")
        buttonSettings.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonSettings)
        buttonSettings.addHandler { [weak self] in
            guard let `self` = self else { return }
            let boxSettings = BoxSettings()
            boxSettings.zPosition = MainMenuScene.zPosition.box.rawValue
            self.blackSpriteNode.isHidden = false
            self.blackSpriteNode.zPosition = MainMenuScene.zPosition.blackSpriteNode.rawValue
            self.addChild(boxSettings)
            self.blackSpriteNode.removeAllHandlers()
            self.blackSpriteNode.addHandler { [weak boxSettings] in
                boxSettings?.removeFromParent()
                self.blackSpriteNode.isHidden = true
            }
        }
        
        let buttonGameCenter = Button(imageNamed: "button_55x55", x: 312, y: 158, horizontalAlignment: .right, verticalAlignment: .top)
        buttonGameCenter.setIcon(imageNamed: "Game Center")
        buttonGameCenter.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonGameCenter)
        #if os(iOS)
            buttonGameCenter.addHandler {
                GameViewController.sharedInstance()?.presentGameCenterViewController()
            }
        #endif
        
        let buttonFacebook = Button(imageNamed: "button_55x55", x: 312, y: 221, horizontalAlignment: .right, verticalAlignment: .top)
        buttonFacebook.setIcon(imageNamed: "Facebook")
        buttonFacebook.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonFacebook)
        #if os(iOS)
//            if FBSDKAccessToken.current() != nil {
//                buttonFacebook.removeFromParent()
//            } else {
//                buttonFacebook.addHandler { [weak buttonFacebook] in
//                    FacebookClient.sharedInstance.logInWith(successBlock: {
//                        buttonFacebook?.removeFromParent()
//                    }, andFailureBlock: { (error: Error?) in
//                        print(error?.localizedDescription ?? "Something went very wrong.")
//                    })
//                }
//            }
        #endif
        
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
        
        let controlMission = ControlMission(x: 71, y: 507, horizontalAlignment: .center, verticalAlignment: .center)
        self.addChild(controlMission)
        
        controlMission.buttonChooseMission.addHandler { [weak self] in
            guard let `self` = self else { return }
            self.nextState = .chooseMission
        }
        buttonBuy.isHidden = true
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
                
            case .mainMenu:
                break
            case .battle:
                break
            case .hangar:
                break
            case .chooseMission:
                break
            }
        } else {
            self.state = self.nextState
            
            switch self.nextState {
                
            case .mainMenu:
                self.view?.presentScene(MainMenuScene(), transition: GameScene.defaultTransition)
                break
            case .battle:
                Music.sharedInstance.stop()
                self.view?.presentScene(BattleScene(), transition: GameScene.defaultTransition)
                break
            case .hangar:
                self.view?.presentScene(HangarScene(), transition: GameScene.defaultTransition)
                break
            case .chooseMission:
                self.view?.presentScene(ChooseMissionScene(), transition: GameScene.defaultTransition)
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
