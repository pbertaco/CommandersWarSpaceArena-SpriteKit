//
//  GameAdManager.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 3/16/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import UIKit

class GameAdManager: UIResponder, VungleSDKDelegate {

    static let sharedInstance = GameAdManager()
    
    var needToConfigure = false
    var isReady = false
    
    var adColonyIsReady = false
    let adColonyAppID = "app9a8ee6119cbb4c00b1"
    let adColonyZoneID = "vz501fa0886cf14819a2"
    var adColonyInterstitial: AdColonyInterstitial?
    
    let vungleAppID = "58cb4135527e35d5080003e9"
    var vungleIsReady = false
    
    private var reachability: Reachability?
    
    var eventHandlers = [() -> ()]()
    
    override init() {
        self.reachability = Reachability()
        super.init()
        
        guard let reachability = self.reachability else { return }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: nil)
        
        do {
            try reachability.startNotifier()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc private  func reachabilityChanged(_ notification: Notification) {
        if let reachability = notification.object as? Reachability {
            if reachability.isReachable && self.needToConfigure {
                self.needToConfigure = false
                self.configure()
            }
        }
    }
    
    private func configure() {
        self.configureAdColony()
        self.configureVungle()
    }
    
    private func checkAdAvailability() {
        let isReady = self.adColonyIsReady || self.vungleIsReady
        if self.isReady != isReady {
            self.isReady = isReady
            self.onAdAvailabilityChange()
        }
    }
    
    private func onAdAvailabilityChange() {
        
        if self.isReady {
            print("ready")
        } else {
            print("loading")
        }
    }
    
    func play() {
        if self.eventHandlers.count > 0 {
            let eventHandler = self.eventHandlers.removeFirst()
            Music.sharedInstance.pause()
            eventHandler()
        }
    }
    
    func videoAdAttemptFinished(shown: Bool) {
        
    }
    
    //MARK: Vungle
    
    private func configureVungle() {
        if let vungleSDK = VungleSDK.shared() {
            vungleSDK.delegate = self
            vungleSDK.start(withAppId: self.vungleAppID)
        }
    }
    
    private func playVungle() {
        do {
            try VungleSDK.shared().playAd((UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func vungleSDKAdPlayableChanged(_ isAdPlayable: Bool) {
        self.vungleIsReady = isAdPlayable
        if isAdPlayable {
            self.eventHandlers.append(self.playVungle)
        }
        self.checkAdAvailability()
    }
    
    func vungleSDKwillCloseAd(withViewInfo viewInfo: [AnyHashable : Any]!, willPresentProductSheet: Bool) {
        Music.sharedInstance.play()
    }
    
    
    //MARK: AdColony
    
    private func configureAdColony() {
        let appOptions = AdColonyAppOptions()
        appOptions.disableLogging = false
        appOptions.adOrientation = .portrait
        
        AdColony.configure(withAppID: self.adColonyAppID, zoneIDs: [self.adColonyZoneID], options: appOptions) { (adColonyZones: [AdColonyZone]) in
            self.loadVideoAdColony()
        }
    }
    
    private func loadVideoAdColony() {
        
        AdColony.requestInterstitial(inZone: self.adColonyZoneID, options: nil, success: { [weak self] (adColonyInterstitial: AdColonyInterstitial) in
            
            guard let this = self else { return }
            
            adColonyInterstitial.setClose({ [weak this] in
                this?.adColonyInterstitial = nil
                
                this?.adColonyIsReady = false
                this?.checkAdAvailability()
                this?.loadVideoAdColony()
                Music.sharedInstance.play()
            })
            
            adColonyInterstitial.setExpire({ [weak this] in
                this?.adColonyInterstitial = nil
                
                this?.adColonyIsReady = false
                this?.checkAdAvailability()
                this?.loadVideoAdColony()
            })
            
            this.adColonyInterstitial = adColonyInterstitial
            this.adColonyIsReady = true
            this.eventHandlers.append(this.playVideoAdColony)
            this.checkAdAvailability()
            
        }) { (adColonyAdRequestError: AdColonyAdRequestError) in
            print(adColonyAdRequestError.localizedDescription)
        }
    }
    
    private func playVideoAdColony() {
        if let adColonyInterstitial = self.adColonyInterstitial {
            if !adColonyInterstitial.expired {
                adColonyInterstitial.show(withPresenting: ((UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController)!)
            }
        }
    }
    
}
