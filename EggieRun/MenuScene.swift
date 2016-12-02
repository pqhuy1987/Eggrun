//
//  MenuScene.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/18/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    static fileprivate let START_BUTTON_IMAGENAMED = "start-button"
    static fileprivate let DEX_BUTTON_IMAGENAMED = "eggdex-button"
    static fileprivate let MUTE_BUTTON_IMAGENAMED = "mute-button"
    
    static fileprivate let START_BUTTON_POSITION = CGPoint(x: 215, y: 420)
    static fileprivate let DEX_BUTTON_POSITION = CGPoint(x: 210, y: 270)
    static fileprivate let MUTE_BUTTON_OFFSET: CGFloat = 30
    static fileprivate let MUTE_BUTTON_SIZE = CGSize(width: 40, height: 40)
    
    static fileprivate let MUTE_BUTTON_ALPHA_ON: CGFloat = 1
    static fileprivate let MUTE_BUTTON_ALPHA_OFF: CGFloat = 0.4
    
    static fileprivate let TRANSITION = SKTransition.doorsOpenVertical(withDuration: 0.5)
    static let BACK_TRANSITION = SKTransition.doorsCloseVertical(withDuration: 0.5)
    
    static let singleton = MenuScene(fileNamed: "MenuScene")
    
    fileprivate var buttonPlay: SKSpriteNode!
    fileprivate var buttonDex: SKSpriteNode!
    fileprivate var buttonMute: SKSpriteNode!
    
    fileprivate var initialized = false
    
    override func didMove(to view: SKView) {
        BGMPlayer.singleton.moveToStatus(.menu)
        
        if initialized {
            return
        }
        initialized = true
        
        changeBackground("menu-background")
        
        buttonPlay = SKSpriteNode(imageNamed: MenuScene.START_BUTTON_IMAGENAMED)
        buttonPlay.position = MenuScene.START_BUTTON_POSITION
        self.addChild(buttonPlay)
        
        buttonDex = SKSpriteNode(imageNamed: MenuScene.DEX_BUTTON_IMAGENAMED)
        buttonDex.position = MenuScene.DEX_BUTTON_POSITION
        self.addChild(buttonDex)
        
        buttonMute = SKSpriteNode(imageNamed: MenuScene.MUTE_BUTTON_IMAGENAMED)
        buttonMute.size = MenuScene.MUTE_BUTTON_SIZE
        buttonMute.position = CGPoint(x: frame.maxX - MenuScene.MUTE_BUTTON_OFFSET, y: frame.maxY - MenuScene.MUTE_BUTTON_OFFSET)
        buttonMute.alpha = MenuScene.MUTE_BUTTON_ALPHA_OFF
        self.addChild(buttonMute)
        
        DishDataController.singleton
    }
    
    fileprivate func toggleMuted() {
        if BGMPlayer.singleton.muted {
            BGMPlayer.singleton.muted = false
            buttonMute.alpha = MenuScene.MUTE_BUTTON_ALPHA_OFF
        } else {
            BGMPlayer.singleton.muted = true
            buttonMute.alpha = MenuScene.MUTE_BUTTON_ALPHA_ON
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        
        if buttonPlay.contains(touchLocation) {
            let gameScene = GameScene(size: self.size)
            self.view?.presentScene(gameScene, transition: MenuScene.TRANSITION)
        } else if buttonDex.contains(touchLocation) {
            let dexScene = DexScene(size: self.size)
            self.view?.presentScene(dexScene, transition: MenuScene.TRANSITION)
        } else if buttonMute.contains(touchLocation) {
            toggleMuted()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
