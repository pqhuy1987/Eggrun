//
//  Ingredient.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/22/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

enum Ingredient: Int {
    fileprivate static let DISTANCES_TURNING_POINT = [Milestone.presentShelf, Milestone.challengeDarkness].map({ $0.requiredDistance })
    
    case greenOnion = 100, tomato = 101, cream = 102, milk = 103, rice = 104, bread = 105, bacon = 106, strawberry = 107, chocolate = 108, surstromming = 109
    
    static let ALL_VALUES: [Ingredient] = [.greenOnion, .tomato, .cream, .milk, .rice, .bread, .bacon, .strawberry, .chocolate, .surstromming]
    
    static fileprivate let FLAT_TEXTURES: [Ingredient: SKTexture] = Dictionary(ALL_VALUES.map({ ($0, SKTexture(imageNamed: $0.flatImageNamed)) }))
    static fileprivate let FINE_TEXTURES: [Ingredient: SKTexture] = Dictionary(ALL_VALUES.map({ ($0, SKTexture(imageNamed: $0.fineImageNamed)) }))
    
    static fileprivate let rarityTable: [[Ingredient]] = [[.milk], [.greenOnion, .tomato, .cream, .rice, .bacon, .strawberry], [.bread, .chocolate], [.surstromming]]
    
    static fileprivate let rarityPools = rarityTable.map({ RandomPool(objects: $0) })
    
    static func next(_ distance: Int) -> Ingredient {
        let randomPool: RandomPool<RandomPool<Ingredient>>!
        if distance < Ingredient.DISTANCES_TURNING_POINT[0] {
            randomPool = RandomPool(objects: [rarityPools[0], rarityPools[1]], weightages: [3, 10])
        } else if distance < Ingredient.DISTANCES_TURNING_POINT[1] {
            randomPool = RandomPool(objects: [rarityPools[0], rarityPools[1], rarityPools[2]], weightages: [3, 10, 2])
        } else {
            randomPool = RandomPool(objects: rarityPools, weightages: [60, 200, 40, 1])
        }
        return randomPool.draw().draw()
    }
    
    fileprivate var imageNamed: String {
        switch self {
        case .greenOnion:
            return "green-onion"
        case .tomato:
            return "tomato"
        case .cream:
            return "cream"
        case .milk:
            return "milk"
        case .rice:
            return "rice"
        case .bread:
            return "bread"
        case .bacon:
            return "bacon"
        case .strawberry:
            return "strawberry"
        case .chocolate:
            return "chocolate"
        case .surstromming:
            return "surstromming"
        }
    }
    
    fileprivate var flatImageNamed: String {
        return "flat-" + imageNamed
    }
    
    fileprivate var fineImageNamed: String {
        return "fine-" + imageNamed
    }
    
    var flatTexture: SKTexture {
        return Ingredient.FLAT_TEXTURES[self]!
    }
    
    var fineTexture: SKTexture {
        return Ingredient.FINE_TEXTURES[self]!
    }
}
