//
//  Music.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 3/7/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import AVFoundation

class Music {
    
    enum musicType {
        case noMusic
        case menu
        case battle
    }
    
    struct fileName {
        static var menu = [
            "klamm_cracks.m4a"
        ]
        static var battle = [
            "klamm_airborne.m4a",
            "klamm_atmosphere.m4a",
            "klamm_battleship.m4a",
            "klamm_destroyer.m4a",
            "klamm_ice-and-fire.m4a",
            "klamm_infinity.m4a",
            "klamm_prisma.m4a",
            "klamm_vortex.m4a",
            "Scorpion.m4a"
        ]
    }
    
    static var sharedInstance = Music()
    
    private var audioPlayer: AVAudioPlayer?
    private var musicName = ""
    private var musicType: musicType = .noMusic
    
    func playMusic(withType musicType: musicType) {
        guard self.musicType != musicType else { return }
        self.musicType = musicType
        
        switch musicType {
        case .noMusic:
            return
        case .menu:
            self.playMusic(withName: fileName.menu[Int.random(fileName.menu.count)])
            break
        case .battle:
            self.playMusic(withName: fileName.battle[Int.random(fileName.battle.count)])
            break
        }
    }
    
    func playMusic(withName name: String) {
        guard self.musicName != name else { return }
        self.musicName = name
        
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
            #if DEBUG
                fatalError()
            #else
                return
            #endif
        }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.numberOfLoops = -1
            self.audioPlayer = audioPlayer
            self.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func play() {
        if MemoryCard.sharedInstance.playerData.music {
            if let audioPlayer = self.audioPlayer {
                audioPlayer.play()
            }
        } else {
            self.pause()
        }
    }
    
    func pause() {
        self.audioPlayer?.pause()
    }
    
    func stop() {
        self.audioPlayer?.volume = 0
        self.audioPlayer?.stop()
    }
}
