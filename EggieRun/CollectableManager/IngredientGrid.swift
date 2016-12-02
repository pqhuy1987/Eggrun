//
//  IngredientGrid.swift
//  EggieRun
//
//  Created by  light on 2016/03/31.
//  Copyright © 2016年 Eggieee. All rights reserved.
//

// Class: IngredientGrid
// Description: a grid in the ingredient bar consisting
// of a grid background and an ingredient node

import SpriteKit

class IngredientGrid: SKSpriteNode {
    fileprivate static let GRIDSIZE = CGSize(width: 90, height: 90)
    fileprivate static let IMGSIZE = CGSize(width: 75, height: 75)
    fileprivate static let GRID_IMG_NAME = "ingredient-grid"
    
    fileprivate let ingredient: Ingredient?
    fileprivate var ingredientNode: SKSpriteNode? = nil
    
    init(ingredientType: Ingredient?) {
        ingredient = ingredientType
        let texture = SKTexture(imageNamed: IngredientGrid.GRID_IMG_NAME)
        super.init(texture: texture, color: UIColor.clear, size: IngredientGrid.GRIDSIZE)
        initializeIngredientNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initializeIngredientNode() {
        ingredientNode = SKSpriteNode(texture: ingredient?.flatTexture, color: UIColor.clear, size: IngredientGrid.IMGSIZE)
        ingredientNode!.position = CGPoint(x: 0, y: 0)
        ingredientNode!.zPosition = zPosition + 1
        addChild(ingredientNode!)
    }
}
