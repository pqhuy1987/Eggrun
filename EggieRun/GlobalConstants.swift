//
//  Constants.swift
//  EggieRun
//
//  Created by Liu Yang on 19/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import UIKit

struct GlobalConstants {
    static let PHYSICS_BODY_ALPHA_THRESHOLD: Float = 0.9
    static let EGGIE_MASS: CGFloat = 1
    static let EGGIE_MAX_Y_SPEED = EGGIE_JUMPING_ACCELERATION.dy * 2
    static let EGGIE_JUMPING_ACCELERATION = CGVectorMake(0, 1000)
    static let GRAVITY = CGVectorMake(0, -20)
    static let IS_DEMO = true
    
    static let DEV_DISTANCE_DIVISOR = 3
}
