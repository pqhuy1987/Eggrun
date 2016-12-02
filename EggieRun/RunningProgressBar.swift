//
//  RunningProgressBar.swift
//  EggieRun
//
//  Created by  light on 4/16/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

// Class: RunningProgressBar
// Description: a progress bar showing where the eggie has been through.
// It also displays a couple of milestones on it. The milestones will
// turn colourful when the eggie has reached it.

import SpriteKit

class RunningProgressBar: SKSpriteNode {
    fileprivate static let STANDARD_ANCHOR_POINT: CGPoint = CGPoint(x: 0, y: 1)
    fileprivate static let BAR_HEIGHT: CGFloat = 10
    static let MAX_DISTANCE = Milestone.ALL_VALUES.last!.requiredDistance
    fileprivate static let BUBBLE_Y: CGFloat = 6.0
    fileprivate static let BACKGROUND_COLOUR = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1)
    fileprivate static let BAR_BORDER_Y_POSITION: CGFloat = 2.5
    fileprivate static let BAR_BORDER_Z_POSITION: CGFloat = 1
    fileprivate static let PROGRESS_BAR_Z_POSITION: CGFloat = 1
    fileprivate static let BAR_BACKGROUND_Z_POSITION: CGFloat = 0
    fileprivate static let MILESTONE_BUBBLE_Z_POSITION: CGFloat = 2
    fileprivate static let MILESTONE_APPROACHING_DISTANCE = 2000
    fileprivate static let MILESTONE_APPROACHING_DURATION = 0.25
    fileprivate static let BAR_BORDER_IMAGE_NAME = "progress-bar-border"
    fileprivate static let MASK_IMAGE_NAME = "progress-bar-mask"
    fileprivate static let MILESTONE_APPROACHING_ACTION_KEY = "approaching"
    fileprivate static let MILESTONE_APPROACHING_ACTIONS = SKAction.sequence([2, 1].map({ SKAction.scale(to: $0, duration: RunningProgressBar.MILESTONE_APPROACHING_DURATION) }))
    
    fileprivate var barLength: CGFloat
    fileprivate var distance = 0
    fileprivate var barBorder: SKSpriteNode!
    fileprivate var progressBar: SKCropNode!
    fileprivate var distanceBar: SKSpriteNode!
    fileprivate var backgroundBar: SKSpriteNode!
    fileprivate let milestones: [Milestone]
    fileprivate var milestoneBubbles = [SKSpriteNode]()
    fileprivate var nextIndex = 0 {
        didSet {
            nextMilestone = milestones[nextIndex]
            nextMilestoneBubble = milestoneBubbles[nextIndex]
        }
    }
    fileprivate var nextMilestone: Milestone!
    fileprivate var nextMilestoneBubble: SKSpriteNode!
    
    init(length: CGFloat, allMilestones: [Milestone]) {
        barLength = length
        milestones = allMilestones
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: barLength, height: RunningProgressBar.BAR_HEIGHT))
        anchorPoint = RunningProgressBar.STANDARD_ANCHOR_POINT
        initializeBar()
        initializeMilestones()
        nextMilestone = milestones[nextIndex]
        nextMilestoneBubble = milestoneBubbles[nextIndex]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateDistance(_ movedDistance: Double) {
        distance += Int(movedDistance)
        distanceBar.size.width = getNewDistanceBarLength()
        if distance > nextMilestone.requiredDistance - RunningProgressBar.MILESTONE_APPROACHING_DISTANCE && nextMilestoneBubble.action(forKey: RunningProgressBar.MILESTONE_APPROACHING_ACTION_KEY) == nil {
            nextMilestoneBubble.run(RunningProgressBar.MILESTONE_APPROACHING_ACTIONS, withKey: RunningProgressBar.MILESTONE_APPROACHING_ACTION_KEY)
        }
    }
    
    func activateCurrentMilestone() {
        nextMilestoneBubble.texture = nextMilestone.colouredTexture
        if(nextIndex < milestones.count - 1) {
            nextIndex += 1
        }
    }
    
    fileprivate func initializeBar() {
        initializeBarBorder()
        initializeProgressBar()
    }
    
    fileprivate func initializeBarBorder() {
        barBorder = SKSpriteNode(imageNamed: RunningProgressBar.BAR_BORDER_IMAGE_NAME)
        barBorder.anchorPoint = RunningProgressBar.STANDARD_ANCHOR_POINT
        barBorder.size.width = barLength
        barBorder.position.y = RunningProgressBar.BAR_BORDER_Y_POSITION
        barBorder.zPosition = RunningProgressBar.BAR_BORDER_Z_POSITION
        addChild(barBorder)
    }
    
    fileprivate func initializeProgressBar() {
        progressBar = SKCropNode()
        progressBar.zPosition = RunningProgressBar.PROGRESS_BAR_Z_POSITION
        cropProgressBar()
        initializeDistanceBar()
        initializeBackgroundBar()

        addChild(progressBar)
        progressBar.addChild(backgroundBar)
        progressBar.addChild(distanceBar)
    }
    
    fileprivate func cropProgressBar() {
        let maskNode = SKSpriteNode(imageNamed: RunningProgressBar.MASK_IMAGE_NAME)
        maskNode.anchorPoint = RunningProgressBar.STANDARD_ANCHOR_POINT
        maskNode.size.width = barLength
        progressBar.maskNode = maskNode
    }
    
    fileprivate func initializeDistanceBar() {
        distanceBar = SKSpriteNode(color: UIColor.white, size: CGSize(width: getNewDistanceBarLength(), height: RunningProgressBar.BAR_HEIGHT))
        distanceBar.zPosition = RunningProgressBar.BAR_BACKGROUND_Z_POSITION
        distanceBar.anchorPoint = RunningProgressBar.STANDARD_ANCHOR_POINT
    }
    
    fileprivate func initializeBackgroundBar() {
        backgroundBar = SKSpriteNode(texture: nil, color: RunningProgressBar.BACKGROUND_COLOUR, size: CGSize(width: barLength, height: RunningProgressBar.BAR_HEIGHT))
        backgroundBar.zPosition = RunningProgressBar.BAR_BACKGROUND_Z_POSITION
        backgroundBar.anchorPoint = RunningProgressBar.STANDARD_ANCHOR_POINT
    }
    
    fileprivate func initializeMilestones() {
        milestoneBubbles = [SKSpriteNode]()
        for milestone in milestones {
            let milestoneBubble = SKSpriteNode(texture: milestone.monochromeTexture)
            let xPosition = CGFloat(milestone.requiredDistance) / CGFloat(RunningProgressBar.MAX_DISTANCE) * barLength
            milestoneBubble.position = CGPoint(x: xPosition, y: RunningProgressBar.BUBBLE_Y)
            milestoneBubble.zPosition = RunningProgressBar.MILESTONE_BUBBLE_Z_POSITION
            milestoneBubbles.append(milestoneBubble)
            addChild(milestoneBubble)
        }
    }

    fileprivate func getNewDistanceBarLength() -> CGFloat {
        return barLength * CGFloat(distance) / CGFloat(RunningProgressBar.MAX_DISTANCE)
    }
}
