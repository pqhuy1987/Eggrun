//
//  Pan.swift
//  EggieRun
//
//  Created by Liu Yang on 17/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

// Class: Pan
// Description: a subclass of Obstacle. Eggie has to jump over it 
// to avoid death. If Eggie is killed by a Pan, a dish will be generated 
// by frying Eggie.

import SpriteKit

class Pan: Obstacle {
    fileprivate static let IMAGE_NAME_LEFT = "pan-left"
    fileprivate static let IMAGE_NAME_RIGHT = "pan-right"
    fileprivate static let LID_HEIGHT: CGFloat = 80
    fileprivate static let WIDTH_LEFT = Obstacle.WIDTH * 0.7
    fileprivate static let WIDTH_RIGHT = Obstacle.WIDTH * 0.3
    
    fileprivate var left: SKSpriteNode
    fileprivate var right: SKSpriteNode
    
    init() {
        left = SKSpriteNode(imageNamed: Pan.IMAGE_NAME_LEFT)
        left.scale(Pan.WIDTH_LEFT)
        left.position.x = left.size.width / 2
        left.position.y = left.size.height / 2
        left.physicsBody = SKPhysicsBody(texture: left.texture!, alphaThreshold: GlobalConstants.PHYSICS_BODY_ALPHA_THRESHOLD, size: left.size)
        left.physicsBody!.categoryBitMask = BitMaskCategory.obstacle
        left.physicsBody!.contactTestBitMask = BitMaskCategory.hero
        left.physicsBody!.collisionBitMask = BitMaskCategory.hero | BitMaskCategory.obstacle
        left.physicsBody!.isDynamic = false
        
        right = SKSpriteNode(imageNamed: Pan.IMAGE_NAME_RIGHT)
        right.scale(Pan.WIDTH_RIGHT)
        right.position.x = left.size.width + right.size.width / 2
        right.position.y = right.size.height / 2 + 2
        
        super.init(cooker: .pan)
        addChild(left)
        addChild(right)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func isDeadly(_ vector: CGVector, point: CGPoint) -> Bool {
        return true
    }
    
    override func animateClose() {
        
    }
}
