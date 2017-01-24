//
//  ControlPoints.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/17/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class ControlPoints: Control {
    
    private var labelPoints: Label!
    
    init(x: CGFloat, y: CGFloat,
         horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top) {
        
        super.init(imageNamed: "box144x55", x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
        
        self.color = GameColors.controlBlue
        self.colorBlendFactor = 1
        
        self.labelPoints = Label(text: "?", fontColor: GameColors.controlBlue, x: 99, y: 27)
        self.addChild(labelPoints)
        
        let icon = Control(imageNamed: "Coins", x: 0, y: 0)
        icon.size = CGSize(width: 55, height: 55)
        icon.color = GameColors.controlBlue
        icon.colorBlendFactor = 1
        self.addChild(icon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelPointsText(points: Int32) {
        self.labelPoints.text = points.description
    }
}
