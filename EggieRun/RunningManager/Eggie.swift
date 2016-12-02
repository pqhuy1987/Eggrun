//
//  Eggie.swift
//  EggieRun
//
//  Created by Liu Yang on 23/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

// Class: Eggie
// Description: a SKSpriteNode representing the hero of the game who runs and 
// jumps on the platforms, collects ingredients and condiments, as well as dies 
// to make dishes.

import SpriteKit

class Eggie: SKSpriteNode {
    // Constants
    fileprivate static let SPEED_STATIC = 0
    fileprivate static let SPEED_RUNNING = 600
    fileprivate static let ATLAS_TIME = 0.2
    fileprivate static let ATLAS_COUNT = 5
    fileprivate static let ATLAS_TIME_PER_FRAME = Eggie.ATLAS_TIME / Double(Eggie.ATLAS_COUNT)
    fileprivate static let ATLAS_ACTION_KEY = "atlas"
    fileprivate static let PHYSICS_BODY_TEXTURE_ID = 3
    
    enum State {
        case standing, running, jumping_1, jumping_2, dying
    }
    
    fileprivate var innerCurrentSpeed: Int
    fileprivate var innerState: State
    fileprivate var actions: [State: SKAction] = [State: SKAction]()
    fileprivate var balancedXPosition: CGFloat
    
    init(startPosition: CGPoint) {
        let runAtlas = SKTextureAtlas(named: "run.atlas")
        let jumpAtlas = SKTextureAtlas(named: "jump.atlas")
        let sortedRunTextureNames = runAtlas.textureNames.sorted()
        let sortedJumpTextureNames = jumpAtlas.textureNames.sorted()
        let standingTexture = runAtlas.textureNamed(sortedRunTextureNames[0])
        let runTextures: [SKTexture]
        let jumpTextures: [SKTexture]
        
        innerState = .standing
        balancedXPosition = startPosition.x
        innerCurrentSpeed = Eggie.SPEED_STATIC
        super.init(texture: standingTexture, color: UIColor.clear, size: standingTexture.size())

        runTextures = sortedRunTextureNames.map({ runAtlas.textureNamed($0) })
        jumpTextures = sortedJumpTextureNames.map({ jumpAtlas.textureNamed($0) })
        
        actions[.standing] = SKAction.setTexture(standingTexture)
        actions[.running] = SKAction.repeatForever(SKAction.animate(with: runTextures, timePerFrame: Eggie.ATLAS_TIME_PER_FRAME))
        actions[.jumping_1] = SKAction.repeatForever(SKAction.animate(with: jumpTextures, timePerFrame: Eggie.ATLAS_TIME_PER_FRAME))
        actions[.jumping_2] = actions[.jumping_1]
        actions[.dying] = SKAction.setTexture(standingTexture)
        
        run(actions[.standing]!)
        
        physicsBody = SKPhysicsBody(texture: runTextures[Eggie.PHYSICS_BODY_TEXTURE_ID], alphaThreshold: GlobalConstants.PHYSICS_BODY_ALPHA_THRESHOLD, size: size)
        physicsBody!.mass = GlobalConstants.EGGIE_MASS
        physicsBody!.categoryBitMask = BitMaskCategory.hero
        physicsBody!.contactTestBitMask = BitMaskCategory.scene | BitMaskCategory.collectable | BitMaskCategory.platform | BitMaskCategory.obstacle
        physicsBody!.collisionBitMask = BitMaskCategory.platform | BitMaskCategory.scene | BitMaskCategory.obstacle
        physicsBody!.allowsRotation = false
        physicsBody!.usesPreciseCollisionDetection = true

        position = startPosition
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var state: State {
        get {
            return innerState
        }
        
        set(newState) {
            if newState == innerState {
                return
            }
            
            innerState = newState
            removeAllActions()
            run(actions[newState]!, withKey: Eggie.ATLAS_ACTION_KEY)
            
            switch newState {
            case .standing, .dying:
                innerCurrentSpeed = Eggie.SPEED_STATIC
            case .running:
                innerCurrentSpeed = Eggie.SPEED_RUNNING
            case .jumping_1, .jumping_2:
                physicsBody!.velocity.dy = min(physicsBody!.velocity.dy + GlobalConstants.EGGIE_JUMPING_ACCELERATION.dy, GlobalConstants.EGGIE_MAX_Y_SPEED)
            }
        }
    }
    
    var currentSpeed: Int {
        return innerCurrentSpeed
    }
    
    func balance() {
        position.x = balancedXPosition
    }
    
    func pauseAtlas() {
        if let action = action(forKey: Eggie.ATLAS_ACTION_KEY) {
            action.speed = 0
        }
    }
    
    func unpauseAtlas() {
        if let action = action(forKey: Eggie.ATLAS_ACTION_KEY) {
            action.speed = 1
        }
    }
}
