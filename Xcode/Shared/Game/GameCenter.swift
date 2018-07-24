//
//  GameCenter.swift
//  CommandersWar
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
        #if !DEBUG
        guard GKLocalPlayer.localPlayer().isAuthenticated else { return }
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        self.present(gameCenterViewController, animated: true)
        #endif
    }

    func authenticateLocalPlayer(completion block: @escaping () -> Void = {}) {
        #if !DEBUG
        let localPlayer = GKLocalPlayer.localPlayer()
        
        if localPlayer.isAuthenticated {
            block()
        } else {
            localPlayer.authenticateHandler = { [weak self] (viewController: UIViewController?, error: Error?) -> Void in
                guard let `self` = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                }
                if let viewController = viewController {
                    self.present(viewController, animated: true, completion: nil)
                }
                if localPlayer.isAuthenticated {
                    block()
                }
            }
        }
        #endif
    }
    
    func save(scoreValue: Int) {
        #if !DEBUG
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let score = GKScore(leaderboardIdentifier: "\(Bundle.main.bundleIdentifier!).score")
            score.value = Int64(scoreValue)
            GKScore.report([score], withCompletionHandler: { (error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        } else {
            self.authenticateLocalPlayer { [weak self] in
                guard let `self` = self else { return }
                self.save(scoreValue: scoreValue)
            }
        }
        #endif
    }
    
    
    func save(achievementIdentifier: String) {
        #if !DEBUG
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let achievement = GKAchievement(identifier: "com.PabloHenri91.GameVI.\(achievementIdentifier)")
            achievement.showsCompletionBanner = true
            achievement.percentComplete = 100
            GKAchievement.report([achievement], withCompletionHandler: { (error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print(achievementIdentifier)
                }
            })
        } else {
            self.authenticateLocalPlayer { [weak self] in
                guard let `self` = self else { return }
                self.save(achievementIdentifier: achievementIdentifier)
            }
        }
        #endif
    }
}
