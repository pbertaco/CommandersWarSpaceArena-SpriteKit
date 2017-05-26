//
//  MothershipSlot.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class MothershipSlot: Control {
    
    weak var spaceship: Spaceship?
    
    init(x: CGFloat, y: CGFloat, horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top) {
        super.init(imageNamed: "box_89x89", x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
        
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
    
    func loadHealthBar() {
        self.spaceship?.loadHealthBar(gameWorld: self)
        self.spaceship?.healthBar?.positionOffset = CGPoint(x: 4, y: Int(-self.size.height/2) - 9)
        self.spaceship?.updateHealthBarPosition()
    }
    
    private func load(spaceship: Spaceship) {
        
        self.spaceship?.removeFromParent()
        self.spaceship = spaceship
        self.addChild(spaceship)
        
        spaceship.position = CGPoint(x: self.size.width/2, y: -self.size.height/2)
        
        spaceship.setScaleToFit(width: self.size.width - 16, height: self.size.height - 16)
        
        switch spaceship.rarity {
        case .common:
            self.set(color: GameColors.common)
            break
        case .uncommon:
            self.set(color: GameColors.uncommon)
            break
        case .rare:
            self.set(color: GameColors.rare)
            break
        case .heroic:
            self.set(color: GameColors.heroic)
            break
        case .epic:
            self.set(color: GameColors.epic)
            break
        case .legendary:
            self.set(color: GameColors.legendary)
            break
        case .supreme:
            self.set(color: GameColors.supreme)
            break
        }
    }

}
