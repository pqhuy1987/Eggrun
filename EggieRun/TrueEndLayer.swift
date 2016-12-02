//
//  TrueEndLayer.swift
//  EggieRun
//
//  Created by Liu Yang on 19/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

// Class: TrueEndLayer
// Description: the layer to be displayed when the Eggie reached to the end of the road and is
// cooked to Oyakodon. It animates the process of Eggie evolving into Chickie.

import SpriteKit

class TrueEndLayer: SKNode {
    fileprivate static let Z_POSITION_BACKGROUND: CGFloat = 1
    fileprivate static let Z_POSITION_FILTER: CGFloat = 2
    fileprivate static let Z_POSITION_CHICKIE: CGFloat = 3
    fileprivate static let ALPHA: CGFloat = 0
    fileprivate static let HIGHLIGHT_FILTER = CIFilter(name: "CIColorControls", withInputParameters: ["inputBrightness": 1])
    fileprivate static let TIME_FADE = 0.25
    fileprivate static let ATLAS_TIME_PER_FRAME = 0.25
    fileprivate static let CHANGE_REPEAT = 5
    fileprivate static let TIME_CHANGE = Double(CHANGE_REPEAT) * 2 * ATLAS_TIME_PER_FRAME
    fileprivate static let TIME_WAITING = 1.0
    fileprivate static let NAME_EGGIE = "eggie"
    fileprivate static let NAME_CHICKIE_SHADE = "chickie_shade"
    fileprivate static let NAME_CHICKIE = "chickie"
    fileprivate static let NAME_FILTER = "filter"
    fileprivate static let TEXTURE_EGGIE = SKTexture(imageNamed: "stand")
    fileprivate static let TEXTURE_CHICKIE = SKTexture(imageNamed: "chickie-1")
    fileprivate static let TEXTURE_LAY = SKTexture(imageNamed: "chickie-2")
    fileprivate static let ACTION_ENLARGE = SKAction.resize(toWidth: 250, height: 250, duration: ATLAS_TIME_PER_FRAME)
    fileprivate static let ACTION_SHRINK = SKAction.resize(toWidth: 50, height: 50, duration: ATLAS_TIME_PER_FRAME)

    fileprivate var action: SKAction!
    
    init(frame: CGRect) {
        super.init()
        
        alpha = TrueEndLayer.ALPHA
        
        let background = SKSpriteNode(color: UIColor.black, size: frame.size)
        background.zPosition = TrueEndLayer.Z_POSITION_BACKGROUND
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        effectNode.zPosition = TrueEndLayer.Z_POSITION_FILTER
        effectNode.filter = TrueEndLayer.HIGHLIGHT_FILTER
        effectNode.name = TrueEndLayer.NAME_FILTER

        let eggieShade = SKSpriteNode(texture: TrueEndLayer.TEXTURE_EGGIE)
        eggieShade.position = CGPoint(x: frame.midX, y: frame.midY)
        eggieShade.name = TrueEndLayer.NAME_EGGIE
        
        let chickieShade = SKSpriteNode(texture: TrueEndLayer.TEXTURE_CHICKIE)
        chickieShade.position = CGPoint(x: frame.midX, y: frame.midY)
        chickieShade.name = TrueEndLayer.NAME_CHICKIE_SHADE

        effectNode.addChild(eggieShade)
        effectNode.addChild(chickieShade)
        addChild(effectNode)
        
        let chickie = SKSpriteNode(texture: TrueEndLayer.TEXTURE_CHICKIE)
        chickie.zPosition = TrueEndLayer.Z_POSITION_CHICKIE
        chickie.position = CGPoint(x: frame.midX, y: frame.midY)
        chickie.alpha = TrueEndLayer.ALPHA
        chickie.name = TrueEndLayer.NAME_CHICKIE
        addChild(chickie)
        
        var eggieShadeActionsArray = [SKAction]()
        var chickieShadeActionsArray = [SKAction]()
        for _ in 0..<TrueEndLayer.CHANGE_REPEAT {
            eggieShadeActionsArray += [TrueEndLayer.ACTION_ENLARGE, TrueEndLayer.ACTION_SHRINK]
            chickieShadeActionsArray += [TrueEndLayer.ACTION_SHRINK, TrueEndLayer.ACTION_ENLARGE]
        }
        
        let fadeInAction = SKAction.fadeIn(withDuration: TrueEndLayer.TIME_FADE)
        let eggieShadeActions = SKAction.run(SKAction.run(SKAction.sequence(eggieShadeActionsArray), onChildWithName: TrueEndLayer.NAME_EGGIE), onChildWithName: TrueEndLayer.NAME_FILTER)
        let chickieShadeActions = SKAction.run(SKAction.run(SKAction.sequence(chickieShadeActionsArray), onChildWithName: TrueEndLayer.NAME_CHICKIE_SHADE), onChildWithName: TrueEndLayer.NAME_FILTER)
        let waitChangeAction = SKAction.wait(forDuration: TrueEndLayer.TIME_CHANGE)
        let eggieFadeOutChangingAction = SKAction.run(SKAction.run(SKAction.removeFromParent(), onChildWithName: TrueEndLayer.NAME_EGGIE), onChildWithName: TrueEndLayer.NAME_FILTER)
        let waitEggieFadeOutAction = SKAction.wait(forDuration: TrueEndLayer.TIME_FADE)
        let chickieAppearAction = SKAction.run(SKAction.fadeIn(withDuration: TrueEndLayer.TIME_FADE), onChildWithName: TrueEndLayer.NAME_CHICKIE)
        let waitAction = SKAction.wait(forDuration: TrueEndLayer.TIME_WAITING)
        let layAction = SKAction.run(SKAction.setTexture(TrueEndLayer.TEXTURE_LAY), onChildWithName: TrueEndLayer.NAME_CHICKIE)
        let clearFilterAction = SKAction.run(SKAction.removeFromParent(), onChildWithName: TrueEndLayer.NAME_FILTER)
        let clearChickieAction = SKAction.run(SKAction.removeFromParent(), onChildWithName: TrueEndLayer.NAME_CHICKIE)
        
        action = SKAction.sequence([fadeInAction, SKAction.group([eggieShadeActions, chickieShadeActions]), waitChangeAction, eggieFadeOutChangingAction, waitEggieFadeOutAction, chickieAppearAction, waitAction, layAction, waitAction, SKAction.group([clearFilterAction, clearChickieAction])])
    }
    
    func animate(_ completion: @escaping (Void) -> Void) {
        run(action, completion: completion)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
