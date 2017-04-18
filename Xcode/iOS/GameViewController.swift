//
//  CommandersWarewController.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/10/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameScene.viewBoundsSize = self.view.bounds.size
        
        let scene = LoadScene()

        // Present the scene
        (self.view as? SKView)?.presentScene(scene)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let view = self.view as? SKView {
            if let scene = view.scene {
                GameScene.viewBoundsSize = self.view.bounds.size
                GameScene.updateSize()
                scene.size = GameScene.currentSize
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue | UIInterfaceOrientationMask.portraitUpsideDown.rawValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
