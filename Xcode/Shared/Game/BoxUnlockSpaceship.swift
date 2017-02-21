//
//  BoxUnlockSpaceship.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 2/7/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class BoxUnlockSpaceship: Box {
    
    var touchUpEvent: Event?
    
    weak var buttonUnlock: Button?
    weak var buttonIgnore: Button?
    
    init(rarity: Spaceship.rarity) {
        super.init(imageNamed: "box377x377")
        
        let spaceshipHangarCell = SpaceshipHangarCell(spaceship: Spaceship(level: 1, rarity: rarity))
        spaceshipHangarCell.sketchPosition = CGPoint(x: 72, y: 81)
        spaceshipHangarCell.resetPosition()
        
        self.addChild(spaceshipHangarCell)
        
        self.addChild(Label(text: "secret spaceship matrix", fontColor: GameColors.fontWhite, x: 189, y: 41))
        
        var rarityText = ""
        switch rarity {
        case .common:
            rarityText = "common"
            break
        case .rare:
            rarityText = "rare"
            break
        case .epic:
            rarityText = "epic"
            break
        case .legendary:
            rarityText = "legendary"
            break
        }
        self.addChild(MultiLineLabel(text: "contains a \(rarityText) spaceship, and can be unlocked at a lower cost", maxWidth: 233, fontColor: GameColors.fontWhite, x: 72, y: 252))
        
        self.buttonUnlock = spaceshipHangarCell.control1 as? Button
        
        self.buttonIgnore = spaceshipHangarCell.control0 as? Button
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
