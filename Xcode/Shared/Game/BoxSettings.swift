//
//  BoxSettings.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 3/14/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class BoxSettings: Box {

    init() {
        super.init(imageNamed: "box_233x610")
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        self.addChild(Label(text: "Music", horizontalAlignmentMode: .left, verticalAlignmentMode: .baseline, x: 43, y: 69 - 6))
        
        let buttonMusic = Button(imageNamed: "button_55x55", x: 43, y: 69)
        buttonMusic.setIcon(imageNamed: playerData.music ? "Musical Notes 1" : "Musical Notes 0")
        buttonMusic.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonMusic)
        buttonMusic.addHandler { [weak buttonMusic] in
            playerData.music = !playerData.music
            buttonMusic?.setIcon(imageNamed: playerData.music ? "Musical Notes 1" : "Musical Notes 0")
            buttonMusic?.set(color: GameColors.controlBlue, blendMode: .add)
            Music.sharedInstance.play()
        }
        
        self.addChild(Label(text: "Sound Effects", horizontalAlignmentMode: .left, verticalAlignmentMode: .baseline, x: 43, y: 190 - 6))
        
        let buttonSound = Button(imageNamed: "button_55x55", x: 43, y: 190)
        buttonSound.setIcon(imageNamed: playerData.sound ? "High Volume 1" : "High Volume 0")
        buttonSound.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonSound)
        buttonSound.addHandler { [weak buttonSound] in
            playerData.sound = !playerData.sound
            buttonSound?.setIcon(imageNamed: playerData.sound ? "High Volume 1" : "High Volume 0")
            buttonSound?.set(color: GameColors.controlBlue, blendMode: .add)
            SoundEffect(effectType: .explosion).play()
        }
        
        
        self.addChild(Label(text: "Credits", horizontalAlignmentMode: .left, verticalAlignmentMode: .baseline, x: 43, y: 312 - 6))
        
        let buttonCredits = Button(imageNamed: "button_55x55", x: 43, y: 312)
        buttonCredits.setIcon(imageNamed: "About")
        buttonCredits.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonCredits)
        buttonCredits.addHandler { [weak self] in
            self?.scene?.view?.presentScene(CreditsScene(), transition: GameScene.defaultTransition)
        }
        
        
        self.addChild(Label(text: "Reset Data", horizontalAlignmentMode: .left, verticalAlignmentMode: .baseline, x: 43, y: 434 - 6))
        
        let buttonReset = Button(imageNamed: "button_55x55", x: 43, y: 434)
        buttonReset.setIcon(imageNamed: "Waste")
        buttonReset.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonReset)
        buttonReset.addHandler { [weak self] in
            guard let boxSettings = self else { return }
            let boxResetData = BoxResetData()
            GameScene.current()?.blackSpriteNode.removeAllHandlers()
            GameScene.current()?.blackSpriteNode.addHandler { [weak boxResetData] in
                boxResetData?.removeFromParent()
                GameScene.current()?.blackSpriteNode.isHidden = true
            }
            
            boxResetData.zPosition = boxSettings.zPosition
            boxSettings.scene?.addChild(boxResetData)
            boxSettings.removeFromParent()
        }
        
        let buttonOK = Button(imageNamed: "button_89x34", x: 72, y: 554)
        buttonOK.set(label: Label(text: "OK"))
        buttonOK.set(color: GameColors.controlBlue, blendMode: .add)
        addChild(buttonOK)
        buttonOK.addHandler { [weak self] in
            self?.removeFromParent()
            GameScene.current()?.blackSpriteNode.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
