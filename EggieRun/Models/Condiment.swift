//
//  Condiment.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/22/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

enum Condiment: Int {
    case salt = 10, sugar = 11, chili = 12
    
    static let ALL_VALUES: [Condiment] = [.salt, .sugar, .chili]
    
    static fileprivate let TEXTURES: [Condiment: SKTexture] = Dictionary(ALL_VALUES.map({ ($0, SKTexture(imageNamed: $0.imageNamed)) }))
    
    static fileprivate let randomPool = RandomPool<Condiment>(objects: [.salt, .sugar, .chili], weightages: [5, 4, 1])
    
    static func next() -> Condiment {
        return randomPool.draw()
    }
    
    fileprivate var imageNamed: String {
        switch self {
        case .salt:
            return "salt"
        case .sugar:
            return "sugar"
        case .chili:
            return "chili"
        }
    }
    
    var texture: SKTexture {
        return Condiment.TEXTURES[self]!
    }
    
    var zeroIndex: Int {
        return self.rawValue - 10
    }
}
