//
//  GameScene.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/18/16.
//  Copyright (c) 2016 Eggieee. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    static var instance: GameScene?
    
    // UI Components
    fileprivate static let BACKGROUND_IMAGE_NAME = "default-background"
    fileprivate static let HELP_BUTTON_IMAGE_NAME = "help"
    fileprivate static let HELP_BUTTON_SIZE = CGSize(width: 80, height: 80)
    fileprivate static let HELP_BUTTON_TOP_OFFSET: CGFloat = 50
    fileprivate static let HELP_BUTTON_RIGHT_OFFSET: CGFloat = 50
    fileprivate static let PAUSE_BUTTON_IMAGE_NAME = "pause"
    fileprivate static let PAUSE_BUTTON_SIZE = CGSize(width: 80, height: 80)
    fileprivate static let PAUSE_BUTTON_TOP_OFFSET: CGFloat = 50
    fileprivate static let PAUSE_BUTTON_RIGHT_OFFSET: CGFloat = 50
    
    fileprivate static let EGGIE_X_POSITION: CGFloat = 200
    fileprivate static let COLLECTABLE_SIZE = CGSize(width: 80, height: 80)
    
    // Constants for Level Generation
    fileprivate static let DISTANCE_CLOSET_AND_COLLECTABLE: CGFloat = 200
    fileprivate static let DISTANCE_SHELF_AND_COLLECTABLE: CGFloat = 50
    fileprivate static let OBSTACLE_RATE_LOW = 0.2
    fileprivate static let OBSTACLE_RATE_HIGH = 0.7
    fileprivate static let COLLECTABLE_RATE = 0.3
    
    fileprivate static let PREGENERATED_LENGTH = UIScreen.main.bounds.width * 2
    
    fileprivate static let OBSTACLE_BUFFER_DISTANCE = 400.0
    fileprivate static let COLLECTABLE_BUFFER_DISTANCE: CGFloat = 200
    
    // HUD Positioning
    fileprivate static let INGREDIENT_BAR_X_OFFSET: CGFloat = 18
    fileprivate static let INGREDIENT_BAR_Y_OFFSET: CGFloat = 45
    fileprivate static let PROGRESS_BAR_X_OFFSET: CGFloat = 18
    fileprivate static let PROGRESS_BAR_Y_OFFSET: CGFloat = 26
    fileprivate static let FLAVOUR_BAR_OFFSET: CGFloat = 100
    
    fileprivate static let LEFT_FRAME_OFFSET: CGFloat = 400
    fileprivate static let TOP_FRAME_OFFSET: CGFloat = 10000
    
    fileprivate static let INGREDIENT_BAR_ANIMATION_TIME = 0.5
    
    // zPositions
    fileprivate static let HUD_Z_POSITION: CGFloat = 50
    fileprivate static let TRUE_END_LAYER_Z_POSITION: CGFloat = 75
    fileprivate static let OVERLAY_Z_POSITION: CGFloat = 100
    fileprivate static let TUTORIAL_Z_POSITION: CGFloat = 150
    
    // Constants for Challenges
    fileprivate static let CHALLENGE_ROLL_MIN_DISTANCE: UInt32 = 1000
    fileprivate static let CHALLENGE_ROLL_MAX_DISTANCE: UInt32 = 10000
    fileprivate static let CHALLENGE_DARKNESS_TIME = 0.25
    fileprivate static let CHALLENGE_DARKNESS_REPEAT = 3
    fileprivate static let CHALLENGE_DARKNESS_ACTION_KEY = "challenge-darkness"
    fileprivate static let CHALLENGE_EARTHQUAKE_TIME = 0.07
    fileprivate static let CHALLENGE_EARTHQUAKE_RANGE: UInt32 = 150
    fileprivate static let CHALLENGE_EARTHQUAKE_REPEAT = 8
    fileprivate static let CHALLENGE_EARTHQUAKE_ACTION_KEY = "challenge-earthquake"
    
    // SEs
    fileprivate static let SE_COLLECT = SKAction.playSoundFileNamed("collect-sound.mp3", waitForCompletion: false)
    fileprivate static let SE_JUMP = SKAction.playSoundFileNamed("jump-sound.mp3", waitForCompletion: false)
    fileprivate static let SE_OBSTACLES: [Cooker: SKAction] = [.drop: "drop-sound.mp3", .oven: "oven-sound.mp3", .pot: "pot-sound.mp3", .pan: "pan-sound.mp3"].map({ SKAction.playSoundFileNamed($0, waitForCompletion: false) })
    
    fileprivate enum GameState {
        case ready, playing, over, paused
    }
    
    fileprivate var eggie: Eggie!
    fileprivate var closetFactory: ClosetFactory!
    fileprivate var shelfFactory: ShelfFactory!
    fileprivate var collectableFactory: CollectableFactory!
    fileprivate var obstacleFactory: ObstacleFactory!
    fileprivate var ingredientBar: IngredientBar!
    fileprivate var flavourBar: FlavourBar!
    fileprivate var runningProgressBar: RunningProgressBar!
    fileprivate var gameState: GameState!
    fileprivate var currentDistance = 0
    fileprivate var closets: [Platform]!
    fileprivate var shelves: [Platform]!
    fileprivate var collectables: Set<Collectable>!
    fileprivate var obstacles: [Obstacle]!
    fileprivate var lastUpdatedTime: CFTimeInterval!
    fileprivate var normalEndLayer: NormalEndLayer?
    fileprivate var pauseButton: SKSpriteNode!
    fileprivate var helpButton: SKSpriteNode!
    fileprivate var pausedLayer: PausedLayer?
    fileprivate var milestones: [Milestone] = Milestone.ALL_VALUES
    fileprivate var tutorialLayer: TutorialLayer?
    fileprivate var tutorialBackground: SKSpriteNode?
    fileprivate var nextMilestoneIndex = 0 {
        didSet {
            if nextMilestoneIndex < milestones.count {
                nextMilestone = milestones[nextMilestoneIndex]
            } else {
                nextMilestone = nil
            }
        }
    }
    fileprivate var nextMilestone: Milestone?
    fileprivate var availableCookers = [Cooker]()
    fileprivate var obstacleRate: Double!
    fileprivate var isCookerIncreased = false
    fileprivate var nextDarknessChallengeDistance = 0
    fileprivate var nextEarthquakeChallengeDistance = 0
    fileprivate var darknessOverlay: SKSpriteNode?
    fileprivate var earthquakeNodes = [SKNode]()

    
    // ==================== SKScene Lifecycle ====================
    
    override func didMove(to view: SKView) {
        GameScene.instance = self
        BGMPlayer.singleton.moveToStatus(.game)
        
        initializePhysicsProperties()
        gameReady()
    }
    
    override func willMove(from view: SKView) {
        removeAllChildren()
        GameScene.instance = nil
    }
    
    // ==================== Touch Handlers ====================
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if gameState == .ready {
            let touchLocation = touch.location(in: self)
            if tutorialLayer != nil {
                let touchLocation = touch.location(in: tutorialLayer!)
                if tutorialLayer!.nextPageNode.contains(touchLocation) {
                    tutorialLayer!.getNextTutorial()
                } else if tutorialLayer!.prevPageNode.contains(touchLocation) {
                    tutorialLayer!.getPrevTutorial()
                } else if !tutorialLayer!.tutorialNode.contains(touchLocation) {
                    tutorialLayer!.removeFromParent()
                    tutorialBackground!.removeFromParent()
                    tutorialLayer = nil
                }
            } else if helpButton.contains(touchLocation)  {
                initializeTutorial()
            } else {
                gameStart()
            }
        } else if gameState == .over && normalEndLayer != nil {
            let touchLocation = touch.location(in: normalEndLayer!)
            
            if normalEndLayer!.eggdexButton.contains(touchLocation) {
                let dexScene = DexScene(size: size)
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                view?.presentScene(dexScene, transition: transition)
            } else if normalEndLayer!.playButton.contains(touchLocation) {
                gameReady()
            }
        } else if gameState == .paused && pausedLayer != nil {
            let touchLocation = touch.location(in: pausedLayer!)
            
            if pausedLayer!.unpauseButton.contains(touchLocation) {
                unpause()
            } else if pausedLayer!.backToMenuButton.contains(touchLocation) {
                let menuScene = MenuScene.singleton
                view?.presentScene(menuScene!, transition: MenuScene.BACK_TRANSITION)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState == .playing {
            let touch = touches.first!
            let touchLocation = touch.location(in: self)
            
            if pauseButton.contains(touchLocation) {
                pause()
            } else if eggie.state == .running {
                eggie.state = .jumping_1
                run(GameScene.SE_JUMP)
            } else if eggie.state == .jumping_1 {
                eggie.state = .jumping_2
                run(GameScene.SE_JUMP)
            }
        }
    }
    
    // ==================== Update & Contact Logic ====================
    
    override func update(_ currentTime: TimeInterval) {
        if (gameState == .playing || gameState == .ready) {
            if lastUpdatedTime == nil {
                lastUpdatedTime = currentTime
                return
            }
            
            let timeInterval = currentTime - lastUpdatedTime
            lastUpdatedTime = currentTime
            
            let movedDistance = timeInterval * Double(eggie.currentSpeed)
            updateDistance(movedDistance)
            eggie.balance()
            flavourBarFollow()
            shiftShelf(movedDistance)
            shiftClosets(movedDistance)
            shiftCollectables(movedDistance)
            shiftObstacles(movedDistance)
            
            if nextDarknessChallengeDistance > 0 && currentDistance > nextDarknessChallengeDistance {
                challengeDarkness()
                nextDarknessChallengeDistance = getNextChallengeDistance(currentDistance)
            }
            
            if nextEarthquakeChallengeDistance > 0 && currentDistance > nextEarthquakeChallengeDistance {
                challengeEarthquake()
                nextEarthquakeChallengeDistance = getNextChallengeDistance(currentDistance)
            }
        }
    }
    
    fileprivate func flavourBarFollow() {
        flavourBar.position = CGPoint(x: eggie.position.x, y: eggie.position.y + GameScene.FLAVOUR_BAR_OFFSET)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameState != .playing {
            return
        }
        
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskCategory.hero | BitMaskCategory.scene {
            gameOver(.drop)
        } else if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskCategory.hero | BitMaskCategory.platform {
            let impulse: CGVector
            if contact.bodyA.categoryBitMask == BitMaskCategory.platform {
                impulse = contact.contactNormal
            } else {
                impulse = CGVector(dx: -1 * contact.contactNormal.dx, dy: -1 * contact.contactNormal.dy)
            }
            
            if impulse.dy > 0 {
                eggie.state = .running
            }
        } else if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskCategory.hero | BitMaskCategory.collectable {
            let collectable: Collectable
            if contact.bodyA.categoryBitMask == BitMaskCategory.collectable {
                collectable = contact.bodyA.node as! Collectable
            } else {
                collectable = contact.bodyB.node as! Collectable
            }
            
            let position = collectable.position
            collectable.isHidden = true
            collectable.physicsBody?.categoryBitMask = 0
            collectable.physicsBody?.contactTestBitMask = 0
            
            run(GameScene.SE_COLLECT)
            
            if collectable.type == .ingredient {
                animateMovingIngredient(collectable.ingredient!, originalPosition: collectable.position)
            } else {
                flavourBar.addCondiment(collectable.condiment!)
            }
            
            if let particles = SKEmitterNode(fileNamed: "Collection.sks") {
                particles.position = position
                collectable.emitter = particles
                addChild(particles)
            }
        } else if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskCategory.hero | BitMaskCategory.obstacle {
            var obstacle: Obstacle
            if contact.bodyA.categoryBitMask == BitMaskCategory.obstacle {
                obstacle = contact.bodyA.node!.parent as! Obstacle
            } else {
                obstacle = contact.bodyB.node!.parent as! Obstacle
            }
            
            if obstacle.isDeadly(contact.contactNormal, point: contact.contactPoint) {
                eggie.isHidden = true
                obstacle.animateClose()
                gameOver(obstacle.cookerType)
            } else {
                obstacle.isPassed = true
                eggie.state = .running
            }
        }
    }
    
    // ==================== Initialization ====================
    
    fileprivate func initializePhysicsProperties() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = GlobalConstants.GRAVITY
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: frame.minX - GameScene.LEFT_FRAME_OFFSET, y: frame.minY, width: frame.width + GameScene.LEFT_FRAME_OFFSET, height: frame.height + GameScene.TOP_FRAME_OFFSET))
        physicsBody!.categoryBitMask = BitMaskCategory.scene
        physicsBody!.contactTestBitMask = BitMaskCategory.hero
    }
    
    fileprivate func initializeObstacle() {
        availableCookers = [Cooker]()
        obstacleRate = GameScene.OBSTACLE_RATE_LOW
        obstacleFactory = ObstacleFactory()
        obstacles = [Obstacle]()
    }
    
    fileprivate func initializeCloset() {
        closetFactory = ClosetFactory()
        closets = [Platform]()
        appendNewCloset(0)
    }
    
    fileprivate func initializeShelf() {
        shelfFactory = ShelfFactory()
        shelves = [Platform]()
    }
    
    fileprivate func initialzieCollectable() {
        collectableFactory = CollectableFactory()
        collectables = Set<Collectable>()
    }
    
    fileprivate func initializeEggie() {
        eggie = Eggie(startPosition: CGPoint(x: GameScene.EGGIE_X_POSITION, y: frame.midY))
        addChild(eggie)
    }
    
    fileprivate func initializeCollectableBars() {
        ingredientBar = IngredientBar()
        ingredientBar.position = CGPoint(x: GameScene.INGREDIENT_BAR_X_OFFSET, y: frame.height-ingredientBar.frame.height/2 - GameScene.INGREDIENT_BAR_Y_OFFSET)
        ingredientBar.zPosition = GameScene.HUD_Z_POSITION
        addChild(ingredientBar)
        
        flavourBar = FlavourBar()
        flavourBar.zPosition = GameScene.HUD_Z_POSITION
        flavourBarFollow()
        addChild(flavourBar)
    }
    
    fileprivate func initializeRunningProgressBar() {
        let barLength = frame.width - 2 * GameScene.PROGRESS_BAR_X_OFFSET
        runningProgressBar = RunningProgressBar(length: barLength, allMilestones: milestones)
        runningProgressBar.position = CGPoint(x: GameScene.PROGRESS_BAR_X_OFFSET, y: frame.height - GameScene.PROGRESS_BAR_Y_OFFSET)
        addChild(runningProgressBar)
    }

    fileprivate func initializePauseButton() {
        pauseButton = SKSpriteNode(imageNamed: GameScene.PAUSE_BUTTON_IMAGE_NAME)
        pauseButton.size = GameScene.PAUSE_BUTTON_SIZE
        pauseButton.anchorPoint = CGPoint(x: 1, y: 1)
        pauseButton.position = CGPoint(x: scene!.frame.maxX - GameScene.PAUSE_BUTTON_RIGHT_OFFSET, y: scene!.frame.maxY - GameScene.PAUSE_BUTTON_TOP_OFFSET)
        pauseButton.isHidden = true
        addChild(pauseButton)
    }
    
    fileprivate func initializeHelpButton() {
        helpButton = SKSpriteNode(imageNamed: GameScene.HELP_BUTTON_IMAGE_NAME)
        helpButton.size = GameScene.HELP_BUTTON_SIZE
        helpButton.anchorPoint = CGPoint(x: 1, y: 1)
        helpButton.position = CGPoint(x: scene!.frame.maxX - GameScene.HELP_BUTTON_RIGHT_OFFSET, y: scene!.frame.maxY - GameScene.HELP_BUTTON_TOP_OFFSET)
        helpButton.isHidden = false
        addChild(helpButton)
    }
    
    fileprivate func initializeMilestone() {
        nextMilestoneIndex = 0
    }
    
    fileprivate func initializeTutorial() {
        tutorialLayer = TutorialLayer(frameWidth: frame.width, frameHeight: frame.height)
        tutorialLayer!.zPosition = GameScene.TUTORIAL_Z_POSITION
        addChild(tutorialLayer!)
        
        tutorialBackground = SKSpriteNode(color: UIColor.black, size: CGSize(width: frame.width, height: frame.height))
        tutorialBackground!.position = CGPoint(x: frame.width/2, y: frame.height/2)
        tutorialBackground!.zPosition = GameScene.OVERLAY_Z_POSITION
        tutorialBackground!.alpha = 0.5
        addChild(tutorialBackground!)
    }
    
    // ==================== State Changes ====================
    
    fileprivate func gameReady() {
        removeAllChildren()
        changeBackground(GameScene.BACKGROUND_IMAGE_NAME)
        initializeObstacle()
        initialzieCollectable()
        initializeCloset()
        initializeShelf()
        initializeEggie()
        initializeCollectableBars()
        initializeRunningProgressBar()
        initializePauseButton()
        initializeHelpButton()
        initializeMilestone()
        
        if DishDataController.singleton.activatedDishes.isEmpty {
            initializeTutorial()
        }
        
        currentDistance = 0
        gameState = .ready
    }
    
    fileprivate func gameStart() {
        pauseButton.isHidden = false
        helpButton.isHidden = true
        eggie.state = .running
        gameState = .playing
    }
    
    fileprivate func gameOver(_ wayOfDie: Cooker) {
        eggie.state = .dying
        gameState = .over
        
        if let action = GameScene.SE_OBSTACLES[wayOfDie] {
            run(action)
        }
        
        flavourBar.removeFromParent()
        
        let (dish, isNew) = DishDataController.singleton.getResultDish(wayOfDie, condiments: flavourBar.condimentDictionary, ingredients: ingredientBar.ingredients)
        
        normalEndLayer = NormalEndLayer(usedCooker: wayOfDie, generatedDish: dish, isNew: isNew)
        normalEndLayer!.zPosition = GameScene.OVERLAY_Z_POSITION
        normalEndLayer!.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(normalEndLayer!)
    }
    
    fileprivate func endOyakodon() {
        gameState = .over
        
        let endLayer = TrueEndLayer(frame: frame)
        endLayer.zPosition = GameScene.TRUE_END_LAYER_Z_POSITION
        endLayer.position = CGPoint(x: 0, y: 0)
        addChild(endLayer)
        endLayer.animate({ self.gameOver(.distanceForceDeath) })
    }
    
    // ==================== Update Logic Components ====================
    
    fileprivate func updateDistance(_ movedDistance: Double) {
        currentDistance += Int(movedDistance)
        if nextMilestone != nil && currentDistance >= nextMilestone!.requiredDistance {
            activateCurrentMilestone()
        }
        runningProgressBar.updateDistance(movedDistance)
    }
    
    fileprivate func shiftClosets(_ distance: Double) {
        let rightMostCloset = closets.last!
        let rightMostClosetRightEnd = rightMostCloset.position.x + rightMostCloset.width + rightMostCloset.followingGapSize
        
        if rightMostClosetRightEnd < GameScene.PREGENERATED_LENGTH {
            appendNewCloset(rightMostClosetRightEnd)
        }
        
        removePassedPlatforms(closets, distance: distance)
    }
    
    fileprivate func shiftShelf(_ distance: Double) {
        if shelves.isEmpty {
            return
        }
        
        let rightMostShelf = shelves.last!
        let rightMostShelfRightEnd = rightMostShelf.position.x + rightMostShelf.width + rightMostShelf.followingGapSize
        
        if rightMostShelfRightEnd < GameScene.PREGENERATED_LENGTH {
            appendNewShelf(rightMostShelfRightEnd)
        }
        
        removePassedPlatforms(shelves, distance: distance)
    }
    
    private func removePassedPlatforms(_ platforms: [Platform], distance: Double) {
        var platforms = platforms
        for platform in platforms {
            if platform.position.x + platform.width + platform.followingGapSize < 0 {
                platforms.removeFirst()
                platform.removeFromParent()
            } else {
                platform.position.x -= CGFloat(distance)
            }
        }
    }
    
    fileprivate func shiftCollectables(_ distance: Double) {
        for collectable in collectables {
            if collectable.position.x + collectable.size.width / 2 < 0 {
                collectable.removeFromParent()
                collectables.remove(collectable)
            } else {
                collectable.position.x -= CGFloat(distance)
            }
        }
    }
    
    fileprivate func shiftObstacles(_ distance: Double) {
        for obstacle in obstacles {
            if obstacle.position.x + CGFloat(Obstacle.WIDTH) < 0 {
                obstacle.removeFromParent()
                obstacles.removeFirst()
            } else {
                obstacle.position.x -= CGFloat(distance)
            }
        }
    }
    
    fileprivate func appendNewCloset(_ position: CGFloat) {
        let closet = closetFactory.next()
        closet.position.x = position
        closet.position.y = closet.baselineHeight
        closets.append(closet)
        addChild(closet)
        addCollectableOn(closet, distance: GameScene.DISTANCE_CLOSET_AND_COLLECTABLE)
        
        if !availableCookers.isEmpty {
            var position = CGFloat(GameScene.OBSTACLE_BUFFER_DISTANCE)
            while position < closet.width - CGFloat(GameScene.OBSTACLE_BUFFER_DISTANCE) {
                if Double(arc4random()) / Double(UINT32_MAX) <= obstacleRate {
                    let obstacle = obstacleFactory.next(availableCookers)
                    obstacle.position.y = closet.baselineHeight + closet.height + obstacle.heightPadding
                    obstacle.position.x = closet.position.x + position
                    obstacles.append(obstacle)
                    addChild(obstacle)
                    position += CGFloat(Obstacle.WIDTH + GameScene.OBSTACLE_BUFFER_DISTANCE)
                } else {
                    position += CGFloat(GameScene.OBSTACLE_BUFFER_DISTANCE)
                }
            }
        }
    }
    
    fileprivate func appendNewShelf(_ position: CGFloat) {
        let shelf = shelfFactory.next()
        shelf.position.x = position
        shelf.position.y = shelf.baselineHeight
        shelves.append(shelf)
        addChild(shelf)
        addCollectableOn(shelf, distance: GameScene.DISTANCE_SHELF_AND_COLLECTABLE)
    }
    
    fileprivate func addCollectableOn(_ platform: Platform, distance: CGFloat) {
        var position = GameScene.COLLECTABLE_BUFFER_DISTANCE
        while position < platform.width - GameScene.COLLECTABLE_BUFFER_DISTANCE {
            if Double(arc4random()) / Double(UINT32_MAX) <= GameScene.COLLECTABLE_RATE {
                let collectable = collectableFactory.next(currentDistance)
                collectable.position.y = platform.baselineHeight + platform.height + Collectable.SIZE.height / 2 + distance
                collectable.position.x = platform.position.x + position
                collectables.insert(collectable)
                addChild(collectable)
                position += Collectable.SIZE.width + GameScene.COLLECTABLE_BUFFER_DISTANCE
            } else {
                position += GameScene.COLLECTABLE_BUFFER_DISTANCE
            }
        }
    }
    
    fileprivate func animateMovingIngredient(_ ingredient: Ingredient, originalPosition: CGPoint) {
        let ingredientNode = SKSpriteNode(texture: ingredient.fineTexture, color: UIColor.clear, size: GameScene.COLLECTABLE_SIZE)
        ingredientNode.position = originalPosition
        let newPosition = CGPoint(x: ingredientBar.getNextGridX(ingredient) + GameScene.INGREDIENT_BAR_X_OFFSET, y: ingredientBar.position.y)
        let moveAction = SKAction.move(to: newPosition, duration: GameScene.INGREDIENT_BAR_ANIMATION_TIME)
        let fadeOutAction = SKAction.fadeOut(withDuration: GameScene.INGREDIENT_BAR_ANIMATION_TIME)
        let actions = [moveAction, fadeOutAction]
        let actionGroup = SKAction.group(actions)
        addChild(ingredientNode)
        ingredientNode.run(actionGroup, completion: { self.ingredientBar.addIngredient(ingredient) })
    }
    
    fileprivate func activateCurrentMilestone() {
        runningProgressBar.activateCurrentMilestone()
        activateMilestoneEvent()
        nextMilestoneIndex += 1
    }
    
    fileprivate func getNextChallengeDistance(_ currentDistance: Int) -> Int {
        let delta = arc4random_uniform(GameScene.CHALLENGE_ROLL_MAX_DISTANCE - GameScene.CHALLENGE_ROLL_MIN_DISTANCE) + GameScene.CHALLENGE_ROLL_MIN_DISTANCE
        return currentDistance + Int(delta)
    }
    
    fileprivate func activateMilestoneEvent() {
        switch nextMilestone! {
        case .presentPot:
            availableCookers.append(.pot)
        case .presentShelf:
            appendNewShelf(UIScreen.main.bounds.width)
        case .presentOven:
            availableCookers.append(.oven)
        case .challengeDarkness:
            nextDarknessChallengeDistance = currentDistance
        case .presentPan:
            availableCookers.append(.pan)
        case .challengeQuake:
            nextEarthquakeChallengeDistance = currentDistance
        case .increasePot:
            obstacleRate = GameScene.OBSTACLE_RATE_HIGH
        case .endOyakodon:
            endOyakodon()
        }
    }
    
    // ==================== Challenges ====================
    
    fileprivate func challengeDarkness() {
        darknessOverlay = SKSpriteNode(color: UIColor.black, size: size)
        darknessOverlay!.alpha = 0
        darknessOverlay!.position = CGPoint(x: frame.midX, y: frame.midY)
        darknessOverlay!.zPosition = GameScene.OVERLAY_Z_POSITION - 1
        addChild(darknessOverlay!)
        
        let fadeInAction = SKAction.fadeIn(withDuration: GameScene.CHALLENGE_DARKNESS_TIME)
        let fadeOutAction = SKAction.fadeOut(withDuration: GameScene.CHALLENGE_DARKNESS_TIME)
        
        var actions: [SKAction] = []
        for _ in 0 ..< GameScene.CHALLENGE_DARKNESS_REPEAT {
            actions.append(contentsOf: [fadeInAction, fadeOutAction])
        }
        actions.append(SKAction.removeFromParent())
        
        darknessOverlay!.run(SKAction.sequence(actions), withKey: GameScene.CHALLENGE_DARKNESS_ACTION_KEY)
    }
    
    fileprivate func challengeEarthquake() {
        earthquakeNodes.removeAll()
        
        var actions: [SKAction] = []
        for _ in 0 ..< GameScene.CHALLENGE_EARTHQUAKE_REPEAT {
            let dx = CGFloat(arc4random_uniform(GameScene.CHALLENGE_EARTHQUAKE_RANGE))
            let dy = CGFloat(arc4random_uniform(GameScene.CHALLENGE_EARTHQUAKE_RANGE))
            actions.append(SKAction.moveBy(x: dx, y: dy, duration: GameScene.CHALLENGE_EARTHQUAKE_TIME))
            actions.append(SKAction.moveBy(x: -dx, y: -dy, duration: GameScene.CHALLENGE_EARTHQUAKE_TIME))
        }
        let sequenceAction = SKAction.sequence(actions)
        
        for closet in closets {
            earthquakeNodes.append(closet)
        }
        for shelf in shelves {
            earthquakeNodes.append(shelf)
        }
        for obstacle in obstacles {
            earthquakeNodes.append(obstacle)
        }
        for collectable in collectables {
            earthquakeNodes.append(collectable)
        }
        
        for node in earthquakeNodes {
            node.run(sequenceAction, withKey: GameScene.CHALLENGE_EARTHQUAKE_ACTION_KEY)
        }
    }
    
    // ==================== Pause Logic ====================
    
    func pause() {
        if gameState == .playing {
            physicsWorld.speed = 0
            gameState = .paused
            eggie.pauseAtlas()
            if darknessOverlay != nil {
                if let action = darknessOverlay?.action(forKey: GameScene.CHALLENGE_DARKNESS_ACTION_KEY) {
                    action.speed = 0
                }
            }
            for node in earthquakeNodes {
                if let action = node.action(forKey: GameScene.CHALLENGE_EARTHQUAKE_ACTION_KEY) {
                    action.speed = 0
                }
            }
            pausedLayer = PausedLayer(frameSize: frame.size)
            pausedLayer!.zPosition = GameScene.OVERLAY_Z_POSITION
            pausedLayer!.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(pausedLayer!)
        }
    }
    
    fileprivate func unpause() {
        if gameState == .paused {
            pausedLayer!.removeFromParent()
            lastUpdatedTime = nil
            gameState = .playing
            physicsWorld.speed = 1
            eggie.unpauseAtlas()
            if darknessOverlay != nil {
                if let action = darknessOverlay?.action(forKey: GameScene.CHALLENGE_DARKNESS_ACTION_KEY) {
                    action.speed = 1
                }
            }
            for node in earthquakeNodes {
                if let action = node.action(forKey: GameScene.CHALLENGE_EARTHQUAKE_ACTION_KEY) {
                    action.speed = 1
                }
            }
        }
    }
}
