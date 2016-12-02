//
//  platform.swift
//  EggieRun
//
//  Created by Liu Yang on 21/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

// Class: Platform
// Description: SKSpriteNode representing closet or shelf on which the Eggie
// can run. Closets are located at the bottom of the screen and its length 
// varies from 400 to 3600. Shelves are located at the middle of the screen 
// and its length varies from 210 to 1620.

import SpriteKit

class Platform: SKNode {
    fileprivate enum `Type` {
        case closet, shelf
    }
    
    fileprivate static let CLOSET_GAP_SIZE: CGFloat = 300
    fileprivate static let LEFT_IMAGE_NAMES: [Type: String] = [.closet: "closet-left", .shelf: "shelf-left"]
    fileprivate static let MIDDLE_IMAGE_NAMES: [Type: String] = [.closet: "closet-middle", .shelf: "shelf-middle"]
    fileprivate static let RIGHT_IMAGE_NAMES: [Type: String] = [.closet: "closet-right", .shelf: "shelf-right"]
    fileprivate static let BASELINE_HEIGHTS: [Type: CGFloat] = [.closet: -200, .shelf: 408]
    fileprivate static let HEIGHT: [Type: CGFloat] = [.closet: 274, .shelf: 50]

    var width: CGFloat = 0.0
    let followingGapSize: CGFloat
    let height: CGFloat
    let baselineHeight: CGFloat
    
    static func makeCloset(_ numOfMidPiece: Int) -> Platform {
        let imageNames = generateImageNameArray(.closet, numOfMidPiece: numOfMidPiece)
        return Platform(imageNames: imageNames, gapSize: Platform.CLOSET_GAP_SIZE, platformHeight: Platform.HEIGHT[.closet]!, platformBaselineHeight: Platform.BASELINE_HEIGHTS[.closet]!)
    }
    
    static func makeShelf(_ numOfMidPiece: Int, gapSize: CGFloat) -> Platform {
        let imageNames = generateImageNameArray(.shelf, numOfMidPiece: numOfMidPiece)
        
        return Platform(imageNames: imageNames, gapSize: gapSize, platformHeight: Platform.HEIGHT[.shelf]!, platformBaselineHeight: Platform.BASELINE_HEIGHTS[.shelf]!)
    }
    
    static fileprivate func generateImageNameArray(_ type: Type, numOfMidPiece: Int) -> [String] {
        var imageNames = [Platform.LEFT_IMAGE_NAMES[type]!]
        for _ in 0..<numOfMidPiece {
            imageNames.append(Platform.MIDDLE_IMAGE_NAMES[type]!)
        }
        imageNames.append(Platform.RIGHT_IMAGE_NAMES[type]!)
        
        return imageNames
    }
    
    fileprivate init(imageNames: [String], gapSize: CGFloat, platformHeight: CGFloat, platformBaselineHeight: CGFloat) {
        followingGapSize = gapSize
        height = platformHeight
        baselineHeight = platformBaselineHeight
        super.init()
        
        for imageName in imageNames {
            let texture = SKTexture(imageNamed: imageName)
            let node = SKSpriteNode(texture: texture)
            
            node.position.x = width + node.size.width / 2
            node.position.y = node.size.height / 2
            node.physicsBody = constructPhysicsBodyFor(texture)
            width += node.size.width
            addChild(node)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func constructPhysicsBodyFor(_ texture: SKTexture) -> SKPhysicsBody {
        let body = SKPhysicsBody(texture: texture, alphaThreshold: GlobalConstants.PHYSICS_BODY_ALPHA_THRESHOLD, size: texture.size())
        
        body.categoryBitMask = BitMaskCategory.platform
        body.contactTestBitMask = BitMaskCategory.hero
        body.collisionBitMask = BitMaskCategory.hero
        body.isDynamic = false
        return body
    }
}
