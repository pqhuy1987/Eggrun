//
//  IngredientBar.swift
//  EggieRun
//
//  Created by  light on 2016/03/31.
//  Copyright © 2016年 Eggieee. All rights reserved.
//

// Class: IngredientBar
// Description: a bar of grids showing the current ingredients
// collected with a maximum size of 5. Once exceeds, the first
// grid will be removed and all the other grids will move forward
// in order to add in the new grid at the last of the bar.
// Repeating ingredients will be move to the last.

import SpriteKit

class IngredientBar: SKSpriteNode {
    fileprivate static let X_DISTANCE = CGFloat(100)
    fileprivate static let X_OFFSET = CGFloat(45)
    fileprivate static let MAX_GRID_NUMBER = 5
    fileprivate static let IS_NOT_CONTAINED_INDEX = -1
    
    var ingredients = [Ingredient]()
    fileprivate var ingredientGrids = [IngredientGrid]()
    fileprivate var emptyGrids = [IngredientGrid]()
    fileprivate var firstEmptyIndex: Int {
        get {
            return ingredients.count
        }
    }
    fileprivate var isFull: Bool {
        get {
            return (ingredients.count >= IngredientBar.MAX_GRID_NUMBER)
        }
    }
    
    init() {
        let barSize = CGSize(width: 500, height: 90)
        super.init(texture: nil, color: UIColor.clear, size: barSize)
        initializeEmptyGrids()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addIngredient(_ newIngredient: Ingredient) {
        let newGrid = IngredientGrid(ingredientType: newIngredient)
        var index = IngredientBar.IS_NOT_CONTAINED_INDEX
        let isDuplicate = ingredients.contains(newIngredient)
        
        if (isDuplicate) {
            index = ingredients.index(of: newIngredient)!
        } else if (!isFull) {
            updateEmptyGrids()
        }
        
        updateBarLayout(newGrid, index: index)
        updateArray(newIngredient, newGrid: newGrid, index: index)
    }
    
    func getNextGridX(_ newIngredient: Ingredient) -> CGFloat {
        return CGFloat(min(firstEmptyIndex - (ingredients.contains(newIngredient) ? 1 : 0), 4)) * IngredientBar.X_DISTANCE + IngredientBar.X_OFFSET
    }
    
    fileprivate func initializeEmptyGrids() {
        for i in 0..<IngredientBar.MAX_GRID_NUMBER {
            let newEmptyGrid = IngredientGrid(ingredientType: nil)
            let position = CGPoint(x: CGFloat(i) * IngredientBar.X_DISTANCE + IngredientBar.X_OFFSET, y: 0)
            newEmptyGrid.position = position
            addChild(newEmptyGrid)
            emptyGrids.append(newEmptyGrid)
        }
    }
    
    fileprivate func updateEmptyGrids() {
        emptyGrids[0].removeFromParent()
        emptyGrids.removeFirst()
    }
    
    fileprivate func updateBarLayout(_ newGrid: IngredientGrid, index: Int) {
        let isDuplicate = (index != IngredientBar.IS_NOT_CONTAINED_INDEX)
        if (isDuplicate) {
            animateMovingGridByOne(index)
        } else if (isFull) {
            animateMovingGridByOne(0)
        }
        animateAddingNewGrid(newGrid, isDuplicate: isDuplicate)
    }
    
    fileprivate func animateMovingGridByOne(_ startIndex: Int) {
        for i in startIndex..<ingredients.count {
            let grid = ingredientGrids[i]
            // moving animation
            if (i==startIndex) {
                let fadingOut = SKAction.fadeOut(withDuration: 0.5)
                grid.run(fadingOut, completion: { () -> Void in
                    grid.removeFromParent()
                })
            } else {
                let movingAction = SKAction.moveBy(x: -IngredientBar.X_DISTANCE, y: 0, duration: 0.5)
                grid.run(movingAction)
            }
        }
    }
    
    fileprivate func animateAddingNewGrid(_ newGrid: IngredientGrid, isDuplicate: Bool) {
        let nextIndex = (isFull || isDuplicate) ? firstEmptyIndex-1 : firstEmptyIndex
        let position = CGPoint(x: CGFloat(nextIndex) * IngredientBar.X_DISTANCE + IngredientBar.X_OFFSET, y: 0)
        newGrid.position = position
        addChild(newGrid)
    }
    
    fileprivate func updateArray(_ newIngredient: Ingredient, newGrid: IngredientGrid, index: Int) {
        if (index != IngredientBar.IS_NOT_CONTAINED_INDEX) {
            moveGridByOne(index)
        } else if (isFull) {
            moveGridByOne(0)
        }
        ingredients.append(newIngredient)
        ingredientGrids.append(newGrid)
    }
    
    fileprivate func moveGridByOne(_ startIndex: Int) {
        ingredients.remove(at: startIndex)
        ingredientGrids.remove(at: startIndex)
    }
}
