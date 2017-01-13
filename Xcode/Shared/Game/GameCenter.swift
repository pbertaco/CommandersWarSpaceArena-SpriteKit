//
//  GameCenter.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/12/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import GameKit

extension GameViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
    
    func presentGameCenterViewController() {
        guard GKLocalPlayer.localPlayer().isAuthenticated else { return }
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        self.present(gameCenterViewController, animated: true)
    }

    func authenticateLocalPlayer(completion block: @escaping () -> Void = {}) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let gameViewController = appDelegate?.window?.rootViewController as? GameViewController
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        if localPlayer.isAuthenticated {
            block()
        } else {
            localPlayer.authenticateHandler = { (viewController: UIViewController?, error: Error?) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let viewController = viewController {
                    gameViewController?.present(viewController, animated: true, completion: nil)
                }
                if localPlayer.isAuthenticated {
                    block()
                }
            }
        }
    }
    
    func save(score: Int) {
        if Metrics.canSendEvents() {
            if GKLocalPlayer.localPlayer().isAuthenticated {
                let scoreReporter = GKScore(leaderboardIdentifier: "\(Bundle.main.bundleIdentifier!).score")
                scoreReporter.value = Int64(score)
                GKScore.report([scoreReporter])
            } else {
                self.authenticateLocalPlayer { [weak self] in
                    self?.save(score: score)
                }
            }
        }
    }
}
