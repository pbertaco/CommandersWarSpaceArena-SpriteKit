//
//  ControlPoints.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/17/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class ControlPoints: Control {
    
    static func current() -> ControlPoints? {
        return ControlPoints.lastInstance
    }
    private static weak var lastInstance: ControlPoints? = nil
    
    private var labelPoints: Label!
    
    
    static let numberFormatter = { () -> NumberFormatter in
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    init(x: CGFloat, y: CGFloat,
         horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top) {
        
        super.init(imageNamed: "box144x55", x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
        
        self.set(color: GameColors.controlBlue)
        
        self.labelPoints = Label(text: "?", fontColor: GameColors.controlBlue, x: 97, y: 27)
        self.addChild(labelPoints)
        
        let icon = Control(imageNamed: "Coins", x: 0, y: 0)
        icon.size = CGSize(width: 55, height: 55)
        
        icon.set(color: GameColors.controlBlue)
        self.addChild(icon)
        
        ControlPoints.lastInstance = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelPointsText(points: Int32) {
        self.labelPoints.text = points.pointsString()
    }
}

extension Int32 {
    func pointsString() -> String {
        return ControlPoints.numberFormatter.string(from: NSNumber(value: self))!
    }
}
