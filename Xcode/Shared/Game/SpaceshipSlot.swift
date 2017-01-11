//
//  SpaceshipSlot.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class SpaceshipSlot: Control {
    
    var spaceship: Spaceship?
    
    init(x: CGFloat, y: CGFloat, horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top) {
        super.init(imageNamed: "boxWhite89x89", x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
        
        switch Int.random(4) {
        case 0:
            self.color = GameColors.common
            break
        case 1:
            self.color = GameColors.rare
            break
        case 2:
            self.color = GameColors.epic
            break
        case 3:
            self.color = GameColors.legendary
            break
        default:
            break
        }
        self.colorBlendFactor = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSpaceship(spaceshipData: SpaceshipData) {
        self.loadSpaceship(spaceship: Spaceship(spaceshipData: spaceshipData))
    }
    
    func loadSpaceship(spaceship: Spaceship) {
        self.spaceship = spaceship
        self.addChild(spaceship)
        
        spaceship.position = CGPoint(x: self.size.width/2, y: -self.size.height/2)
        
        let xScale = (self.size.width - 16) / spaceship.size.width
        let yScale = (self.size.height - 16) / spaceship.size.height
        spaceship.setScale(min(xScale, yScale))
        
        if spaceship.xScale > 1 {
            spaceship.setScale(1)
        }
    }

}
