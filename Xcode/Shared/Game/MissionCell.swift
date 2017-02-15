//
//  MissionCell.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 2/14/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class MissionCell: Control {
    
    enum status {
        case available
        case completed
        case locked
    }

    
    init(missionIndex: Int, status: status, recommended: Bool, buttonPlayHandler block: @escaping () -> Void) {
        super.init(imageNamed: "box233x144", x: 0, y: 0)
        
        let mission = Mission.types[missionIndex]
        
        let control = Control(imageNamed: "box89x89", x: 19, y: 8)
        self.addChild(control)
        
        let sphere = Control(imageNamed: "Sphere", x: 0, y: 0)
        sphere.setScaleToFit(size: control.size)
        sphere.set(color: mission.color)
        control.addChild(sphere)
        
        
        let sectorNumber = missionIndex / 10 + 1
        let missionNumber = missionIndex % 10 + 1
        
        self.addChild(Label(text: "sector \(sectorNumber).\(missionNumber)", fontColor: .white, x: 168, y: 36))
        
        var labelText = ""
        var loadButtonStart = false
        
        switch status {
        case .available:
            labelText = "available"
            loadButtonStart = true
            break
        case .completed:
            labelText = "completed"
            loadButtonStart = true
            break
        case .locked:
            labelText = "locked"
            break
        }
        
        if loadButtonStart {
            let buttonPlayColor = recommended ? GameColors.controlRed : GameColors.controlBlue
            let buttonPlay = Button(imageNamed: "button89x34", x: 125, y: 102)
            buttonPlay.setIcon(imageNamed: "Play")
            buttonPlay.set(color: buttonPlayColor, blendMode: .add)
            self.addChild(buttonPlay)
            
            buttonPlay.addHandler {
                let playerData = MemoryCard.sharedInstance.playerData!
                playerData.botLevel = Int16(missionIndex)
            }
            
            buttonPlay.addHandler(block: block)
        }
        
        self.addChild(Label(text: labelText, fontColor: .white, x: 168, y: 71))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
