//
//  BGMPlayer.swift
//  EggieRun
//
//  Created by CNA_Bld on 4/14/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import AVFoundation

class BGMPlayer {
    static let singleton = BGMPlayer()
    
    enum Status {
        case Menu, Game, Dex
    }
    
    private static let MUSIC_FILES: [Status: String] = [.Menu: "road-runner", .Game: "yadon-12", .Dex: "yadon-11"]
    private static let VOLUME: Float = 1.0
    private static let FADE_OUT_TIME: Float = 0.5
    private static let FADE_OUT_STEPS: Float = 10
    
    private static let FADE_OUT_TIME_PER_STEP = FADE_OUT_TIME / FADE_OUT_STEPS
    private static let FADE_OUT_VOLUME_PER_STEP = VOLUME / FADE_OUT_STEPS
    
    private var player: AVAudioPlayer?
    
    var muted: Bool = false {
        didSet {
            if muted {
                player?.volume = 0
            } else {
                player?.volume = BGMPlayer.VOLUME
            }
        }
    }
    
    private func fadeOut(callback: () -> Void) {
        if player?.volume > BGMPlayer.FADE_OUT_VOLUME_PER_STEP {
            player?.volume -= BGMPlayer.FADE_OUT_VOLUME_PER_STEP
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(BGMPlayer.FADE_OUT_TIME_PER_STEP * Float(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.fadeOut(callback)
            }
        } else {
            player?.stop()
            callback()
        }
    }
    
    func moveToStatus(status: Status?) {
        fadeOut({
            if status != nil {
                let url = NSBundle.mainBundle().URLForResource(BGMPlayer.MUSIC_FILES[status!], withExtension: "mp3")
                do {
                    self.player = try AVAudioPlayer(contentsOfURL: url!)
                    self.player?.numberOfLoops = -1
                    if self.muted {
                        self.player?.volume = 0
                    } else {
                        self.player?.volume = BGMPlayer.VOLUME
                    }
                    self.player?.prepareToPlay()
                    self.player?.play()
                } catch {
//                    print("BGMPlayer Failed on " + url.debugDescription)
                }
            }
        })
    }
}
