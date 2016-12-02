//
//  Milestone.swift
//  EggieRun
//
//  Created by  light on 4/18/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

enum Milestone: Int {
    case presentPot = 0, presentShelf = 1, presentOven = 2, challengeDarkness = 3, presentPan = 4, challengeQuake = 5, increasePot = 6, endOyakodon = 7
    
    static let ALL_VALUES: [Milestone] = [.presentPot, .presentShelf, .presentOven, .challengeDarkness, .presentPan, .challengeQuake, .increasePot, .endOyakodon]
    
    fileprivate static let DISTANCES = [10000, 20000, 30000, 40000, 50000, 65000, 85000, 100000]
    
    var requiredDistance: Int {
        return Milestone.DISTANCES[rawValue] / GlobalConstants.DEV_DISTANCE_DIVISOR
    }
    
    fileprivate var imageNamed: String {
        switch self {
        case .presentPot:
            return "present-pot-milestone"
        case .presentShelf:
            return "present-shelf-milestone"
        case .presentOven:
            return "present-oven-milestone"
        case .challengeDarkness:
            return "challenge-darkness-milestone"
        case .presentPan:
            return "present-pan-milestone"
        case .challengeQuake:
            return "challenge-quake-milestone"
        case .increasePot:
            return "increase-pot-milestone"
        case .endOyakodon:
            return "end-oyakodon-milestone"
        }
    }
    
    fileprivate var monochromeImageNamed: String {
        return "mono-" + imageNamed
    }
    
    fileprivate var colouredImageNamed: String {
        return "colo-" + imageNamed
    }
    
    var monochromeTexture: SKTexture {
        return SKTexture(imageNamed: self.monochromeImageNamed)
    }
    
    var colouredTexture: SKTexture {
        return SKTexture(imageNamed: self.colouredImageNamed)
    }
}
