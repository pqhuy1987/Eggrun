//
//  EndingLayer.swift
//  EggieRun
//
//  Created by  light on 2016/04/08.
//  Copyright © 2016年 Eggieee. All rights reserved.
//

// Class: NormalEndLayer
// Description: the layer to be displayed when the Eggie die on the half way.
// It animates the process of generating a dish.

import SpriteKit

class NormalEndLayer: SKSpriteNode {
    fileprivate var dish: Dish
    fileprivate var background: SKSpriteNode!
    fileprivate var bar: SKSpriteNode!
    fileprivate(set) var eggdexButton: SKSpriteNode!
    fileprivate(set) var playButton: SKSpriteNode!
    fileprivate var beam: SKSpriteNode!
    fileprivate var beamAction: SKAction
    fileprivate static let BEAM_TIME_PER_FRAME = 0.005
    fileprivate static let BACKGROUND_Z_POSITION: CGFloat = 0
    fileprivate static let BAR_Y_POSITION: CGFloat = -291
    fileprivate static let BUTTON_Y_POSITION: CGFloat = -330
    fileprivate static let BUTTON_X_POSITION: CGFloat = -220
    fileprivate static let BUTTON_Z_POSITION: CGFloat = 1
    fileprivate static let DISH_Z_POSITION: CGFloat = 2
    fileprivate static let TITLE_Y_POSITION: CGFloat = 250
    fileprivate static let BEAM_Z_POSITION: CGFloat = 1
    fileprivate static let STAR_DISTANCE = 80
    fileprivate static let ACTION_DURATION: Double = 0.5
    fileprivate static let STAR_ANIMATION_DURATION: Double = 2
    fileprivate static let STAR_SMALL_SCALE: CGFloat = 1
    fileprivate static let STAR_BIG_SCALE: CGFloat = 5
    fileprivate static let BEAM_ATLAS_NAME = "beam.atlas"
    fileprivate static let BEAM_ONE_IMAGE_NAME = "ending-beam-1"
    fileprivate static let BACKGROUND_IMAGE_NAME = "ending-background"
    fileprivate static let ENDING_BAR_IMAGE_NAME = "ending-bar"
    fileprivate static let EGGDEX_BUTTON_IMAGE_NAME = "ending-eggdex-button"
    fileprivate static let PLAY_BUTTON_IMAGE_NAME = "ending-play-button"
    fileprivate static let STAR_IMAGE_NAME = "ending-star"
    
    init(usedCooker: Cooker, generatedDish: Dish, isNew: Bool) {
        let beamAtlas = SKTextureAtlas(named: NormalEndLayer.BEAM_ATLAS_NAME)
        let sortedBeamTextureNames = beamAtlas.textureNames.sorted()
        let beamTextures = sortedBeamTextureNames.map({ beamAtlas.textureNamed($0) })
        beamAction = SKAction.repeatForever(SKAction.animate(with: beamTextures, timePerFrame: NormalEndLayer.BEAM_TIME_PER_FRAME))
        dish = generatedDish
        super.init(texture: nil, color: UIColor.clear, size: UIScreen.main.bounds.size)
        fadeInBackground()
        fadeInBar()
        fadeInButton()
        displayDish()
        displayTitle()
        showStars(generatedDish.rarity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func fadeInBackground() {
        background = SKSpriteNode(imageNamed: NormalEndLayer.BACKGROUND_IMAGE_NAME)
        background.zPosition = NormalEndLayer.BACKGROUND_Z_POSITION
        fadeIn(background)
    }
    
    fileprivate func fadeInBar() {
        bar = SKSpriteNode(imageNamed: NormalEndLayer.ENDING_BAR_IMAGE_NAME)
        bar.zPosition = NormalEndLayer.BACKGROUND_Z_POSITION
        bar.position.y = NormalEndLayer.BAR_Y_POSITION
        fadeIn(bar)
    }
    
    fileprivate func fadeInButton() {
        eggdexButton = SKSpriteNode(imageNamed: NormalEndLayer.EGGDEX_BUTTON_IMAGE_NAME)
        eggdexButton.zPosition = NormalEndLayer.BUTTON_Z_POSITION
        eggdexButton.position.y = NormalEndLayer.BUTTON_Y_POSITION
        eggdexButton.position.x = NormalEndLayer.BUTTON_X_POSITION
        
        playButton = SKSpriteNode(imageNamed: NormalEndLayer.PLAY_BUTTON_IMAGE_NAME)
        playButton.zPosition = NormalEndLayer.BUTTON_Z_POSITION
        playButton.position.y = NormalEndLayer.BUTTON_Y_POSITION
        playButton.position.x = -NormalEndLayer.BUTTON_X_POSITION
        
        fadeIn(eggdexButton)
        fadeIn(playButton)
    }
    
    fileprivate func fadeIn(_ node: SKSpriteNode) {
        node.alpha = 0
        addChild(node)
        let fadeInAction = SKAction.fadeIn(withDuration: NormalEndLayer.ACTION_DURATION)
        node.run(fadeInAction)
    }
    
    fileprivate func displayDish() {
        let dishImage = SKSpriteNode(texture: dish.texture)
        let scaleUpAction = SKAction.scale(to: 1, duration: NormalEndLayer.ACTION_DURATION)
        dishImage.setScale(0)
        dishImage.zPosition = NormalEndLayer.DISH_Z_POSITION
        addChild(dishImage)
        dishImage.alpha = 1
        dishImage.run(scaleUpAction, completion: { () -> Void in
            self.animateBeam()
        })
    }
    
    fileprivate func displayTitle() {
        let dishTitle = SKSpriteNode(imageNamed: dish.titleImageNamed)
        let scaleUpAction = SKAction.scale(to: 1, duration: NormalEndLayer.ACTION_DURATION)
        dishTitle.setScale(0)
        dishTitle.zPosition = NormalEndLayer.DISH_Z_POSITION
        dishTitle.position.y = NormalEndLayer.TITLE_Y_POSITION
        addChild(dishTitle)
        dishTitle.alpha = 1
        dishTitle.run(scaleUpAction)
    }
    
    fileprivate func animateBeam() {
        beam = SKSpriteNode(imageNamed: NormalEndLayer.BEAM_ONE_IMAGE_NAME)
        beam.zPosition = NormalEndLayer.BEAM_Z_POSITION
        addChild(beam)
        beam.run(beamAction)
    }
    
    fileprivate func showStars(_ count: Int) {
        let distance = NormalEndLayer.STAR_DISTANCE
        let halfCount: Int = count / 2
        let evenFirstXPosition = -(distance / 2 + (halfCount - 1) * distance)
        let oddFirstXPosition = -(halfCount * distance)
        let firstXPosition = (count % 2 == 0) ?  evenFirstXPosition : oddFirstXPosition
        var starActions = [SKAction]()
        for i in 0..<count {
            let currentXPosition = CGFloat(firstXPosition + distance * i)
            let currentStar = SKSpriteNode(imageNamed: NormalEndLayer.STAR_IMAGE_NAME)
            currentStar.position.x = currentXPosition
            currentStar.position.y = -NormalEndLayer.TITLE_Y_POSITION
            currentStar.zPosition = NormalEndLayer.DISH_Z_POSITION
            starActions.append(SKAction.run({ () -> Void in
                self.animateStar(currentStar)
            }))
        }
        run(SKAction.sequence(starActions))
    }
    
    fileprivate func animateStar(_ star: SKSpriteNode) {
        star.setScale(NormalEndLayer.STAR_BIG_SCALE)
        star.alpha = 0
        let scaleDownAction = SKAction.scale(to: NormalEndLayer.STAR_SMALL_SCALE, duration: NormalEndLayer.ACTION_DURATION)
        let fadeInAction = SKAction.fadeIn(withDuration: NormalEndLayer.ACTION_DURATION)
        addChild(star)
        let waitAction = SKAction.wait(forDuration: NormalEndLayer.STAR_ANIMATION_DURATION)
        let group = SKAction.group([scaleDownAction, fadeInAction])
        let sequence = SKAction.sequence([group, waitAction])
        star.run(sequence)
    }
}
