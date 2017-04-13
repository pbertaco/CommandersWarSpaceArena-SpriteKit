//
//  BoxVideoAdAttemptFinished.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 4/4/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class BoxVideoAdAttemptFinished: Box {
    
    init(bonusPremiumPoints: Int) {
        super.init(imageNamed: "box_377x144", animated: false)
        
        self.addChild(MultiLineLabel(text: "You got \(bonusPremiumPoints) gems!", maxWidth: 233, horizontalAlignmentMode: .center, x: 72, y: 21))
        
        let buttonNo = Button(imageNamed: "button_89x34", x: 144, y: 89)
        buttonNo.set(label: Label(text: "OK"))
        buttonNo.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonNo)
        buttonNo.addHandler { [weak self] in
            GameScene.current()?.blackSpriteNode.isHidden = true
            self?.removeFromParent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
