//
//  LoadScene.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/10/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class LoadScene: GameScene {
    
    init() {
        GameScene.defaultSize = CGSize(width: 667, height: 375)
        super.init()
        
        self.backgroundColor = GameColors.loadSceneBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func load() {
        super.load()
        
        #if DEBUG
            self.view?.showsFPS = true
            //self.view?.showsNodeCount = true
            //self.view?.showsPhysics = true
            
            //MemoryCard.sharedInstance.reset()
        #endif
        
        self.addChild(Control(imageNamed: "launchScreenLandscape", x: 0, y: 0, horizontalAlignment: .center, verticalAlignment: .center))
    }
}
