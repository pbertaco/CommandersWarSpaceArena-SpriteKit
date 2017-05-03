//
//  BoxWatchAd.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 3/23/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class BoxWatchAd: Box {

    init() {
        super.init(imageNamed: "box_377x144")
        
        self.addChild(MultiLineLabel(text: "Would you like to watch an ad for gems?", maxWidth: 233, x: 72, y: 21))
        
        let buttonNo = Button(imageNamed: "button_89x34", x: 72, y: 89)
        buttonNo.set(label: Label(text: "No"))
        buttonNo.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonNo)
        buttonNo.addHandler { [weak self] in
            guard let `self` = self else { return }
            GameScene.current()?.blackSpriteNode.isHidden = true
            self.removeFromParent()
        }
        
        let buttonYes = Button(imageNamed: "button_89x34", x: 216, y: 89)
        buttonYes.set(label: Label(text: "Yes"))
        buttonYes.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonYes)
        buttonYes.addHandler { [weak self] in
            guard let `self` = self else { return }
            GameAdManager.sharedInstance.play()
            self.removeFromParent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
