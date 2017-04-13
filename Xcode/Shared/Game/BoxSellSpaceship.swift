//
//  BoxSellSpaceship.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 13/04/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class BoxSellSpaceship: Box {

    init(spaceship: Spaceship) {
        super.init(imageNamed: "box_377x610")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
