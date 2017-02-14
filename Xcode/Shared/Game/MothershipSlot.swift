//
//  MothershipSlot.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class MothershipSlot: Control {
    
    var spaceship: Spaceship?
    
    init(x: CGFloat, y: CGFloat, horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top) {
        super.init(imageNamed: "box89x89", x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
        
        self.set(color: GameColors.common)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(spaceshipData: SpaceshipData) {
        self.load(spaceship: Spaceship(spaceshipData: spaceshipData))
    }
    
    func load(spaceship: Spaceship, createCopy: Bool = false) {
        self.load(spaceship: createCopy ? spaceship.createCopy() : spaceship)
    }
    
    private func load(spaceship: Spaceship) {
        
        self.spaceship?.removeFromParent()
        self.spaceship = spaceship
        self.addChild(spaceship)
        
        spaceship.position = CGPoint(x: self.size.width/2, y: -self.size.height/2)
        
        spaceship.setScaleToFit(width: self.size.width - 16, height: self.size.height - 16)
        
        switch spaceship.rarity {
        case .common:
            self.color = GameColors.common
            break
        case .rare:
            self.color = GameColors.rare
            break
        case .epic:
            self.color = GameColors.epic
            break
        case .legendary:
            self.color = GameColors.legendary
            break
        }
    }

}