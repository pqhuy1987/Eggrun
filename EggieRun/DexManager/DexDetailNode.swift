//
//  DexDetailNode.swift
//  EggieRun
//
//  Created by Tang Jiahui on 8/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit
// Class: SKSpriteNode
// Description: A class that display the details of activated or unactivated dishes on the right half of the scene.

class DexDetailNode: SKSpriteNode {
    fileprivate static let QMARK_FONTSIZE = CGFloat(100)
    fileprivate static let WIDTH_RATIO = CGFloat(2/3.0)
    fileprivate static let HEIGHT_RATIO = CGFloat(7/12.0)
    fileprivate static let OVERLAY_Z_POSITION = CGFloat(1)
    fileprivate static let QUESTION_Z_POSITION = CGFloat(2)
    fileprivate static let MINOR_OFFSET = CGFloat(20)
    fileprivate static let DISH_NAME_FONTSIZE = CGFloat(25)
    fileprivate static let DISH_DESCRIPTION_FONTSIZE = CGFloat(20)
    fileprivate static let DISH_DESCRIPTION_LEADING = 20
    fileprivate static let NAME_FONT = "Chalkduster"
    
    fileprivate let WIDTH : CGFloat
    fileprivate let HEIGHT: CGFloat
    fileprivate var dishImageNode: SKSpriteNode
    fileprivate var effectNode: SKEffectNode
    fileprivate var dishNameNode: SKLabelNode
    fileprivate var dishDescriptionNode: MultilineLabelNode
    fileprivate var questionMarkNode: SKLabelNode
    
    func setDish(_ dish: Dish, activated: Bool) {
        dishImageNode.texture = dish.texture
        if activated {
            effectNode.filter = nil
            dishDescriptionNode.text = dish.description
            dishNameNode.text = dish.name
            questionMarkNode.isHidden = true
        } else {
            effectNode.filter = DexScene.UNACTIVATED_FILTER
            dishDescriptionNode.text = dish.hintDescription
            dishNameNode.text = "???"
            questionMarkNode.isHidden = false
        }
    }
    
    init(sceneHeight: CGFloat, sceneWidth: CGFloat) {
        WIDTH = sceneWidth * DexScene.DETAIL_WIDTH_RATIO
        HEIGHT = sceneHeight - DexScene.TOP_BAR_HEIGHT
        
        dishImageNode = SKSpriteNode(texture: nil)
        dishNameNode = SKLabelNode(text: "")
        dishDescriptionNode = MultilineLabelNode(text: "", labelWidth: Int(WIDTH * DexDetailNode.WIDTH_RATIO) , pos: CGPoint(x: WIDTH / 2 + DexDetailNode.MINOR_OFFSET, y: HEIGHT / 3 - DexDetailNode.MINOR_OFFSET), fontName: "BradleyHandITCTT-Bold",fontSize: DexDetailNode.DISH_DESCRIPTION_FONTSIZE,fontColor: UIColor.black,leading: DexDetailNode.DISH_DESCRIPTION_LEADING, alignment:.center)
        questionMarkNode = SKLabelNode(text: "?")
        
        effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        
        // background
        super.init(texture: SKTexture(imageNamed: "notebook"), color: UIColor.brown, size: CGSize(width: WIDTH, height: HEIGHT))
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.position = CGPoint(x: sceneWidth * (1 - DexScene.DETAIL_WIDTH_RATIO), y: 0)
        
        dishImageNode.position = CGPoint(x: WIDTH / 2, y: sceneHeight * DexDetailNode.HEIGHT_RATIO)
        dishImageNode.size = CGSize(width: WIDTH * DexDetailNode.WIDTH_RATIO, height: WIDTH * DexDetailNode.WIDTH_RATIO)
        
        dishNameNode.position = CGPoint(x: WIDTH / 2 + DexDetailNode.MINOR_OFFSET, y: HEIGHT / 3 + DexDetailNode.MINOR_OFFSET)
        dishNameNode.fontSize = DexDetailNode.DISH_NAME_FONTSIZE
        dishNameNode.fontName = DexDetailNode.NAME_FONT
        dishNameNode.fontColor = UIColor.brown
        
        questionMarkNode.color = UIColor.white
        questionMarkNode.position = dishImageNode.position
        questionMarkNode.fontSize = DexDetailNode.QMARK_FONTSIZE
        questionMarkNode.verticalAlignmentMode = .center
        questionMarkNode.zPosition = DexDetailNode.QUESTION_Z_POSITION
        questionMarkNode.isHidden = true
        
        effectNode.zPosition = DexDetailNode.OVERLAY_Z_POSITION
        dishDescriptionNode.zPosition = DexDetailNode.OVERLAY_Z_POSITION
        dishNameNode.zPosition = DexDetailNode.OVERLAY_Z_POSITION
        
        effectNode.addChild(dishImageNode)
        addChild(effectNode)
        addChild(dishNameNode)
        addChild(dishDescriptionNode)
        addChild(questionMarkNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
