//
//  MothershipHealthBar.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/29/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class MothershipHealthBar: SKSpriteNode {
    
    var positionOffset = CGPoint(x: 0, y: 0)
    var fillSizeWidth: CGFloat = 1
    
    var fill: SKSpriteNode!
    
    init(team: Mothership.team) {
        let texture = SKTexture(imageNamed: "mothershipHealthBarBackground", filteringMode: GameScene.defaultFilteringMode)
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        var teamColor: SKColor = .clear
        
        switch team {
        case .blue:
            teamColor = GameColors.blueTeam
            self.positionOffset = CGPoint(x: 0, y: 89/2 - 9)
            break
        case .red:
            teamColor = GameColors.redTeam
            self.positionOffset = CGPoint(x: 0, y: -89/2 + 9)
            break
        }
        
        self.fill = SKSpriteNode(texture: nil, color: .clear, size: self.size)
        self.fillSizeWidth = self.fill.size.width - 4
        self.fill.size.width = self.fillSizeWidth
        self.fill.size.height = self.fill.size.height - 4
        self.fill.position = CGPoint(x: -179.5, y: 0)
        self.fill.anchorPoint = CGPoint(x: 0, y: 0.5)
        self.addChild(self.fill)
        
        let border = SKSpriteNode(imageNamed: "mothershipHealthBarBorder", filteringMode: GameScene.defaultFilteringMode)
        self.addChild(border)
        
        self.color = teamColor
        self.fill.color = GameColors.common
        border.color = teamColor
        
        self.colorBlendFactor = 1
        self.fill.colorBlendFactor = 1
        border.colorBlendFactor = 1
        
        //self.blendMode = .add
        //self.fill.blendMode = .add
        //border.blendMode = .add
        
        self.alpha = 1
        self.fill.alpha = 1
        border.alpha = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(health: Int, maxHealth: Int) {
        if health <= 0 {
            self.fill.isHidden = true
        } else {
            self.fill.isHidden = false
            self.fill.size.width = self.fillSizeWidth * (CGFloat(health)/CGFloat(maxHealth))
        }
    }

}
