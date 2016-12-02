//
//  DexItemNode.swift
//  EggieRun
//
//  Created by Tang Jiahui on 8/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

// Class: DexItemNode
// Description: A class for individual dishes shown on the DexGridNode.

class DexItemNode: SKNode {
    static private let IMAGE_RATIO = CGFloat(1.5)
    static private let BACKGROUND_Z = CGFloat(1)
    static private let DISH_Z = CGFloat(2)
    static private let QMARK_Z = CGFloat(3)
    static private let QMARK_FONTSIZE = CGFloat(40)
    static private let NEW_LABEL_Z_POSITION = CGFloat(5)
    static private let NEW_LABEL_WIDTH = CGFloat(40)
    static private let NEW_LABEL_HEIGHT = CGFloat(17)
    
    let dish: Dish
    private(set) var activated = true
    
    private static func ITEM_BACKGROUND_IMAGENAMED(rarity: Int) -> String {
        return "item-background-" + String(rarity)
    }
    
    init(dish: Dish, xPosition: CGFloat, yPosition: CGFloat, size: CGFloat) {
        self.dish = dish
        super.init()
        self.position = CGPoint(x: xPosition, y: yPosition)
        
        // background node of dishes
        let backgroundNode = SKSpriteNode(imageNamed: DexItemNode.ITEM_BACKGROUND_IMAGENAMED(dish.rarity))
        backgroundNode.size = CGSize(width: size, height: size)
        backgroundNode.zPosition = DexItemNode.BACKGROUND_Z
        
        // initial effect before the dish is activated in game
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        effectNode.zPosition = DexItemNode.DISH_Z
        if !DishDataController.singleton.isDishActivated(dish) {
            effectNode.filter = DexScene.UNACTIVATED_FILTER
            let questionMarkNode = SKLabelNode(text: "?")
            questionMarkNode.color = UIColor.whiteColor()
            questionMarkNode.fontSize = DexItemNode.QMARK_FONTSIZE
            questionMarkNode.verticalAlignmentMode = .Center
            questionMarkNode.zPosition = DexItemNode.QMARK_Z
            addChild(questionMarkNode)
            activated = false
        }
        
        if DishDataController.singleton.isDishNew(dish) {
            let newNode = SKSpriteNode(imageNamed: "new-label")
            newNode.size = CGSize(width: DexItemNode.NEW_LABEL_WIDTH, height: DexItemNode.NEW_LABEL_HEIGHT)
            newNode.position = CGPoint(x: size/3, y: size/3)
            newNode.zPosition = DexItemNode.NEW_LABEL_Z_POSITION
            addChild(newNode)
        }
        
        // add dish image node
        let dishImageNode = SKSpriteNode(texture: dish.texture)
        dishImageNode.size = CGSize(width: size / DexItemNode.IMAGE_RATIO, height: size / DexItemNode.IMAGE_RATIO)
        effectNode.addChild(dishImageNode)
        
        addChild(backgroundNode)
        addChild(effectNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
