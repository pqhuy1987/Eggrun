//
//  BGMPlayer.swift
//  EggieRun
//
//  Created by CNA_Bld on 4/14/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import AVFoundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class BGMPlayer {
    static let singleton = BGMPlayer()
    
    enum Status {
        case menu, game, dex
    }
    
    fileprivate static let MUSIC_FILES: [Status: String] = [.menu: "road-runner", .game: "yadon-12", .dex: "yadon-11"]
    fileprivate static let VOLUME: Float = 1.0
    fileprivate static let FADE_OUT_TIME: Float = 0.5
    fileprivate static let FADE_OUT_STEPS: Float = 10
    
    fileprivate static let FADE_OUT_TIME_PER_STEP = FADE_OUT_TIME / FADE_OUT_STEPS
    fileprivate static let FADE_OUT_VOLUME_PER_STEP = VOLUME / FADE_OUT_STEPS
    
    fileprivate var player: AVAudioPlayer?
    
    var muted: Bool = false {
        didSet {
            if muted {
                player?.volume = 0
            } else {
                player?.volume = BGMPlayer.VOLUME
            }
        }
    }
    
    fileprivate func fadeOut(_ callback: @escaping () -> Void) {
        if player?.volume > BGMPlayer.FADE_OUT_VOLUME_PER_STEP {
            player?.volume -= BGMPlayer.FADE_OUT_VOLUME_PER_STEP
            let delayTime = DispatchTime.now() + Double(Int64(BGMPlayer.FADE_OUT_TIME_PER_STEP * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.fadeOut(callback)
            }
        } else {
            player?.stop()
            callback()
        }
    }
    
    func moveToStatus(_ status: Status?) {
        fadeOut({
            if status != nil {
                let url = Bundle.main.url(forResource: BGMPlayer.MUSIC_FILES[status!], withExtension: "mp3")
                do {
                    self.player = try AVAudioPlayer(contentsOf: url!)
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
