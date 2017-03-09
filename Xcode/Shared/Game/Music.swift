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
            "klamm_cracks.m4a"]
        static var battle = [
            "klamm_infinity.m4a",
            "klamm_moonset.m4a",
            "klamm_prisma.m4a"]
    }
    
    static let sharedInstance = Music()
    
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
            audioPlayer.volume = 1.0
            audioPlayer.numberOfLoops = -1
            self.audioPlayer = audioPlayer
            self.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func play() {
        self.audioPlayer?.play()
    }
    
    func pause() {
        self.audioPlayer?.pause()
    }
    
    func stop() {
        self.audioPlayer?.stop()
    }
}
