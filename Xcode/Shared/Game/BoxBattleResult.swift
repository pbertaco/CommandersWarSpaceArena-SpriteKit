//
//  BoxBattleResult.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 2/3/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class BoxBattleResult: Box {
    
    weak var buttonOK: Button!
    
    var score = 0
    
    init(mothership: Mothership, botMothership: Mothership) {
        super.init(imageNamed: "box_233x610", y: 12)
        
        // Achievements
        var chickenMode = true
        var win = false
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        var title = ""
        
        if botMothership.health <= 0 && mothership.health <= 0 {
            title = "Draw"
        } else {
            if botMothership.health <= 0 {
                title = "Victory"
                win = true
            } else {
                title = "Defeat"
            }
        }
        
        self.addChild(Label(text: title, x: 117, y: 40))
        
        self.buttonOK = Button(imageNamed: "button_89x34", x: 72, y: 554)
        self.buttonOK.set(label: Label(text: "OK"))
        self.buttonOK.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(self.buttonOK)
        
        for spaceship in botMothership.spaceships {
            if spaceship.rarity != .common {
                chickenMode = false
            }
            
            if Int16(spaceship.rarity.rawValue) > playerData.maxBotRarity {
                playerData.maxBotRarity = Int16(spaceship.rarity.rawValue)
            }
            
            if Int16(spaceship.battleStartLevel) > playerData.maxSpaceshipLevel {
                playerData.maxSpaceshipLevel = Int16(spaceship.battleStartLevel)
            }
        }
        
        var totalBattlePoints: Int32 = 0
        for spaceship in mothership.spaceships {
            if spaceship.rarity == .common {
                chickenMode = false
            }
            totalBattlePoints += Int32(spaceship.battlePoints)
            if let spaceshipData = spaceship.spaceshipData {
                if spaceshipData.level < playerData.maxSpaceshipLevel {
                    spaceshipData.xp += Int32(spaceship.battlePoints)
                    let xp: Int32 = Int32(GameMath.xpForLevel(level: Int(spaceshipData.level) + 1))
                    
                    if spaceshipData.xp >= xp {
                        spaceshipData.xp -= xp
                        spaceshipData.level += 1
                    }
                }
            } else {
            }
        }
        
        playerData.points += totalBattlePoints
        self.score = Int(totalBattlePoints)
        
        #if os(iOS)
            GameViewController.sharedInstance()?.save(scoreValue: Int(totalBattlePoints))
            
            if win && chickenMode {
                GameViewController.sharedInstance()?.save(achievementIdentifier: "chickenMode")
            }
            
            let veryLowHealth = Double(mothership.health)/Double(mothership.maxHealth) <= 0.05
            if win && veryLowHealth {
                GameViewController.sharedInstance()?.save(achievementIdentifier: "GGEasy")
                
            }
        #endif
        
        let coins = Control(imageNamed: "Coins", x: 45, y: 73)
        coins.setScaleToFit(size: CGSize(width: 55, height: 55))
        coins.set(color: GameColors.points)
        self.addChild(coins)
        
        self.addChild(Label(text: "+\(totalBattlePoints.pointsString())", fontColor: GameColors.points, x: 144, y: 100))
        
        var i = 0
        var totalKills = 0
        var totalAssists = 0
        var totalDeaths = 0
        
        for spaceship in mothership.spaceships {
            let x: CGFloat = 21
            var y: CGFloat = 0
            
            switch i {
            case 0:
                y = 193
                break
            case 1:
                y = 235
                break
            case 2:
                y = 277
                break
            case 3:
                y = 319
                break
            default:
                fatalError()
                break
            }
            
            let mothershipSlot = MothershipSlot(x: x, y: y)
            mothershipSlot.load(spaceship: spaceship, createCopy: true)
            mothershipSlot.setScaleToFit(size: CGSize(width: 34, height: 34))
            self.addChild(mothershipSlot)
            
            self.addChild(Label(text: spaceship.level.description, fontColor: GameColors.controlBlue, x: 78, y: y + 17))
            
            self.addChild(Label(text: "\(spaceship.kills)/\(spaceship.deaths)/\(spaceship.assists)", fontColor: GameColors.controlBlue, x: 167, y: y + 17))
            
            totalKills += spaceship.kills
            totalDeaths += spaceship.deaths
            totalAssists += spaceship.assists
            
            i += 1
        }
        
        self.addChild(Label(text: "\(totalKills)/\(totalDeaths)/\(totalAssists)", fontColor: GameColors.controlBlue, x: 59, y: 160))
        
        i = 0
        totalKills = 0
        totalAssists = 0
        totalDeaths = 0
        
        for spaceship in botMothership.spaceships {
            let x: CGFloat = 21
            var y: CGFloat = 0
            
            switch i {
            case 0:
                y = 373
                break
            case 1:
                y = 415
                break
            case 2:
                y = 457
                break
            case 3:
                y = 499
                break
            default:
                fatalError()
                break
            }
            
            let mothershipSlot = MothershipSlot(x: x, y: y)
            mothershipSlot.load(spaceship: spaceship, createCopy: true)
            mothershipSlot.setScaleToFit(size: CGSize(width: 34, height: 34))
            self.addChild(mothershipSlot)
            
            self.addChild(Label(text: spaceship.level.description, fontColor: GameColors.controlRed, x: 78, y: y + 17))
            
            self.addChild(Label(text: "\(spaceship.kills)/\(spaceship.deaths)/\(spaceship.assists)", fontColor: GameColors.controlRed, x: 167, y: y + 17))
            
            totalKills += spaceship.kills
            totalDeaths += spaceship.deaths
            totalAssists += spaceship.assists
            
            i += 1
        }
        
        self.addChild(Label(text: "\(totalKills)/\(totalDeaths)/\(totalAssists)", fontColor: GameColors.controlRed, x: 174, y: 160))
        
        let controlHelp = Control(imageNamed: "box_233x34", x: 0, y: 610)
        controlHelp.isHidden = true
        self.addChild(controlHelp)
        controlHelp.addChild(Label(text: "Kills/Deaths/Assists", x: controlHelp.size.width/2, y: controlHelp.size.height/2))
        
        let buttonHelp = Button(imageNamed: "button_34x34", x: 178, y: 554)
        buttonHelp.setIcon(imageNamed: "Help")
        buttonHelp.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonHelp)
        buttonHelp.addHandler { [weak controlHelp] in
            if let controlHelp = controlHelp {
                controlHelp.isHidden = !controlHelp.isHidden
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
