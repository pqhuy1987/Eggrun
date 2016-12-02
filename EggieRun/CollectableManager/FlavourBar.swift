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
    private static let BLUE_COLOUR = UIColor(red: 128.0/255, green: 227.0/255, blue: 250.0/255, alpha: 1)
    private static let YELLOW_COLOUR = UIColor(red: 255.0/255, green: 235.0/255, blue: 153.0/255, alpha: 1)
    private static let RED_COLOUR = UIColor(red: 254.0/255, green: 89.0/255, blue: 77.0/255, alpha: 1)
    
    private static let BAR_LENGTH = CGFloat(100)
    private static let BAR_HEIGHT = CGFloat(15)
    
    private var sugarBar: SKSpriteNode!
    private var saltBar: SKSpriteNode!
    private var chiliBar: SKSpriteNode!
    
    private var sugar: Float = 0
    private var salt: Float = 0
    private var chili: Float = 0
    
    private var condimentCount: Float {
        get {
            return sugar + salt + chili
        }
    }
    
    var condimentDictionary: [Condiment: Int] {
        get {
            var dictionary = [Condiment: Int]()
            dictionary[Condiment.Salt] = Int(salt)
            dictionary[Condiment.Sugar] = Int(sugar)
            dictionary[Condiment.Chili] = Int(chili)
            return dictionary
        }
    }
    
    init() {
        super.init(texture: nil, color: UIColor.grayColor(), size: CGSizeMake(FlavourBar.BAR_LENGTH, FlavourBar.BAR_HEIGHT))
        initializeBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCondiment(newCondiment: Condiment) {
        switch newCondiment {
        case .Salt:
            salt += 1
        case .Sugar:
            sugar += 1
        case .Chili:
            chili += 1
        }
        updateBar()
    }
    
    private func getSingleFlavourPercentage(condiment: Condiment) -> Float {
        switch condiment {
        case .Salt:
            return salt/condimentCount
        case .Sugar:
            return sugar/condimentCount
        case .Chili:
            return chili/condimentCount
        }
    }
    
    private func getSingleFlavourLength(condiment: Condiment) -> CGFloat {
        switch condiment {
        case .Salt:
            return CGFloat(getSingleFlavourPercentage(Condiment.Salt)) * FlavourBar.BAR_LENGTH
        case .Sugar:
            return CGFloat(getSingleFlavourPercentage(Condiment.Sugar)) * FlavourBar.BAR_LENGTH
        case .Chili:
            return CGFloat(getSingleFlavourPercentage(Condiment.Chili)) * FlavourBar.BAR_LENGTH
        }
    }
    
    private func getSingleBarX(condiment: Condiment) -> CGFloat {
        switch condiment {
        case .Salt:
            return getSingleFlavourLength(Condiment.Salt)/2 - FlavourBar.BAR_LENGTH/2
        case .Sugar:
            return getSingleFlavourLength(Condiment.Salt) + getSingleFlavourLength(Condiment.Sugar)/2 - FlavourBar.BAR_LENGTH/2
        case .Chili:
            return getSingleFlavourLength(Condiment.Salt) + getSingleFlavourLength(Condiment.Sugar) + getSingleFlavourLength(Condiment.Chili)/2 - FlavourBar.BAR_LENGTH/2
        }
    }
    
    private func initializeBar() {
        saltBar = SKSpriteNode(color: FlavourBar.BLUE_COLOUR, size: CGSizeMake(getSingleFlavourLength(Condiment.Salt), FlavourBar.BAR_HEIGHT))
        sugarBar = SKSpriteNode(color: FlavourBar.YELLOW_COLOUR, size: CGSizeMake(getSingleFlavourLength(Condiment.Sugar), FlavourBar.BAR_HEIGHT))
        chiliBar = SKSpriteNode(color: FlavourBar.RED_COLOUR, size: CGSizeMake(getSingleFlavourLength(Condiment.Chili), FlavourBar.BAR_HEIGHT))
        addChild(saltBar)
        addChild(sugarBar)
        addChild(chiliBar)
    }
    
    private func updateBar() {
        saltBar.position.x = getSingleBarX(Condiment.Salt)
        saltBar.size.width = getSingleFlavourLength(Condiment.Salt)
        sugarBar.position.x = getSingleBarX(Condiment.Sugar)
        sugarBar.size.width = getSingleFlavourLength(Condiment.Sugar)
        chiliBar.position.x = getSingleBarX(Condiment.Chili)
        chiliBar.size.width = getSingleFlavourLength(Condiment.Chili)
    }

}