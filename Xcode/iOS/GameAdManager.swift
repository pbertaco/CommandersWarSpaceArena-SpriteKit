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
    
    var needToConfigure = true
    var isReady = false
    
    var adColonyIsReady = false
    let adColonyAppID = "app9a8ee6119cbb4c00b1"
    let adColonyZoneID = "vz501fa0886cf14819a2"
    var adColonyInterstitial: AdColonyInterstitial?
    
    let vungleAppID = "58cb4135527e35d5080003e9"
    var vungleIsReady = false
    
    private var reachability: Reachability?
    
    var eventHandlers = [() -> ()]()
    
    var onAdAvailabilityChange: ((_ isReady: Bool) -> Void)?
    var onVideoAdAttemptFinished: ((_ shown: Bool) -> Void)?
    
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
            if reachability.isReachableViaWiFi {
                if self.needToConfigure {
                    self.needToConfigure = false
                    self.configure()
                }
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
            self.onAdAvailabilityChange?(self.isReady)
        }
    }
    
    func play() {
        if self.eventHandlers.count > 0 {
            let eventHandler = self.eventHandlers.removeFirst()
            Music.sharedInstance.pause()
            eventHandler()
        }
    }
    
    //MARK: Vungle
    
    private func configureVungle() {
        if let vungleSDK = VungleSDK.shared() {
            vungleSDK.delegate = self
            vungleSDK.start(withAppId: self.vungleAppID)
        }
    }
    
    private func playVideoVungle() {
        do {
            try VungleSDK.shared().playAd((UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func vungleSDKAdPlayableChanged(_ isAdPlayable: Bool) {
        
        self.vungleIsReady = isAdPlayable
        if isAdPlayable {
            self.eventHandlers.append(self.playVideoVungle)
        }
        self.checkAdAvailability()
    }
    
    func vungleSDKwillCloseAd(withViewInfo viewInfo: [AnyHashable : Any]!, willPresentProductSheet: Bool) {
        Music.sharedInstance.play()
        self.onVideoAdAttemptFinished?(true)
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
        
        if self.reachability?.isReachableViaWiFi != true {
            return
        }
        
        AdColony.requestInterstitial(inZone: self.adColonyZoneID, options: nil, success: { [weak self] (adColonyInterstitial: AdColonyInterstitial) in
            guard let `self` = self else { return }
            
            adColonyInterstitial.setClose({ [weak self] in
                guard let `self` = self else { return }
                
                self.adColonyInterstitial = nil
                
                self.adColonyIsReady = false
                self.checkAdAvailability()
                self.loadVideoAdColony()
                Music.sharedInstance.play()
                self.onVideoAdAttemptFinished?(true)
            })
            
            adColonyInterstitial.setExpire({
                self.adColonyInterstitial = nil
                
                self.adColonyIsReady = false
                self.checkAdAvailability()
                self.loadVideoAdColony()
            })
            
            self.adColonyInterstitial = adColonyInterstitial
            self.adColonyIsReady = true
            self.eventHandlers.append(self.playVideoAdColony)
            self.checkAdAvailability()
            
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
