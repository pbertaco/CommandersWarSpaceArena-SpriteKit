//
//  BoxSearchingForOpponent.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 03/05/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class BoxSearchingForOpponent: Box {

    init() {
        super.init(imageNamed: "box_233x233")
        
        self.addChild(MultiLineLabel(text: "Searching for opponent.", maxWidth: 144, fontSize: .fontSize16, x: 45, y: 34))
        
        let load = SKSpriteNode(imageNamed: "Available Updates")
        load.position = CGPoint(x: 116, y: -116)
        load.setScaleToFit(size: CGSize(width: 55, height: 55))
        load.run(SKAction.repeatForever(SKAction.rotate(byAngle: -π, duration: 1)))
        self.addChild(load)
        
        let buttonCancel = Button(imageNamed: "button_89x34", x: 72, y: 158)
        buttonCancel.set(label: Label(text: "Cancel"))
        buttonCancel.set(color: GameColors.controlRed, blendMode: .add)
        self.addChild(buttonCancel)
        buttonCancel.addHandler { [weak self] in
            guard let `self` = self else { return }
            SoundEffect(effectType: .explosion).play()
            
            GameScene.current()?.blackSpriteNode.isHidden = true
            self.removeFromParent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
