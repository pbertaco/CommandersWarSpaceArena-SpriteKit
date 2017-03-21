//
//  Metrics.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

#if os(iOS)
    import GameAnalytics
#endif

import SpriteKit
import GameKit

class Metrics {
    
    static func openTheGame() {
        guard Metrics.canSendEvents else { return }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.timeZone = NSTimeZone.local
        let hour = formatter.string(from: date)
        
        GameAnalytics.addDesignEvent(withEventId: "OpenTheGameAtHour:\(Metrics.userName()):\(hour)")
    }
    
    static func win() {
        if Metrics.canSendEvents {
            let playerData = MemoryCard.sharedInstance.playerData!
            let botLevel = playerData.botLevel
            GameAnalytics.addDesignEvent(withEventId: "BattleWin:\(Metrics.userName()):\(botLevel)")
        }
    }
    
    static func lose() {
        if Metrics.canSendEvents {
            let playerData = MemoryCard.sharedInstance.playerData!
            let botLevel = playerData.botLevel
            GameAnalytics.addDesignEvent(withEventId: "BattleLose:\(Metrics.userName()):\(botLevel)")
        }
    }
    
    static func userName() -> String {
        return GKLocalPlayer.localPlayer().alias ?? "Unknown"
    }
    
    static let canSendEvents: Bool = {
        
        if let alias = GKLocalPlayer.localPlayer().alias {
            if ["PabloHenri91"].contains(alias) {
                return false
            }
        }
        
        #if DEBUG || !os(iOS)
            return false
        #else
            return true
        #endif
    }()
}

#if os(OSX)
    class GameAnalytics {
        open class func addDesignEvent(withEventId eventId: String!) {
            print(eventId)
        }
    }
#endif
