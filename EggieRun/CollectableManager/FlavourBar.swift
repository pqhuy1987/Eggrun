//
//  FlavourBar.swift
//  EggieRun
//
//  Created by  light on 2016/03/31.
//  Copyright © 2016年 Eggieee. All rights reserved.
//

// Class: FlavourBar
// Description: a bar with colours blue, yellow and red
// representing the current state of condiments collected
// where blue stands for salt, yellow stands for sugar
// and red stands for chili

import SpriteKit

class FlavourBar: SKSpriteNode {
    fileprivate static let BLUE_COLOUR = UIColor(red: 128.0/255, green: 227.0/255, blue: 250.0/255, alpha: 1)
    fileprivate static let YELLOW_COLOUR = UIColor(red: 255.0/255, green: 235.0/255, blue: 153.0/255, alpha: 1)
    fileprivate static let RED_COLOUR = UIColor(red: 254.0/255, green: 89.0/255, blue: 77.0/255, alpha: 1)
    
    fileprivate static let BAR_LENGTH = CGFloat(100)
    fileprivate static let BAR_HEIGHT = CGFloat(15)
    
    fileprivate var sugarBar: SKSpriteNode!
    fileprivate var saltBar: SKSpriteNode!
    fileprivate var chiliBar: SKSpriteNode!
    
    fileprivate var sugar: Float = 0
    fileprivate var salt: Float = 0
    fileprivate var chili: Float = 0
    
    fileprivate var condimentCount: Float {
        get {
            return sugar + salt + chili
        }
    }
    
    var condimentDictionary: [Condiment: Int] {
        get {
            var dictionary = [Condiment: Int]()
            dictionary[Condiment.salt] = Int(salt)
            dictionary[Condiment.sugar] = Int(sugar)
            dictionary[Condiment.chili] = Int(chili)
            return dictionary
        }
    }
    
    init() {
        super.init(texture: nil, color: UIColor.gray, size: CGSize(width: FlavourBar.BAR_LENGTH, height: FlavourBar.BAR_HEIGHT))
        initializeBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCondiment(_ newCondiment: Condiment) {
        switch newCondiment {
        case .salt:
            salt += 1
        case .sugar:
            sugar += 1
        case .chili:
            chili += 1
        }
        updateBar()
    }
    
    fileprivate func getSingleFlavourPercentage(_ condiment: Condiment) -> Float {
        switch condiment {
        case .salt:
            return salt/condimentCount
        case .sugar:
            return sugar/condimentCount
        case .chili:
            return chili/condimentCount
        }
    }
    
    fileprivate func getSingleFlavourLength(_ condiment: Condiment) -> CGFloat {
        switch condiment {
        case .salt:
            return CGFloat(getSingleFlavourPercentage(Condiment.salt)) * FlavourBar.BAR_LENGTH
        case .sugar:
            return CGFloat(getSingleFlavourPercentage(Condiment.sugar)) * FlavourBar.BAR_LENGTH
        case .chili:
            return CGFloat(getSingleFlavourPercentage(Condiment.chili)) * FlavourBar.BAR_LENGTH
        }
    }
    
    fileprivate func getSingleBarX(_ condiment: Condiment) -> CGFloat {
        switch condiment {
        case .salt:
            return getSingleFlavourLength(Condiment.salt)/2 - FlavourBar.BAR_LENGTH/2
        case .sugar:
            return getSingleFlavourLength(Condiment.salt) + getSingleFlavourLength(Condiment.sugar)/2 - FlavourBar.BAR_LENGTH/2
        case .chili:
            return getSingleFlavourLength(Condiment.salt) + getSingleFlavourLength(Condiment.sugar) + getSingleFlavourLength(Condiment.chili)/2 - FlavourBar.BAR_LENGTH/2
        }
    }
    
    fileprivate func initializeBar() {
        saltBar = SKSpriteNode(color: FlavourBar.BLUE_COLOUR, size: CGSize(width: getSingleFlavourLength(Condiment.salt), height: FlavourBar.BAR_HEIGHT))
        sugarBar = SKSpriteNode(color: FlavourBar.YELLOW_COLOUR, size: CGSize(width: getSingleFlavourLength(Condiment.sugar), height: FlavourBar.BAR_HEIGHT))
        chiliBar = SKSpriteNode(color: FlavourBar.RED_COLOUR, size: CGSize(width: getSingleFlavourLength(Condiment.chili), height: FlavourBar.BAR_HEIGHT))
        addChild(saltBar)
        addChild(sugarBar)
        addChild(chiliBar)
    }
    
    fileprivate func updateBar() {
        saltBar.position.x = getSingleBarX(Condiment.salt)
        saltBar.size.width = getSingleFlavourLength(Condiment.salt)
        sugarBar.position.x = getSingleBarX(Condiment.sugar)
        sugarBar.size.width = getSingleFlavourLength(Condiment.sugar)
        chiliBar.position.x = getSingleBarX(Condiment.chili)
        chiliBar.size.width = getSingleFlavourLength(Condiment.chili)
    }

}
