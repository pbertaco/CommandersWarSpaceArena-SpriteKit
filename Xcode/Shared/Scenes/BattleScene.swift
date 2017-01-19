//
//  BattleScene.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/18/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class BattleScene: GameScene {
    
    var gameWorld: GameWorld!
    var gameCamera: GameCamera!
    
    enum zPosition: CGFloat {
        case gameWorld = 0
        case hud = 100
    }

    init() {
        let size = CGSize(
            width: (1920.0 + GameScene.viewBoundsSize.width)/2,
            height: (1080.0 + GameScene.viewBoundsSize.height)/2)
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func load() {
        
        self.backgroundColor = GameColors.backgroundColor
        
        self.gameWorld = GameWorld()
        self.gameWorld.zPosition = zPosition.gameWorld.rawValue
        self.addChild(self.gameWorld)
        
        self.gameCamera = GameCamera()
        self.gameCamera.node = self.gameWorld
        self.gameWorld.addChild(self.gameCamera)
        self.gameCamera.update()
        self.gameCamera.node = nil
        
        let spaceship = Spaceship()
        
        self.gameWorld.addChild(spaceship)
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    override func didFinishUpdate() {
        super.didFinishUpdate()
        
    }
    
    override func touchDown(touch: UITouch) {
        super.touchDown(touch: touch)
    }
    
    override func touchMoved(touch: UITouch) {
        super.touchMoved(touch: touch)
        if self.gameCamera.node == nil {
            self.gameCamera.position = self.gameCamera.position + touch.delta
            self.gameCamera.update()
        }
    }
    
    override func touchUp(touch: UITouch) {
        super.touchUp(touch: touch)
    }
    
}
