//
//  GameWorld.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/18/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameWorld: SKNode {
    
    enum zPosition: CGFloat {
        case player
    }
    
    static func current() -> GameWorld? {
        return GameWorld.lastInstance
    }
    private static weak var lastInstance: GameWorld? = nil
    
    override init() {
        super.init()
        
        GameWorld.lastInstance = self
        self.addChild(SKSpriteNode(imageNamed: "gameWorld"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
