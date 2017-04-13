//
//  ControlMission.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 2/2/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class ControlMission: Control {
    
    weak var buttonChooseMission: Button!
    
    init(x: CGFloat, y: CGFloat,
         horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top) {
        
        super.init(imageNamed: "box_233x89", x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        let sector = playerData.botLevel / 10
        let mission = playerData.botLevel % 10
        
        self.addChild(Label(text: "Sector \(sector + 1).\(mission + 1)", x: 151, y: 44))
        
        self.buttonChooseMission = Button(imageNamed: "button_55x55", x: 17, y: 17)
        self.buttonChooseMission.setIcon(imageNamed: "Waypoint Map")
        self.buttonChooseMission.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(self.buttonChooseMission)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
