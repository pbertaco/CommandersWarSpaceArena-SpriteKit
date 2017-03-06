//
//  Stars.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 2/15/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class Stars: SKNode {
    
    override init() {
        let texture = SKTexture(imageNamed: "stars", filteringMode: GameScene.defaultFilteringMode)
        super.init()
        self.zPosition = GameWorld.zPosition.stars.rawValue
        
        for y in 0...Int(GameScene.currentSize.height / texture.size().height) {
            for x in 0...Int(GameScene.currentSize.width / texture.size().width) {
                let spriteNode = SKSpriteNode(texture: texture)
                spriteNode.position = CGPoint(x: Int(texture.size().width) * x, y: Int(texture.size().height) * -y)
                self.addChild(spriteNode)
            }
        }
        
        let size = self.calculateAccumulatedFrame().size
        self.position.x = -GameScene.currentSize.width/2 + texture.size().width/2
        self.position.y = GameScene.currentSize.height/2 - texture.size().height/2
        
        self.position.x = self.position.x + (GameScene.currentSize.width - size.width)/2
        self.position.y = self.position.y - (GameScene.currentSize.height - size.height)/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
