//
//  DexGridNode.swift
//  EggieRun
//
//  Created by Tang Jiahui on 8/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

// Class: DexGridNode
// Description: A class on the left side of the Scene that displays all dishes. It manages all DexItemNode.

class DexGridNode: SKSpriteNode {
    static fileprivate let ITEMS_PER_ROW = 4
    static fileprivate let HORIZONTAL_PADDING = CGFloat(20)
    static fileprivate let VERTICAL_PADDING = CGFloat(60)
    static fileprivate let EMITTER_NODE_Z_POSITION = CGFloat(3)
    
    fileprivate var width: CGFloat
    fileprivate var height: CGFloat

    fileprivate(set) var dishNodes = [DexItemNode]()
    fileprivate var selectedEmitterNode: SKEmitterNode!
    
    
    init(sceneHeight: CGFloat, sceneWidth: CGFloat, dishList:[Dish]) {
        width = DexScene.GRID_WIDTH_RATIO * sceneWidth
        height = sceneHeight - DexScene.TOP_BAR_HEIGHT
        
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: width, height: height))
        self.position = CGPoint(x: 0, y: 0)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        let itemSize = (width - DexGridNode.HORIZONTAL_PADDING * CGFloat(DexGridNode.ITEMS_PER_ROW + 1)) / CGFloat(DexGridNode.ITEMS_PER_ROW)
        
        for i in 0 ..< dishList.count {
            let row = i / DexGridNode.ITEMS_PER_ROW
            let col = i % DexGridNode.ITEMS_PER_ROW
            
            let x = CGFloat(col + 1) * DexGridNode.HORIZONTAL_PADDING + (CGFloat(col) + 0.5) * itemSize
            let y = height - (CGFloat(row + 1) * DexGridNode.VERTICAL_PADDING + (CGFloat(row) + 0.5) * itemSize)
            
            let item = DexItemNode(dish: dishList[i], xPosition: x, yPosition: y, size: itemSize)
            
            addChild(item)
            dishNodes.append(item)
        }
        
        
        selectedEmitterNode = SKEmitterNode(fileNamed: "DexSelected.sks")
        selectedEmitterNode.particlePositionRange.dx = itemSize
        selectedEmitterNode.particlePosition.y = -itemSize / 2
        selectedEmitterNode.isHidden = true
        selectedEmitterNode.zPosition = DexGridNode.EMITTER_NODE_Z_POSITION
        addChild(selectedEmitterNode)
    }
    
    func moveEmitter(_ item: DexItemNode) {
        selectedEmitterNode.position = item.position
        selectedEmitterNode.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
