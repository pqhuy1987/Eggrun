//
//  ShelfFactory.swift
//  EggieRun
//
//  Created by Liu Yang on 17/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

// Class: ShelfFactory
// Description: a class computing the next shelf’s position and length based
// on certain formula.

import SpriteKit

class ShelfFactory {
    private static let MAX_NUM_OF_MID_PIECE: UInt32 = 10
    private static let MAX_NUM_OF_GAP: UInt32 = 20
    private static let UNIT_GAP_SIZE: CGFloat = 300
    
    func next() -> Platform {
        let numOfMid = Int(arc4random_uniform(ShelfFactory.MAX_NUM_OF_MID_PIECE + 1))
        let numOfGap = CGFloat(arc4random_uniform(ShelfFactory.MAX_NUM_OF_GAP + 1))

        return Platform.makeShelf(numOfMid, gapSize: numOfGap * ShelfFactory.UNIT_GAP_SIZE)
    }
}