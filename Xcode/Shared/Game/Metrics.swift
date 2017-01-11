//
//  Metrics.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import GameAnalytics

class Metrics {
    
    static func openTheGame() {
        guard Metrics.canSendEvents() else { return }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.timeZone = NSTimeZone.local
        let hour = formatter.string(from: date)
        
        GameAnalytics.addDesignEvent(withEventId: "OpenTheGameAtHour:\(hour)")
    }
    
    static func win() {
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEvent(withEventId: "BattleWin")
        }
    }
    
    static func loose() {
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEvent(withEventId: "BattleLoose")
        }
    }
    
    static func canSendEvents() -> Bool {
        #if DEBUG || !os(iOS)
            return false
        #else
            return true
        #endif
    }
}
