//
//  SpaceshipHangarCell.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 2/1/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class SpaceshipHangarCell: Control {
    
    weak var labelLevel: Label!
    weak var labelDamage: Label!
    weak var labelMaxHealth: Label!
    weak var labelWeaponRange: Label!
    weak var labelSpeedAtribute: Label!
    
    weak var control0: Control?
    weak var control1: Control?
    
    private weak var spaceship: Spaceship?

    init(spaceship: Spaceship) {
        super.init(imageNamed: "box233x144", x: 0, y: 0)
        
        let mothershipSlot = MothershipSlot(x: 19, y: 8)
        mothershipSlot.load(spaceship: spaceship)
        self.addChild(mothershipSlot)
        
        self.addChild(Label(text: "level", horizontalAlignmentMode: .right, fontName: .kenPixel, fontSize: .fontSize8, x: 172, y: 23))
        self.labelLevel = Label(text: spaceship.level.description, horizontalAlignmentMode: .left, fontName: .kenPixel, fontSize: .fontSize8, x: 179, y: 23)
        self.addChild(self.labelLevel)
        
        self.addChild(Label(text: "damage", horizontalAlignmentMode: .right, fontName: .kenPixel, fontSize: .fontSize8, x: 172, y: 38))
        self.labelDamage = Label(text: spaceship.damage.description, horizontalAlignmentMode: .left, fontName: .kenPixel, fontSize: .fontSize8, x: 179, y: 38)
        self.addChild(self.labelDamage)
        
        self.addChild(Label(text: "life", horizontalAlignmentMode: .right, fontName: .kenPixel, fontSize: .fontSize8, x: 172, y: 53))
        self.labelMaxHealth = Label(text: spaceship.maxHealth.description, horizontalAlignmentMode: .left, fontName: .kenPixel, fontSize: .fontSize8, x: 179, y: 53)
        self.addChild(self.labelMaxHealth)
        
        self.addChild(Label(text: "range", horizontalAlignmentMode: .right, fontName: .kenPixel, fontSize: .fontSize8, x: 172, y: 68))
        self.labelWeaponRange = Label(text: Int(spaceship.weaponRange).description, horizontalAlignmentMode: .left, fontName: .kenPixel, fontSize: .fontSize8, x: 179, y: 68)
        self.addChild(self.labelWeaponRange)
        
        self.addChild(Label(text: "speed", horizontalAlignmentMode: .right, fontName: .kenPixel, fontSize: .fontSize8, x: 172, y: 83))
        self.labelSpeedAtribute = Label(text: spaceship.speedAtribute.description, horizontalAlignmentMode: .left, fontName: .kenPixel, fontSize: .fontSize8, x: 179, y: 83)
        self.addChild(self.labelSpeedAtribute)
        
        self.spaceship = spaceship
        
        if let spaceshipData = spaceship.spaceshipData {
            
            self.loadButtonUpgrade()
            
            if spaceshipData.parentMothershipSlot != nil {
                self.loadControlSlot()
            } else {
                self.loadButtonSell()
            }
        } else {
            self.lock()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadButtonUpgrade() {
        guard let spaceship = self.spaceship else { return }
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        if spaceship.level < 10 {
            var xp: Int32 = Int32(GameMath.xpForLevel(level: spaceship.level + 1))
            
            let buttonUpgrade = Button(imageNamed: "button89x34", x: 19, y: 102)
            
            buttonUpgrade.set(label: Label(text: "upgrade", fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.controlBlue, y: -6))
            buttonUpgrade.set(label: Label(text: xp > 0 ? "\(xp)" : "free", fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.controlBlue, y: 6))
            
            buttonUpgrade.set(color: GameColors.controlBlue, blendMode: .add)
            self.addChild(buttonUpgrade)
            
            buttonUpgrade.addHandler { [weak self, weak buttonUpgrade, weak spaceship] in
                if let spaceship = spaceship {
                    
                    if playerData.points >= xp {
                        playerData.points = playerData.points - xp
                        
                        spaceship.level = spaceship.level + 1
                        spaceship.updateAttributes()
                        
                        self?.loadButtonSell()
                        
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
            self.control0?.removeFromParent()
            self.control0 = buttonUpgrade
        }
    }
    
    func loadControlSlot(duration sec: TimeInterval = 0) {
        guard let mothershipSlotIndex = self.spaceship?.spaceshipData?.parentMothershipSlot?.index else { return }
    
        let control = Control(imageNamed: "box89x34", x: 125, y: 102)
        control.addChild(Control(imageNamed: "slotIndex\(mothershipSlotIndex)", x: 2, y: 8))
        self.addChild(control)
        
        self.control1?.isUserInteractionEnabled = false
        self.control1?.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: sec), SKAction.removeFromParent()]))
        control.alpha = 0
        control.run(SKAction.fadeAlpha(to: 1, duration: sec))
        
        self.control1 = control
    }
    
    func loadButtonSell(duration sec: TimeInterval = 0) {
        guard let spaceship = self.spaceship else { return }
        
        if spaceship.spaceshipData?.parentMothershipSlot != nil {
            return
        }
        
        let points: Int32 = Int32(GameMath.xpForLevel(level: spaceship.level))
        
        let buttonSell = Button(imageNamed: "button89x34", x: 125, y: 102)
        buttonSell.set(label: Label(text: "sell", fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.controlBlue, y: -6))
        buttonSell.set(label: Label(text: "+\(points.pointsString())", fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.controlBlue, y: 6))
        buttonSell.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonSell)
        buttonSell.addHandler { [weak self] in
            self?.sell(points: points)
        }
        
        self.control1?.isUserInteractionEnabled = false
        self.control1?.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: sec), SKAction.removeFromParent()]))
        buttonSell.alpha = 0
        buttonSell.run(SKAction.fadeAlpha(to: 1, duration: sec))
        
        self.control1 = buttonSell
    }
    
    func sell(points: Int32) {
        guard let spaceship = self.spaceship else { return }
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        if let spaceshipData = spaceship.spaceshipData {
            playerData.removeFromSpaceships(spaceshipData)
            
            playerData.points = playerData.points + points
            ControlPoints.current()?.setLabelPointsText(points: playerData.points)
        }
        self.spaceship = nil
        self.removeAllChildren()
        self.isHidden = true
    }
    
    private func lock() {
        guard let spaceship = self.spaceship else { return }
        
        spaceship.isHidden = true
        
        var rocketColor: SKColor = .clear
        switch spaceship.rarity {
        case .common:
            rocketColor = GameColors.common
            break
        case .rare:
            rocketColor = GameColors.rare
            break
        case .epic:
            rocketColor = GameColors.epic
            break
        case .legendary:
            rocketColor = GameColors.legendary
            break
        }
        
        let rocket = Control(imageNamed: "Rocket", x: 19, y: 8)
        rocket.setScaleToFit(size: CGSize(width: 89, height: 89))
        rocket.set(color: rocketColor, blendMode: .add)
        self.addChild(rocket)
        
        let circuit = Control(imageNamed: "Circuit", x: 19, y: 8)
        circuit.setScaleToFit(size: CGSize(width: 89, height: 89))
        circuit.set(color: GameColors.controlYellow, blendMode: .add)
        self.addChild(circuit)
        
        self.labelLevel.text = self.spaceship?.level.description ?? "?"
        self.labelDamage.text = "?"
        self.labelMaxHealth.text = "?"
        self.labelWeaponRange.text = "?"
        self.labelSpeedAtribute.text = "?"
        
        let buttonIgnore = Button(imageNamed: "button89x34", x: 19, y: 102)
        buttonIgnore.set(color: GameColors.controlBlue)
        buttonIgnore.set(label: Label(text: "Ignore", fontSize: .fontSize8, fontColor: GameColors.controlBlue))
        self.addChild(buttonIgnore)
        self.control0 = buttonIgnore
        
        let buttonUnlock = Button(imageNamed: "button89x34", x: 125, y: 102)
        buttonUnlock.set(color: GameColors.controlYellow)
        let priceInPremiumPoints = GameMath.unlockSpaceshipPriceInPremiumPoints(rarity: spaceship.rarity)
        buttonUnlock.set(label: Label(text: "unlock", fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.controlYellow, y: -6))
        buttonUnlock.set(label: Label(text: "\(priceInPremiumPoints)", fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.controlYellow, y: 6))
        self.addChild(buttonUnlock)
        self.control1 = buttonUnlock
        
        buttonUnlock.addHandler { [weak self, weak rocket, weak circuit] in
            guard let this = self else { return }
            this.unlockWithPremiumPoints()
            self?.spaceship?.isHidden = false
            self?.control0?.isHidden = true
            self?.control1?.isHidden = true
            rocket?.removeFromParent()
            circuit?.removeFromParent()
        }
    }
    
    func unlockWithPremiumPoints() {
        guard let spaceship = self.spaceship else { return }
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        self.control0?.removeFromParent()
        self.control1?.removeFromParent()
        
        let price = Int32(GameMath.unlockSpaceshipPriceInPremiumPoints(rarity: spaceship.rarity))
        
        if playerData.premiumPoints >= price {
            playerData.premiumPoints = playerData.premiumPoints - price
            self.forceUnlock(spaceship: spaceship)
            self.loadButtonUpgrade()
            self.loadButtonSell()
        }
    }
    
    func buyWithPremiumPoints() -> Bool {
        guard let spaceship = self.spaceship else { return false }
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        let price = Int32(GameMath.buySpaceshipPriceInPremiumPoints(rarity: spaceship.rarity))
        
        if playerData.premiumPoints >= price {
            playerData.premiumPoints = playerData.premiumPoints - price
            self.forceUnlock(spaceship: spaceship)
            return true
        }
        
        return false
    }
    
    func buyWithPoints() -> Bool {
        guard let spaceship = self.spaceship else { return false }
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        let price = Int32(GameMath.buySpaceshipPriceInPoints(rarity: spaceship.rarity))
        
        if playerData.points >= price {
            playerData.points = playerData.points - price
            self.forceUnlock(spaceship: spaceship)
            return true
        }
        
        return false
    }
    
    private func forceUnlock(spaceship: Spaceship) {
        let memoryCard = MemoryCard.sharedInstance
        let playerData = memoryCard.playerData!
        
        let spaceshipData = memoryCard.newSpaceshipData(spaceship: spaceship)
        playerData.addToSpaceships(spaceshipData)
        
        self.updateLabels(spaceship: spaceship)
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
