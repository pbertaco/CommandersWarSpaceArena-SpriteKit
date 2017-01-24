//
//  MothershipSlots.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class MothershipSlots: Control {
    
    var mothershipSlots = [MothershipSlot]()
    
    init(x: CGFloat, y: CGFloat, horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top) {
        super.init(x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
        
        self.mothershipSlots.append(MothershipSlot(x: 0, y: 0))
        self.mothershipSlots.append(MothershipSlot(x: 95, y: 0))
        self.mothershipSlots.append(MothershipSlot(x: 191, y: 0))
        self.mothershipSlots.append(MothershipSlot(x: 286, y: 0))
        
        for mothershipSlot in self.mothershipSlots {
            self.addChild(mothershipSlot)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(slots: NSSet?) {
        if let slots = slots {
            for item in slots {
                if let mothershipSlotData = item as? MothershipSlotData {
                    if let spaceshipData = mothershipSlotData.spaceship {
                        let index = Int(mothershipSlotData.index)
                        let spaceship = Spaceship(spaceshipData: spaceshipData)
                        self.loadMothershipSlot(index: index, spaceship: spaceship)
                    }
                }
            }
        }
    }
    
    func loadMothershipSlot(index: Int, spaceship: Spaceship) {
        switch index {
        case 0, 1, 2, 3:
            self.mothershipSlots[index].load(spaceship: spaceship)
            break
        default:
            break
        }
    }

}
