//
//  CreditsScene.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 3/14/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class CreditsScene: GameScene {
    
    var lastSpaceship: TimeInterval = 0
    var fps = 0
    
    var spaceships = [Spaceship]()
    weak var gameWorld: GameWorld!
    
    weak var gameCamera: GameCamera!

    override func load() {
        super.load()
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        self.backgroundColor = GameColors.backgroundColor
        
        let gameWorld = GameWorld()
        gameWorld.zPosition = -1000000
        self.addChild(gameWorld)
        self.physicsWorld.contactDelegate = gameWorld
        
        let gameCamera = GameCamera()
        let gameCameraNode = SKNode()
        gameCamera.node = gameCameraNode
        gameWorld.addChild(gameCamera)
        gameWorld.addChild(gameCameraNode)
        gameCamera.update()
        
        gameWorld.explosionSoundEffect = nil
        gameWorld.shotSoundEffect = nil
        
        self.gameWorld = gameWorld
        self.gameCamera = gameCamera
        
        Music.sharedInstance.playMusic(withType: .battle)
        
        let box = Control(imageNamed: "box_233x377", x: 71, y: 35, horizontalAlignment: .center, verticalAlignment: .center)
        self.addChild(box)
        
        box.addChild(Label(text: "Code", horizontalAlignmentMode: .left, verticalAlignmentMode: .baseline, x: 26, y: 51))
        
        box.addChild(Label(text: "Pablo Bertaco", horizontalAlignmentMode: .left, verticalAlignmentMode: .baseline, x: 26, y: 82))
        
        let buttonPabloMail = Button(imageNamed: "button_55x55", x: 26, y: 110)
        buttonPabloMail.setIcon(imageNamed: "Email")
        buttonPabloMail.set(color: GameColors.controlBlue, blendMode: .add)
        box.addChild(buttonPabloMail)
        buttonPabloMail.addHandler {
            #if os(iOS)
                UIApplication.shared.openURL(URL(string: "mailto:pablo_fonseca91@icloud.com?Subject=CommandersWar")!)
            #endif
        }
        
        let buttonPabloFacebook = Button(imageNamed: "button_55x55", x: 89, y: 110)
        buttonPabloFacebook.setIcon(imageNamed: "Facebook")
        buttonPabloFacebook.set(color: GameColors.facebook, blendMode: .add)
        box.addChild(buttonPabloFacebook)
        buttonPabloFacebook.addHandler {
            #if os(iOS)
                UIApplication.shared.openURL(URL(string: "https://www.facebook.com/pablohenri")!)
            #endif
        }
        
        let buttonPabloLinkedIn = Button(imageNamed: "button_55x55", x: 152, y: 110)
        buttonPabloLinkedIn.setIcon(imageNamed: "LinkedIn")
        buttonPabloLinkedIn.set(color: GameColors.linkedIn, blendMode: .add)
        box.addChild(buttonPabloLinkedIn)
        buttonPabloLinkedIn.addHandler {
            #if os(iOS)
                UIApplication.shared.openURL(URL(string: "https://www.linkedin.com/in/pablo-henrique-bertaco-saraiva-da-fonseca-8b83b853")!)
            #endif
        }
        
        box.addChild(Label(text: "Music", horizontalAlignmentMode: .left, verticalAlignmentMode: .baseline, x: 26, y: 233))
        
        box.addChild(Label(text: "Klamm", horizontalAlignmentMode: .left, verticalAlignmentMode: .baseline, x: 26, y: 261))
        
        let buttonKlammMail = Button(imageNamed: "button_55x55", x: 26, y: 289)
        buttonKlammMail.setIcon(imageNamed: "Email")
        buttonKlammMail.set(color: GameColors.controlBlue, blendMode: .add)
        box.addChild(buttonKlammMail)
        buttonKlammMail.addHandler {
            #if os(iOS)
                UIApplication.shared.openURL(URL(string: "mailto:protarkos@hotmail.com?Subject=CommandersWar")!)
            #endif
        }
        
        let buttonKlammTwitter = Button(imageNamed: "button_55x55", x: 89, y: 289)
        buttonKlammTwitter.setIcon(imageNamed: "Twitter")
        buttonKlammTwitter.set(color: GameColors.twitter, blendMode: .add)
        box.addChild(buttonKlammTwitter)
        buttonKlammTwitter.addHandler {
            #if os(iOS)
                UIApplication.shared.openURL(URL(string: "https://twitter.com/Klamm00")!)
            #endif
        }
        
        let buttonKlammWebSite = Button(imageNamed: "button_55x55", x: 152, y: 289)
        buttonKlammWebSite.setIcon(imageNamed: "Web Design")
        buttonKlammWebSite.set(color: GameColors.controlBlue, blendMode: .add)
        box.addChild(buttonKlammWebSite)
        buttonKlammWebSite.addHandler {
            #if os(iOS)
                UIApplication.shared.openURL(URL(string: "http://klamm.makesnoise.com")!)
            #endif
        }
        
        
        let title = Control(imageNamed: "title", x: 9, y: 470, horizontalAlignment: .center, verticalAlignment: .center)
        title.set(color: .white, blendMode: .add)
        self.addChild(title)
        
        self.addChild(Label(text: "Thanks for playing!", x: 187, y: 620, horizontalAlignment: .center, verticalAlignment: .center))
        
        self.afterDelay(60) { [weak self] in
            self?.view?.presentScene(CreditsScene(), transition: GameScene.defaultTransition)
        }
    }
    
    override func updateSize() {
        super.updateSize()
        self.gameCamera.update()
        self.gameWorld.updateSize()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        self.fps = self.fps + 1
        
        for spaceship in self.spaceships {
            spaceship.update(enemyMothership: nil, enemySpaceships: self.spaceships)
            if spaceship.health <= 0 {
                spaceship.destroy()
                spaceship.healthBar?.destroy()
            }
        }
        
        if currentTime - self.lastSpaceship > 1 {
            self.lastSpaceship = currentTime
            
            self.spaceships = self.spaceships.filter({ $0.health > 0 })
            
            if self.spaceships.count < 3 && self.fps >= 60 {
                let spaceship = Spaceship(level: 1 + Int.random(10), rarity: Spaceship.randomRarity() ?? .common, loadPhysics: true, team: .none)
                spaceship.setBitMasksToSpaceship()
                spaceship.physicsBody?.isDynamic = true
                spaceship.position = CGPoint(
                    x: CGFloat.random(min: -GameScene.sketchSize.width/2, max: GameScene.sketchSize.width/2),
                    y: CGFloat.random(min: -GameScene.sketchSize.height/2, max: GameScene.sketchSize.height/2))
                spaceship.destination = CGPoint(
                    x: CGFloat.random(min: -GameScene.sketchSize.width/2, max: GameScene.sketchSize.width/2),
                    y: CGFloat.random(min: -GameScene.sketchSize.height/2, max: GameScene.sketchSize.height/2))
                spaceship.canRespawn = false
                self.gameWorld.addChild(spaceship)
                self.spaceships.append(spaceship)
                
                spaceship.loadHealthBar(gameWorld: gameWorld)
                spaceship.loadJetEffect(gameWorld: gameWorld)
                
                spaceship.updateHealthBarPosition()
                
                let action = SKAction.fadeAlpha(to: 1, duration: 1)
                spaceship.alpha = 0
                spaceship.run(action)
                spaceship.healthBar?.alpha = 0
                spaceship.healthBar?.run(action)
                spaceship.zRotation = CGFloat.random(min: -π, max: +π)
            }
            
            if self.spaceships.count > 0 {
                let spaceship = self.spaceships[Int.random(self.spaceships.count)]
                let newTargetNode = self.spaceships[Int.random(self.spaceships.count)]
                if newTargetNode != spaceship {
                    spaceship.destination = nil
                    spaceship.targetNode = newTargetNode
                } else {
                    spaceship.destination = CGPoint(
                        x: CGFloat.random(min: -GameScene.sketchSize.width/2, max: GameScene.sketchSize.width/2),
                        y: CGFloat.random(min: -GameScene.sketchSize.height/2, max: GameScene.sketchSize.height/2))
                }
            }
            
            self.fps = 0
        }
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        Shot.update()
        
        for spaceship in self.spaceships {
            spaceship.didSimulatePhysics()
        }
    }
    
    override func touchUp(touch: UITouch) {
        super.touchUp(touch: touch)
        self.view?.presentScene(MainMenuScene(), transition: GameScene.defaultTransition)
    }
}
