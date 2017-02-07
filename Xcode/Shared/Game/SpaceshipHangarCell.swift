//
//  SpaceshipHangarCell.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 2/1/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class SpaceshipHangarCell: Control {
    
    var labelLevel: Label!
    var labelDamage: Label!
    var labelMaxHealth: Label!
    var labelWeaponRange: Label!
    var labelSpeedAtribute: Label!
    
    var labelXP: Label!
    
    var control0: Control?
    var control1: Control?
    
    private weak var spaceship: Spaceship?

    init(spaceship: Spaceship, loadButtonSell: Bool = true) {
        super.init(imageNamed: "box233x144", x: 0, y: 0)
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        let mothershipSlot = MothershipSlot(x: 19, y: 8)
        mothershipSlot.load(spaceship: spaceship)
        self.addChild(mothershipSlot)
        
        
        self.addChild(Label(text: "level", horizontalAlignmentMode: .right, fontSize: .fontSize8, fontColor: GameColors.fontWhite, x: 172, y: 23))
        self.labelLevel = Label(text: spaceship.level.description, horizontalAlignmentMode: .left, fontSize: .fontSize8, fontColor: GameColors.fontWhite, x: 179, y: 23)
        self.addChild(self.labelLevel)
        
        self.addChild(Label(text: "damage", horizontalAlignmentMode: .right, fontSize: .fontSize8, fontColor: GameColors.fontWhite, x: 172, y: 38))
        self.labelDamage = Label(text: spaceship.damage.description, horizontalAlignmentMode: .left, fontSize: .fontSize8, fontColor: GameColors.fontWhite, x: 179, y: 38)
        self.addChild(self.labelDamage)
        
        self.addChild(Label(text: "life", horizontalAlignmentMode: .right, fontSize: .fontSize8, fontColor: GameColors.fontWhite, x: 172, y: 53))
        self.labelMaxHealth = Label(text: spaceship.maxHealth.description, horizontalAlignmentMode: .left, fontSize: .fontSize8, fontColor: GameColors.fontWhite, x: 179, y: 53)
        self.addChild(self.labelMaxHealth)
        
        self.addChild(Label(text: "range", horizontalAlignmentMode: .right, fontSize: .fontSize8, fontColor: GameColors.fontWhite, x: 172, y: 68))
        self.labelWeaponRange = Label(text: Int(spaceship.weaponRange).description, horizontalAlignmentMode: .left, fontSize: .fontSize8, fontColor: GameColors.fontWhite, x: 179, y: 68)
        self.addChild(self.labelWeaponRange)
        
        self.addChild(Label(text: "speed", horizontalAlignmentMode: .right, fontSize: .fontSize8, fontColor: GameColors.fontWhite, x: 172, y: 83))
        self.labelSpeedAtribute = Label(text: spaceship.speedAtribute.description, horizontalAlignmentMode: .left, fontSize: .fontSize8, fontColor: GameColors.fontWhite, x: 179, y: 83)
        self.addChild(self.labelSpeedAtribute)
        
        if let spaceshipData = spaceship.spaceshipData {
            
            if spaceship.level < 10 {
                var xp: Int32 = Int32(GameMath.xpForLevel(level: spaceship.level + 1))
                
                let buttonUpgrade = Button(imageNamed: "button89x34", x: 19, y: 102)
                
                buttonUpgrade.set(label: Label(text: "upgrade", fontSize: .fontSize8, fontColor: GameColors.controlBlue, y: -6))
                buttonUpgrade.set(label: Label(text: xp > 0 ? "\(xp)" : "free", fontSize: .fontSize8, fontColor: GameColors.controlBlue, y: 6))
                
                buttonUpgrade.set(color: GameColors.controlBlue, blendMode: .add)
                self.addChild(buttonUpgrade)
                
                buttonUpgrade.touchUpEvent = { [weak self, weak buttonUpgrade, weak spaceship] in
                    if let spaceship = spaceship {
                        
                        if playerData.points >= xp {
                            playerData.points = playerData.points - xp
                            
                            spaceship.level = spaceship.level + 1
                            spaceship.updateAttributes()
                            
                            xp = Int32(GameMath.xpForLevel(level: spaceship.level + 1))
                            
                            buttonUpgrade?.text = xp.description
                            
                            self?.updateLabels(spaceship: spaceship)
                            
                            ControlPoints.current()?.setLabelPointsText(points: playerData.points)
                            
                            if spaceship.level >= 10 {
                                buttonUpgrade?.removeFromParent()
                            }
                        }
                    }
                }
            }
            
            
            if let mothershipSlot = spaceshipData.parentMothershipSlot {
                let control = Control(imageNamed: "box89x34", x: 125, y: 102)
                control.addChild(Control(imageNamed: "slotIndex\(mothershipSlot.index)", x: 2, y: 8))
                self.addChild(control)
                self.control1 = control
            } else {
                if loadButtonSell {
                    let buttonSell = Button(imageNamed: "button89x34", x: 125, y: 102)
                    buttonSell.set(label: Label(text: "sell", fontSize: .fontSize8, fontColor: GameColors.controlBlue))
                    buttonSell.set(color: GameColors.controlBlue, blendMode: .add)
                    self.addChild(buttonSell)
                    buttonSell.touchUpEvent = {
                        
                    }
                    buttonSell.isHidden = true
                    self.control1 = buttonSell
                }
            }
        }
        
        self.spaceship = spaceship
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabels(spaceship: Spaceship) {
        self.labelLevel.text = spaceship.level.description
        self.labelDamage.text = spaceship.damage.description
        self.labelMaxHealth.text = spaceship.maxHealth.description
        self.labelWeaponRange.text = Int(spaceship.weaponRange).description
        self.labelSpeedAtribute.text = spaceship.speedAtribute.description
    }
    
    func spaceshipData() -> SpaceshipData? {
        return self.spaceship?.spaceshipData
    }
}
