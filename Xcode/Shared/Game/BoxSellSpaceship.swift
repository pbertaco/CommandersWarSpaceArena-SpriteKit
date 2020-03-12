//
//  BoxSellSpaceship.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 13/04/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class BoxSellSpaceship: Box {
    
    weak var buttonSell: Button?

    init(spaceship: Spaceship, points: Int32) {
        super.init(imageNamed: "box_377x610")
        
        self.addChild(Label(text: "Sell spaceship", fontSize: .fontSize16, x: 189, y: 73))
        
        var rarityText = ""
        switch spaceship.rarity {
        case .common:
            rarityText = "Common"
            break
        case .uncommon:
            rarityText = "Uncommon"
            break
        case .rare:
            rarityText = "Rare"
            break
        case .heroic:
            rarityText = "Heroic"
            break
        case .epic:
            rarityText = "Epic"
            break
        case .legendary:
            rarityText = "Legendary"
            break
        case .supreme:
            rarityText = "Supreme"
            break
        case .boss:
            rarityText = "Boss"
            break
        }
        
        self.addChild(MultiLineLabel(text: "Are you sure you want to sell this \(rarityText) \(spaceship.element.element.rawValue) spaceship for \(points.pointsString()) coins?", maxWidth: 233, fontSize: .fontSize16, x: 72, y: 342))
        
        let spaceshipHangarCell = SpaceshipHangarCell(spaceship: spaceship.createCopy(), sellCompletion: {})
        spaceshipHangarCell.control0?.removeFromParent()
        spaceshipHangarCell.control1?.removeFromParent()
        spaceshipHangarCell.sketchPosition = CGPoint(x: 72, y: 141)
        spaceshipHangarCell.resetPosition()
        
        self.addChild(spaceshipHangarCell)
        
        let buttonNo = Button(imageNamed: "button_233x55", x: 19, y: 496)
        buttonNo.set(label: Label(text: "Nooooooooo"))
        buttonNo.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonNo)
        buttonNo.addHandler { [weak self] in
            guard let `self` = self else { return }
            GameScene.current?.blackSpriteNode.isHidden = true
            self.removeFromParent()
        }
        
        let buttonSell = Button(imageNamed: "button_89x34", x: 269, y: 507)
        buttonSell.set(label: Label(text: "sell", fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.points, y: -6))
        buttonSell.set(label: Label(text: "+\(points.pointsString())", fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.points, y: 6))
        buttonSell.set(color: GameColors.points, blendMode: .add)
        self.addChild(buttonSell)
        buttonSell.addHandler { [weak self] in
            guard let `self` = self else { return }
            SoundEffect(effectType: .explosion).play()
            
            GameScene.current?.blackSpriteNode.isHidden = true
            self.removeFromParent()
        }
        self.buttonSell = buttonSell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
