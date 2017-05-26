//
//  SpaceshipHealthBar.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/27/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class SpaceshipHealthBar: SKSpriteNode {
    
    var positionOffset = CGPoint(x: 0, y: 0)
    var fillSizeWidth: CGFloat = 1
    
    weak var fill: SKSpriteNode!
    weak var label: Label!
    weak var labelLevel: Label!
    
    init(level: Int, health: Int, team: Mothership.team, rarity: Spaceship.rarity) {
        
        let texture = SKTexture(imageNamed: "spaceshipHealthBarBackground", filteringMode: GameScene.defaultFilteringMode)
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.zPosition = GameWorld.zPosition.spaceshipHealthBar.rawValue
        
        var teamColor: SKColor = .clear
        
        switch team {
        case .blue:
            teamColor = GameColors.blueTeam
            self.positionOffset = CGPoint(x: 0, y: -Spaceship.diameter/2 - 8)
            break
        case .red, .none:
            teamColor = GameColors.redTeam
            self.positionOffset = CGPoint(x: 0, y: Spaceship.diameter/2 + 8)
            break
        }
        
        var rarityColor: SKColor = .clear
        
        switch rarity {
        case .common:
            rarityColor = GameColors.common
            break
        case .uncommon:
            rarityColor = GameColors.uncommon
            break
        case .rare:
            rarityColor = GameColors.rare
            break
        case .heroic:
            rarityColor = GameColors.heroic
            break
        case .epic:
            rarityColor = GameColors.epic
            break
        case .legendary:
            rarityColor = GameColors.legendary
            break
        case .supreme:
            rarityColor = GameColors.supreme
            break
        }
        
        let fill = SKSpriteNode(texture: nil, color: .clear, size: self.size)
        self.fillSizeWidth = fill.size.width - 4
        fill.size.width = self.fillSizeWidth
        fill.size.height = fill.size.height - 4
        fill.position = CGPoint(x: -25.5, y: 0)
        fill.anchorPoint = CGPoint(x: 0, y: 0.5)
        self.addChild(fill)
        self.fill = fill
        
        let border = SKSpriteNode(imageNamed: "spaceshipHealthBarBorder", filteringMode: GameScene.defaultFilteringMode)
        self.addChild(border)
        
        let levelBackground = SKSpriteNode(imageNamed: "spaceshipHealthBarLevelBackground", filteringMode: GameScene.defaultFilteringMode)
        levelBackground.position = CGPoint(x: -38, y: 0)
        self.addChild(levelBackground)
        
        let labelLevel = Label(text: level.description, fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.fontBlack)
        levelBackground.addChild(labelLevel)
        self.labelLevel = labelLevel
        
        self.color = teamColor
        self.fill.color = rarityColor
        border.color = teamColor
        levelBackground.color = teamColor
        
        self.colorBlendFactor = 1
        self.fill.colorBlendFactor = 1
        border.colorBlendFactor = 1
        levelBackground.colorBlendFactor = 1
        
        let label = Label(text: health.description, fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.fontBlack)
        label.position.y = -0.5
        self.addChild(label)
        self.label = label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(health: Int, maxHealth: Int) {
        if health <= 0 {
            self.isHidden = true
        } else {
            self.isHidden = false
            self.fill.size.width = self.fillSizeWidth * (CGFloat(health)/CGFloat(maxHealth))
            self.label.text = health.description
        }
    }
}
