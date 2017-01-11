//
//  SpaceshipSlots.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class MothershipSpaceships: Control {
    
    var spaceshipSlots = [SpaceshipSlot]()
    
    init(x: CGFloat, y: CGFloat, horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top) {
        super.init(x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
        
        self.spaceshipSlots.append(SpaceshipSlot(x: 0, y: 0))
        self.spaceshipSlots.append(SpaceshipSlot(x: 97, y: 0))
        self.spaceshipSlots.append(SpaceshipSlot(x: 194, y: 0))
        self.spaceshipSlots.append(SpaceshipSlot(x: 291, y: 0))
        
        for spaceshipSlot in self.spaceshipSlots {
            
            spaceshipSlot.loadSpaceship(spaceship: Spaceship())
            
            self.addChild(spaceshipSlot)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
