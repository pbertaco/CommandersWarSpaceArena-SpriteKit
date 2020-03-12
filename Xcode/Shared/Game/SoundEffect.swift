//
//  SoundEffect.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 3/8/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class SoundEffect {
    
    enum effectType {
        case noEffect
        case explosion
        case laser
    }
    
    struct fileName {
        static var explosion = [
            "explosion1.m4a",
            "explosion2.m4a",
            "explosion3.m4a",
            "explosion4.m4a",
            "explosion6.m4a"
        ]
        static var laser = [
            "laser2.m4a"
        ]
    }
    
    var actions = [SKAction]()
    
    init(fileName: String) {
        self.actions.append(SKAction.playSoundFileNamed(fileName, waitForCompletion: true))
    }
    
    init(effectType: effectType) {
        var fileNames = [String]()
        
        switch effectType {
        case .noEffect:
            break
        case .explosion:
            fileNames = fileName.explosion
            break
        case .laser:
            fileNames = fileName.laser
            break
        }
        
        for fileName in fileNames {
            self.actions.append(SKAction.playSoundFileNamed(fileName, waitForCompletion: true))
        }
    }
    
    func play() {
        if MemoryCard.sharedInstance.playerData.sound {
            if self.actions.count > 1 {
                GameScene.current?.run(self.actions[Int.random(self.actions.count)])
            } else {
                for action in self.actions {
                    GameScene.current?.run(action)
                }
            }
        }
    }
    
}
