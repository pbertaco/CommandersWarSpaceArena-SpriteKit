//
//  CommandersWarewController.swift
//  macOS
//
//  Created by Pablo Henrique Bertaco on 1/10/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import Cocoa
import SpriteKit

class GameViewController: NSViewController, NSWindowDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameScene.viewBoundsSize = self.view.bounds.size
        
        let scene = LoadScene()
        
        // Present the scene
        (self.view as? SKView)?.presentScene(scene)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if let window = self.view.window {
            window.delegate = self
            window.toggleFullScreen(nil)
        }
    }
    
    func windowDidResize(_ notification: Notification) {
        if let view = self.view as? SKView {
            if let scene = view.scene {
                GameScene.viewBoundsSize = self.view.bounds.size
                GameScene.updateSize()
                scene.size = GameScene.currentSize
            }
        }
    }
}
