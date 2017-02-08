//
//  ControlPoints.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/17/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class ControlPremiumPoints: Control {
    
    static func current() -> ControlPremiumPoints? {
        return ControlPremiumPoints.lastInstance
    }
    private static weak var lastInstance: ControlPremiumPoints? = nil
    
    private var labelPremiumPoints: Label!

    init(x: CGFloat, y: CGFloat,
         horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top) {
        
        super.init(imageNamed: "box144x55", x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
        
        self.set(color: GameColors.controlYellow)
        
        let buttonBuyMore = Button(imageNamed: "button55x55", x: 144, y: 0)
        buttonBuyMore.setIcon(imageNamed: "Plus")
        buttonBuyMore.set(color: GameColors.controlYellow, blendMode: .add)
        self.addChild(buttonBuyMore)
        
        self.labelPremiumPoints = Label(text: "?", fontColor: GameColors.controlYellow, x: 99, y: 27)
        self.addChild(labelPremiumPoints)
        
        let icon = Control(imageNamed: "Minecraft Diamond", x: 0, y: 0)
        icon.size = CGSize(width: 55, height: 55)
        icon.set(color: GameColors.controlYellow)
        self.addChild(icon)
        
        ControlPremiumPoints.lastInstance = self
        
        buttonBuyMore.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelPremiumPointsText(premiumPoints: Int32) {
        self.labelPremiumPoints.text = premiumPoints.description
    }
}
