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
    weak var labelElement: Label!
    weak var labelDamage: Label!
    weak var labelMaxHealth: Label!
    weak var labelWeaponRange: Label!
    weak var labelSpeedAtribute: Label!
    
    weak var control0: Control?
    weak var control1: Control?
    
    weak var spaceship: Spaceship?

    init(spaceship: Spaceship, sellCompletion block: @escaping () -> Void) {
        super.init(imageNamed: "box_233x144", x: 0, y: 0)
        
        let mothershipSlot = MothershipSlot(x: 19, y: 8)
        mothershipSlot.load(spaceship: spaceship)
        self.addChild(mothershipSlot)
        
        self.addChild(Label(text: "level", horizontalAlignmentMode: .right, fontName: .kenPixel, fontSize: .fontSize8, x: 172, y: 16))
        self.labelLevel = Label(text: "", horizontalAlignmentMode: .left, fontName: .kenPixel, fontSize: .fontSize8, x: 179, y: 16)
        self.addChild(self.labelLevel)
        
        self.addChild(Label(text: "element", horizontalAlignmentMode: .right, fontName: .kenPixel, fontSize: .fontSize8, x: 172, y: 31))
        self.labelElement = Label(text: "", horizontalAlignmentMode: .left, fontName: .kenPixel, fontSize: .fontSize8, x: 179, y: 31)
        self.addChild(self.labelElement)
        
        self.addChild(Label(text: "damage", horizontalAlignmentMode: .right, fontName: .kenPixel, fontSize: .fontSize8, x: 172, y: 45))
        self.labelDamage = Label(text: "", horizontalAlignmentMode: .left, fontName: .kenPixel, fontSize: .fontSize8, x: 179, y: 45)
        self.addChild(self.labelDamage)
        
        self.addChild(Label(text: "life", horizontalAlignmentMode: .right, fontName: .kenPixel, fontSize: .fontSize8, x: 172, y: 60))
        self.labelMaxHealth = Label(text: "", horizontalAlignmentMode: .left, fontName: .kenPixel, fontSize: .fontSize8, x: 179, y: 60)
        self.addChild(self.labelMaxHealth)
        
        self.addChild(Label(text: "range", horizontalAlignmentMode: .right, fontName: .kenPixel, fontSize: .fontSize8, x: 172, y: 74))
        self.labelWeaponRange = Label(text: "", horizontalAlignmentMode: .left, fontName: .kenPixel, fontSize: .fontSize8, x: 179, y: 74)
        self.addChild(self.labelWeaponRange)
        
        self.addChild(Label(text: "speed", horizontalAlignmentMode: .right, fontName: .kenPixel, fontSize: .fontSize8, x: 172, y: 89))
        self.labelSpeedAtribute = Label(text: "", horizontalAlignmentMode: .left, fontName: .kenPixel, fontSize: .fontSize8, x: 179, y: 89)
        self.addChild(self.labelSpeedAtribute)
        
        self.spaceship = spaceship
        
        self.updateLabels(spaceship: spaceship)
        
        if let spaceshipData = spaceship.spaceshipData {
            
            self.loadButtonUpgrade()
            
            if spaceshipData.parentMothershipSlot != nil {
                self.loadControlSlot()
            } else {
                self.loadButtonSell(sellCompletion: block)
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
        
        if Int16(spaceship.level) < playerData.maxSpaceshipLevel {
            var xp: Int32 = Int32(GameMath.xpForLevel(level: spaceship.level + 1))
            
            let buttonUpgrade = Button(imageNamed: "button_89x34", x: 19, y: 102)
            
            buttonUpgrade.set(label: Label(text: "upgrade", fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.points, y: -6))
            buttonUpgrade.set(label: Label(text: xp > 0 ? "\(xp)" : "free", fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.points, y: 6))
            
            buttonUpgrade.set(color: GameColors.points, blendMode: .add)
            self.addChild(buttonUpgrade)
            
            buttonUpgrade.addHandler { [weak self, weak buttonUpgrade, weak spaceship] in
                guard let `self` = self else { return }
                
                if let spaceship = spaceship {
                    
                    if playerData.points >= xp {
                        playerData.points = playerData.points - xp
                        
                        spaceship.level = spaceship.level + 1
                        spaceship.spaceshipData?.level = Int16(spaceship.level)
                        spaceship.updateAttributes()
                        
                        self.loadButtonSell(sellCompletion: {})
                        
                        xp = Int32(GameMath.xpForLevel(level: spaceship.level + 1))
                        
                        buttonUpgrade?.text = "\(xp)"
                        
                        self.updateLabels(spaceship: spaceship)
                        
                        ControlPoints.current()?.setLabelPointsText(points: playerData.points)
                        
                        if Int16(spaceship.level) >= playerData.maxSpaceshipLevel {
                            buttonUpgrade?.removeFromParent()
                            #if os(iOS)
                                GameViewController.sharedInstance()?.save(achievementIdentifier: "masterEngineer")
                            #endif
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
    
        let control = Control(imageNamed: "box_89x34", x: 125, y: 102)
        control.addChild(Control(imageNamed: "slotIndex\(mothershipSlotIndex)", x: 2, y: 8))
        self.addChild(control)
        
        self.control1?.isUserInteractionEnabled = false
        self.control1?.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: sec), SKAction.removeFromParent()]))
        control.alpha = 0
        control.run(SKAction.fadeAlpha(to: 1, duration: sec))
        
        self.control1 = control
    }
    
    func loadButtonSell(duration sec: TimeInterval = 0, sellCompletion block: @escaping () -> Void) {
        guard let spaceship = self.spaceship else { return }
        
        if spaceship.spaceshipData?.parentMothershipSlot != nil {
            return
        }
        
        let points: Int32 = Int32(GameMath.xpForLevel(level: spaceship.level))
        
        let buttonSell = Button(imageNamed: "button_89x34", x: 125, y: 102)
        buttonSell.set(label: Label(text: "sell", fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.points, y: -6))
        buttonSell.set(label: Label(text: "+\(points.pointsString())", fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.points, y: 6))
        buttonSell.set(color: GameColors.points, blendMode: .add)
        self.addChild(buttonSell)
        buttonSell.addHandler { [weak self] in
            guard let `self` = self else { return }
            self.loadBoxSellSpaceship(points: points, completion: block)
        }
        
        self.control1?.isUserInteractionEnabled = false
        self.control1?.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: sec), SKAction.removeFromParent()]))
        buttonSell.alpha = 0
        buttonSell.run(SKAction.fadeAlpha(to: 1, duration: sec))
        
        self.control1 = buttonSell
    }
    
    func loadBoxSellSpaceship(points: Int32, completion block: @escaping () -> Void) {
        guard let spaceship = self.spaceship else { return }
        
        let box = BoxSellSpaceship(spaceship: spaceship, points: points)
        if let scene = GameScene.current() {
            scene.blackSpriteNode.isHidden = false
            scene.blackSpriteNode.zPosition = HangarScene.zPosition.blackSpriteNode.rawValue
            box.zPosition = HangarScene.zPosition.box.rawValue
            scene.addChild(box)
        }
        
        box.buttonSell?.addHandler {
            let playerData = MemoryCard.sharedInstance.playerData!
            
            if let spaceshipData = spaceship.spaceshipData {
                playerData.removeFromSpaceships(spaceshipData)
                
                playerData.points = playerData.points + points
                ControlPoints.current()?.setLabelPointsText(points: playerData.points)
            }
            block()
        }
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
        circuit.set(color: GameColors.premiumPoints, blendMode: .add)
        self.addChild(circuit)
        
        self.labelLevel.text = self.spaceship?.level.description ?? "?"
        self.labelElement.text = "?"
        self.labelDamage.text = "?"
        self.labelMaxHealth.text = "?"
        self.labelWeaponRange.text = "?"
        self.labelSpeedAtribute.text = "?"
        
        let buttonIgnore = Button(imageNamed: "button_89x34", x: 19, y: 102)
        buttonIgnore.set(color: GameColors.controlBlue)
        buttonIgnore.set(label: Label(text: "Ignore", fontSize: .fontSize8, fontColor: GameColors.controlBlue))
        self.addChild(buttonIgnore)
        self.control0 = buttonIgnore
        
        let buttonUnlock = Button(imageNamed: "button_89x34", x: 125, y: 102)
        buttonUnlock.set(color: GameColors.premiumPoints)
        let priceInPremiumPoints = GameMath.unlockSpaceshipPriceInPremiumPoints(rarity: spaceship.rarity)
        buttonUnlock.set(label: Label(text: "unlock", fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.premiumPoints, y: -6))
        buttonUnlock.set(label: Label(text: "\(priceInPremiumPoints)", fontName: .kenPixel, fontSize: .fontSize8, fontColor: GameColors.premiumPoints, y: 6))
        self.addChild(buttonUnlock)
        self.control1 = buttonUnlock
        
        buttonUnlock.addHandler { [weak self, weak rocket, weak circuit] in
            guard let `self` = self else { return }
            self.unlockWithPremiumPoints()
            self.spaceship?.isHidden = false
            self.control0?.isHidden = true
            self.control1?.isHidden = true
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
            self.loadButtonSell(sellCompletion: {})
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
        
        #if os(iOS)
            if let spaceships = playerData.spaceships {
                if spaceships.count >= 16 {
                    GameViewController.sharedInstance()?.save(achievementIdentifier: "collectorsEdition")
                }
            }
            
            if spaceship.rarity == .legendary {
                GameViewController.sharedInstance()?.save(achievementIdentifier: "nowWeReTalking")
            }
        #endif
    }
    
    func updateLabels(spaceship: Spaceship) {
        self.labelLevel.text = spaceship.level.description
        self.labelElement.text = spaceship.element.element.rawValue
        self.labelDamage.text = "\(spaceship.damage)"
        self.labelMaxHealth.text = "\(spaceship.maxHealth)"
        self.labelWeaponRange.text = "\(Int(spaceship.weaponRange))"
        self.labelSpeedAtribute.text = "\(spaceship.speedAtribute)"
    }
    
    func clearLabelColors() {
        self.labelLevel.set(color: GameColors.fontWhite)
        self.labelDamage.set(color: GameColors.fontWhite)
        self.labelMaxHealth.set(color: GameColors.fontWhite)
        self.labelWeaponRange.set(color: GameColors.fontWhite)
        self.labelSpeedAtribute.set(color: GameColors.fontWhite)
    }
    
    func compareTo(spaceshipHangarCell: SpaceshipHangarCell) {
        
        guard let spaceship = spaceshipHangarCell.spaceship else { return }
        
        if let me = self.spaceship {
            
            if me.baseDamage != spaceship.baseDamage {
                me.baseDamage > spaceship.baseDamage ? self.labelDamage.set(color: GameColors.fontGreen) : self.labelDamage.set(color: GameColors.fontRed)
            } else {
                self.labelDamage.set(color: GameColors.fontWhite)
            }
            
            if me.baseLife != spaceship.baseLife {
                me.baseLife > spaceship.baseLife ? self.labelMaxHealth.set(color: GameColors.fontGreen) : self.labelMaxHealth.set(color: GameColors.fontRed)
            } else {
                self.labelMaxHealth.set(color: GameColors.fontWhite)
            }
            
            if me.baseRange != spaceship.baseRange {
                me.baseRange > spaceship.baseRange ? self.labelWeaponRange.set(color: GameColors.fontGreen) : self.labelWeaponRange.set(color: GameColors.fontRed)
            } else {
                self.labelWeaponRange.set(color: GameColors.fontWhite)
            }
            
            if me.baseSpeed != spaceship.baseSpeed {
                me.baseSpeed > spaceship.baseSpeed ? self.labelSpeedAtribute.set(color: GameColors.fontGreen) : self.labelSpeedAtribute.set(color: GameColors.fontRed)
            } else {
                self.labelSpeedAtribute.set(color: GameColors.fontWhite)
            }
        }
    }
    
    func spaceshipData() -> SpaceshipData? {
        return self.spaceship?.spaceshipData
    }
}
