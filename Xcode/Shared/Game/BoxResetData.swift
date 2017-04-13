//
//  BoxResetData.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 3/15/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class BoxResetData: Box {

    init() {
        super.init(imageNamed: "box_377x377")
        
        self.addChild(Label(text: "Are you sure?", fontSize: .fontSize24, x: 189, y: 73))
        
        self.addChild(MultiLineLabel(text: "All progress will be lost!", maxWidth: 233, fontSize: .fontSize24, x: 72, y: 143))
        
        
        let buttonNo = Button(imageNamed: "button_233x55", x: 19, y: 268)
        buttonNo.set(label: Label(text: "Nooooooooo"))
        buttonNo.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonNo)
        buttonNo.addHandler { [weak self] in
            GameScene.current()?.blackSpriteNode.isHidden = true
            self?.removeFromParent()
        }
        
        let buttonYes = Button(imageNamed: "button_89x34", x: 269, y: 279)
        buttonYes.set(label: Label(text: "Yes"))
        buttonYes.set(color: GameColors.controlRed, blendMode: .add)
        self.addChild(buttonYes)
        buttonYes.addHandler { [weak self] in
            SoundEffect(effectType: .explosion).play()
            MemoryCard.sharedInstance.reset()
            Music.sharedInstance = Music()
            self?.scene?.view?.presentScene(LoadScene(), transition: GameScene.defaultTransition)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
